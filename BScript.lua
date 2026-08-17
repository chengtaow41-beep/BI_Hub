-- ==========================================
-- BI脚本 (全包直显版)
-- ==========================================
local LocalPlayer = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local OldUI = PlayerGui:FindFirstChild("BIYI_Main")
if OldUI then OldUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BIYI_Main"
ScreenGui.Parent = PlayerGui
ScreenGui.IgnoreGuiInset = true

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 320, 0, 400)
Main.Position = UDim2.new(0.5, -160, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.BackgroundTransparency = 0.1
Main.Active = true
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
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "BI脚本"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
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
BtnClose.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local NoticeFrame = Instance.new("Frame")
NoticeFrame.Size = UDim2.new(1, -20, 0, 160)
NoticeFrame.Position = UDim2.new(0, 10, 0, 60)
NoticeFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
NoticeFrame.BackgroundTransparency = 0.2
NoticeFrame.Parent = Main

local NCorner = Instance.new("UICorner")
NCorner.CornerRadius = UDim.new(0, 8)
NCorner.Parent = NoticeFrame

local NoticeText = Instance.new("TextLabel")
NoticeText.Size = UDim2.new(1, 0, 1, 0)
NoticeText.BackgroundTransparency = 1
NoticeText.Text = "BI脚本 已成功启动！\n\n永久免费！永不跑路！\n\n按住顶栏可拖动位置"
NoticeText.TextColor3 = Color3.fromRGB(255, 255, 255)
NoticeText.Font = Enum.Font.Gotham
NoticeText.TextSize = 14
NoticeText.Parent = NoticeFrame

local ActionBtn = Instance.new("TextButton")
ActionBtn.Size = UDim2.new(0.8, 0, 0, 45)
ActionBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
ActionBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ActionBtn.BackgroundTransparency = 0.3
ActionBtn.Text = "无限跳跃 (开关)"
ActionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ActionBtn.Font = Enum.Font.GothamBold
ActionBtn.TextSize = 14
ActionBtn.Parent = Main

local ABtnCorner = Instance.new("UICorner")
ABtnCorner.CornerRadius = UDim.new(0, 8)
ABtnCorner.Parent = ActionBtn

local jumpState = false
ActionBtn.MouseButton1Click:Connect(function()
    jumpState = not jumpState
    if jumpState then
        ActionBtn.Text = "无限跳跃 (开启中)"
        ActionBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        game:GetService("RunService").Stepped:Connect(function()
            if jumpState and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Jump = true
            end
        end)
    else
        ActionBtn.Text = "无限跳跃 (开关)"
        ActionBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

local dragging, dragInput, mousePos, framePos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; mousePos = input.Position; framePos = Main.Position
    end
end)
Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
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

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "BI脚本";
    Text = "UI 加载成功！按住顶栏可拖动";
    Duration = 5;
})

task.wait(1)
Main.Visible = true