local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Old = PlayerGui:FindFirstChild("BIYI_UI")
if Old then Old:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BIYI_UI"
ScreenGui.Parent = PlayerGui
ScreenGui.IgnoreGuiInset = true

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 390, 0, 370)
MainFrame.Position = UDim2.new(0.15, 0, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.1
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 38)
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
TitleName.TextSize = 15
TitleName.TextXAlignment = Enum.TextXAlignment.Left
TitleName.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 6)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 90, 1, -38)
Sidebar.Position = UDim2.new(0, 0, 0, 38)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Sidebar.BackgroundTransparency = 0.1
Sidebar.Parent = MainFrame

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(0, 300, 1, -38)
ContentArea.Position = UDim2.new(0, 90, 0, 38)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local Tabs = {"📢 公告", "⚡ 玩家功能"}
local TabButtons = {}
local Pages = {}

local function CreateTab(name, index)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.Position = UDim2.new(0, 0, 0, 8 + ((index - 1) * 42))
    btn.BackgroundTransparency = 1
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.fromRGB(170, 170, 170)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Sidebar

    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -8, 1, -8)
    page.Position = UDim2.new(0, 4, 0, 4)
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
        for _, tb in ipairs(TabButtons) do tb.TextColor3 = Color3.fromRGB(170, 170, 170); tb.BackgroundTransparency = 1 end
        for _, pg in ipairs(Pages) do pg.Visible = false end
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        b.BackgroundTransparency = 0.2
        p.Visible = true
    end)
end

TabButtons[1].TextColor3 = Color3.fromRGB(255, 255, 255)
TabButtons[1].BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TabButtons[1].BackgroundTransparency = 0.2
Pages[1].Visible = true

local NotiBox = Instance.new("Frame")
NotiBox.Size = UDim2.new(1, -10, 0, 180)
NotiBox.Position = UDim2.new(0, 5, 0, 15)
NotiBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
NotiBox.BackgroundTransparency = 0.2
NotiBox.Parent = Pages[1]

local NotiCorner = Instance.new("UICorner")
NotiCorner.CornerRadius = UDim.new(0, 8)
NotiCorner.Parent = NotiBox

local NotiText = Instance.new("TextLabel")
NotiText.Size = UDim2.new(1, 0, 1, 0)
NotiText.BackgroundTransparency = 1
NotiText.Text = "BI 脚本\n\n永久免费！永不跑路！\n交流群：待定\n\n按住顶栏 "BI 脚本" 可拖动"
NotiText.TextColor3 = Color3.fromRGB(255, 255, 255)
NotiText.Font = Enum.Font.Gotham
NotiText.TextSize = 13
NotiText.Parent = NotiBox

local dragging = false
local dragInput, mousePos, framePos
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
        local delta= input.Position - mousePos
        MainFrame.Position = UDim2.new(0, framePos.X.Offset + delta.X, 0, framePos.Y.Offset + delta.Y)
    end
end)
game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)