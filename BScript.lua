-- BScript 核心 UI 引擎
local BScriptUI = {}

local LocalPlayer = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BScriptMainUI"
ScreenGui.Parent = PlayerGui
ScreenGui.IgnoreGuiInset = true

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 320, 0, 400)
Main.Position = UDim2.new(0.5, -160, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
Main.BackgroundTransparency = 0.15
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = Main

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Header.BackgroundTransparency = 0.2
Header.Parent = Main

local HCorner = Instance.new("UICorner")
HCorner.CornerRadius = UDim.new(0, 12)
HCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "B脚本"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local BtnClose = Instance.new("TextButton")
BtnClose.Size = UDim2.new(0, 30, 0, 30)
BtnClose.Position = UDim2.new(1, -35, 0, 7)
BtnClose.BackgroundTransparency = 1
BtnClose.Text = "X"
BtnClose.TextColor3 = Color3.fromRGB(200, 200, 200)
BtnClose.Font = Enum.Font.GothamBold
BtnClose.Parent = Header
BtnClose.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -20, 1, -60)
ContentArea.Position = UDim2.new(0, 10, 0, 55)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = Main

local dragging, dragInput, mousePos, framePos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = Main.Position
    end
end)
Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        Main.Position = UDim2.new(0, framePos.X.Offset + delta.X, 0, framePos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

function BScriptUI:CreateSection()
    local Section = Instance.new("Frame")
    Section.Size = UDim2.new(1, 0, 0, 100)
    Section.BackgroundTransparency = 1
    Section.Parent = ContentArea
    return Section
end

function BScriptUI:AddButton(section, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.BackgroundTransparency = 0.3
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.Parent = section
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn
    btn.MouseButton1Click:Connect(callback)
end

function BScriptUI:AddLabel(section, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 30)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = section
end

function BScriptUI:SendNotification(title, text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", { Title = title, Text = text, Duration = duration or 5 })
end

return BScriptUI