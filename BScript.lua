local WindUI = {}
WindUI.__index = WindUI

local cloneref = (cloneref or clonereference or function(instance) return instance end)
local HttpService = cloneref(game:GetService("HttpService"))
local Players = cloneref(game:GetService("Players"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local RunService = cloneref(game:GetService("RunService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local LocalPlayer = Players.LocalPlayer

function WindUI.GenerateGUID()
    return HttpService:GenerateGUID(false)
end

local CurInput = WindUI.GenerateGUID()
UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    task.defer(function()
        if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
            if WindUI.CurrentInput and WindUI.CurrentInput ~= CurInput then return end
            WindUI.CurrentInput = CurInput
        end
    end)
end)
UserInputService.InputEnded:Connect(function(Input, GameProcessed)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
        if WindUI.CurrentInput and WindUI.CurrentInput ~= CurInput then return end
        WindUI.CurrentInput = nil
    end
end)

local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end
local GUIParent = gethui and gethui() or (CoreGui or LocalPlayer:WaitForChild("PlayerGui"))

WindUI.ScreenGui = Instance.new("ScreenGui")
WindUI.ScreenGui.Name = "WindUI"
WindUI.ScreenGui.Parent = GUIParent
WindUI.ScreenGui.IgnoreGuiInset = true
WindUI.ScreenGui.ScreenInsets = "None"
WindUI.ScreenGui.DisplayOrder = -99999

Instance.new("Folder", { Name = "Window", Parent = WindUI.ScreenGui })
Instance.new("Folder", { Name = "Popups", Parent = WindUI.ScreenGui })

WindUI.NotificationGui = Instance.new("ScreenGui")
WindUI.NotificationGui.Name = "WindUI/Notifications"
WindUI.NotificationGui.Parent = GUIParent
WindUI.NotificationGui.IgnoreGuiInset = true

WindUI.DropdownGui = Instance.new("ScreenGui")
WindUI.DropdownGui.Name = "WindUI/Dropdowns"
WindUI.DropdownGui.Parent = GUIParent
WindUI.DropdownGui.IgnoreGuiInset = true

ProtectGui(WindUI.ScreenGui)
ProtectGui(WindUI.NotificationGui)
ProtectGui(WindUI.DropdownGui)

local function CreateWindow(config)
    local win = Instance.new("Frame")
    win.Size = config.Size or UDim2.new(0, 500, 0, 400)
    win.Position = config.Position or UDim2.new(0.5, -250, 0.5, -200)
    win.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    win.BackgroundTransparency = 0.1
    win.Parent = WindUI.ScreenGui.Window
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = win
    
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    header.BackgroundTransparency = 0.2
    header.Parent = win
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.6, 0, 1, 0)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = config.Title or "Window"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -20, 1, -60)
    content.Position = UDim2.new(0, 10, 0, 50)
    content.BackgroundTransparency = 1
    content.Parent = win
    
    local tabs = {}
    local function CreateTab(name, icon)
        local tab = Instance.new("TextButton")
        tab.Size = UDim2.new(0, 80, 0, 30)
        tab.Position = UDim2.new(0, 0, 0, 0)
        tab.BackgroundTransparency = 1
        tab.Text = name
        tab.TextColor3 = Color3.fromRGB(200, 200, 200)
        tab.Font = Enum.Font.Gotham
        tab.TextSize = 14
        tab.Parent = header
        
        local tabContent = Instance.new("Frame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false
        tabContent.Parent = content
        
        tab.MouseButton1Click:Connect(function()
            for _, t in pairs(tabs) do t.TextColor3 = Color3.fromRGB(200, 200, 200) end
            for _, c in pairs(content:GetChildren()) do if c:IsA("Frame") then c.Visible = false end end
            tab.TextColor3 = Color3.fromRGB(255, 255, 255)
            tabContent.Visible = true
        end)
        
        table.insert(tabs, tab)
        return {
            AddButton = function(btnConfig)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(0, 160, 0, 35)
                btn.Position = UDim2.new(0, 20, 0, 10 + #tabContent:GetChildren() * 45)
                btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                btn.BackgroundTransparency = 0.2
                btn.Text = btnConfig.Title
         btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 14
                btn.Parent = tabContent
                Instance.new("UICorner", {CornerRadius = UDim.new(0, 8), Parent = btn})
                btn.MouseButton1Click:Connect(btnConfig.Callback)
            end
        }
    end
    
    return { CreateTab = CreateTab }
end

WindUI.CreateWindow = CreateWindow

local Window = WindUI:CreateWindow({ Title = "BI 脚本", Size = UDim2.new(0, 480, 0, 400) })

local Tab1 = Window:CreateTab("公告", "home")
Tab1:AddButton({ Title = "永久免费！永不跑路！", Callback = function() end })

local Tab2 = Window:CreateTab("玩家功能", "settings")
Tab2:AddButton({ Title = "无限跳跃 (开启)", Callback = function()
    if game.Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 100
    end
end})

Tab2:AddButton({ Title = "回满血量", Callback = function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.Health = char.Humanoid.MaxHealth
    end
end})