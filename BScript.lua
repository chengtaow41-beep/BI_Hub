local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Old = PlayerGui:FindFirstChild("BIYI_Main")
if Old then Old:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BIYI_Main"
ScreenGui.Parent = PlayerGui
ScreenGui.IgnoreGuiInset = true

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 480)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
MainFrame.BackgroundTransparency = 0.08
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Header.BackgroundTransparency = 0.2
Header.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = Header

local TitleName = Instance.new("TextLabel")
TitleName.Size = UDim2.new(0.5, 0, 1, 0)
TitleName.Position = UDim2.new(0, 12, 0, 0)
TitleName.BackgroundTransparency = 1
TitleName.Text = "BI 脚本"
TitleName.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleName.Font = Enum.Font.GothamBold
TitleName.TextSize = 16
TitleName.TextXAlignment = Enum.TextXAlignment.Left
TitleName.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 10)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 100, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
Sidebar.BackgroundTransparency = 0.2
Sidebar.Parent = MainFrame

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(0, 320, 1, -50)
ContentArea.Position = UDim2.new(0, 100, 0, 50)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local Tabs = {"📢 公告", "⚡ 玩家功能", "👁️ 透视功能"}
local TabButtons = {}
local Pages = {}

local function CreateTab(name, index)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.Position = UDim2.new(0, 0, 0, 10 + ((index - 1) * 48))
    btn.BackgroundTransparency = 1
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.fromRGB(160, 160, 160)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Sidebar
    
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -10, 1, -10)
    page.Position = UDim2.new(0, 5, 0, 5)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = ContentArea
    
    return btn, page
end

for i, name in ipairs(Tabs) do
    local b, p = CreateTab(name, i)
    table.insert(TabButtons, b)
    table.insert(Pages, p)
    
    b.MouseButton1Click:Connect(function()
        for _, tb in ipairs(TabButtons) do tb.TextColor3 = Color3.fromRGB(160, 160, 160); tb.BackgroundTransparency = 1 end
        for _, pg in ipairs(Pages) do pg.Visible = false end
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        b.BackgroundTransparency = 0.3
        p.Visible = true
    end)
end

TabButtons[1].TextColor3 = Color3.fromRGB(255, 255, 255)
TabButtons[1].BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TabButtons[1].BackgroundTransparency = 0.3
Pages[1].Visible = true

local NoticeBox = Instance.new("Frame")
NoticeBox.Size = UDim2.new(1, -10, 0, 160)
NoticeBox.Position = UDim2.new(0, 5, 0, 10)
NoticeBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
NoticeBox.BackgroundTransparency = 0.2
NoticeBox.Parent = Pages[1]

local NCorner = Instance.new("UICorner")
NCorner.CornerRadius = UDim.new(0, 8)
NCorner.Parent = NoticeBox

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "<b>BI 脚本公告</b>"
TitleLabel.RichText = true
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.Parent = NoticeBox

local DescText = Instance.new("TextLabel")
DescText.Size = UDim2.new(1, 0, 1, -30)
DescText.Position = UDim2.new(0, 0, 0, 30)
DescText.BackgroundTransparency = 1
DescText.Text = "永久免费！永不跑路！\n\nBI 脚本专属\n交流群：待定"
DescText.TextColor3 = Color3.fromRGB(220, 220, 220)
DescText.Font = Enum.Font.Gotham
DescText.TextSize = 14
DescText.Parent = NoticeBox

local DataPanel = Instance.new("Frame")
DataPanel.Size = UDim2.new(1, -10, 0, 70)
DataPanel.Position = UDim2.new(0, 5, 0, 190)
DataPanel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
DataPanel.BackgroundTransparency = 0.3
DataPanel.Parent = Pages[1]

local DCorner = Instance.new("UICorner")
DCorner.CornerRadius = UDim.new(0, 8)
DCorner.Parent = DataPanel

local DataText = Instance.new("TextLabel")
DataText.Size = UDim2.new(1, 0, 1, 0)
DataText.BackgroundTransparency = 1
DataText.TextColor3 = Color3.fromRGB(255, 255, 255)
DataText.Font = Enum.Font.Gotham
DataText.TextSize = 13
DataText.TextXAlignment = Enum.TextXAlignment.Left
DataText.Parent = DataPanel

local function UpdateData()
    local char = LocalPlayer.Character
    local health = char and char:FindFirstChild("Humanoid") and char.Humanoid.Health or 0
    local maxHealth = char and char:FindFirstChild("Humanoid") and char.Humanoid.MaxHealth or 100
    DataText.Text = string.format("  当前玩家: %s\n  当前血量: %.0f / %.0f", LocalPlayer.Name, health, maxHealth)
end
task.spawn(function() while task.wait(1) do UpdateData() end end)

local ActionList = Instance.new("Frame")
ActionList.Size = UDim2.new(1, 0, 1, 0)
ActionList.BackgroundTransparency = 1
ActionList.Parent = Pages[2]

local Actions = {"无限跳跃 (开启)", "回满血量", "加载飞行"}
local yPos = 10

for i, act in ipairs(Actions) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.BackgroundTransparency = 0.2
    btn.Text = act
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = ActionList
    
    local BCorner = Instance.new("UICorner")
    BCorner.CornerRadius = UDim.new(0, 6)
    BCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        if act == "无限跳跃 (开启)" then
            LocalPlayer.Character.Humanoid.JumpPower = 100
        elseif act == "回满血量" then
            LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
        elseif act == "加载飞行" then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Xingtaiduan/Script/main/Content/FlyGuiV3"))()
        end
    end)
    
    yPos = yPos + 45
end

local Footer = Instance.new("Frame")
Footer.Size = UDim2.new(1, 0, 0, 40)
Footer.Position = UDim2.new(0, 0, 1, -40)
Footer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Footer.BackgroundTransparency = 0.2
Footer.Parent = MainFrame

local FCorner = Instance.new("UICorner")
FCorner.CornerRadius = UDim.new(0, 12)
FCorner.Parent = Footer

local Avatar = Instance.new("ImageLabel")
Avatar.Size = UDim2.new(0, 30, 0, 30)
Avatar.Position = UDim2.new(0, 10, 0.5, -15)
Avatar.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
Avatar.Image = "rbxassetid://129260712070622"
Avatar.Parent = Footer
local ACorner = Instance.new("UICorner")
ACorner.CornerRadius = UDim.new(1, 0)
ACorner.Parent = Avatar

local AuthorText = Instance.new("TextLabel")
AuthorText.Size = UDim2.new(0, 150, 1, 0)
AuthorText.Position = UDim2.new(0, 50, 0, 0)
AuthorText.BackgroundTransparency = 1
AuthorText.Text = "<b>作者：你</b>\nBI脚本专属"
AuthorText.RichText = true
AuthorText.TextColor3 = Color3.fromRGB(200, 200, 200)
AuthorText.Font = Enum.Font.Gotham
AuthorText.TextSize = 12
AuthorText.TextXAlignment = Enum.TextXAlignment.Left
AuthorText.Parent = Footer

local dragging, dragInput, mousePos, framePos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; mousePos = input.Position; framePos = MainFrame.Position
    end
end)
Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        MainFrame.Position = UDim2.new(0, framePos.X.Offset + delta.X, 0, framePos.Y.Offset + delta.Y)
    end
end)
game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("BI 脚本 高级 UI 已成功加载！")