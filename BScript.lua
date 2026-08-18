local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()

-- ============================================
-- 品牌配置（改这 4 行就行）
-- ============================================
local BRAND = {
    name    = "BI脚本",
    version = "v1.0.0.0",
    author  = "BI",
    folder  = "B_Hub",
    icon    = "zap",
    theme   = "Dark",
    accent  = "#0xFFAC9B00",
}

-- ============================================
-- 主窗口
-- ============================================
local Window = WindUI:CreateWindow({
    Title       = BRAND.name,
    Icon        = BRAND.icon,
    IconThemed  = true,
    Author      = BRAND.version,
    Folder      = BRAND.folder,
    Size        = UDim2.fromOffset(580, 440),
    Transparent = true,
    Theme       = BRAND.theme,
    HideSearchBar = false,
    Resizable   = true,
    SideBarWidth = 240,

    Search = {
        Enabled = true,
        Placeholder = "搜索...",
        Callback = function(text) end,
    },

    User = {
        Enabled = true,
        Callback = function()
            WindUI:Notify({
                Title    = "玩家信息",
                Content  = game.Players.LocalPlayer.Name,
                Duration = 2,
                Icon     = "user"
            })
        end,
    },
})

-- ============================================
-- 顶部主题切换按钮
-- ============================================
Window:CreateTopbarButton("ThemeToggle", "moon", function()
    local current = WindUI:GetCurrentTheme()
    if current == "Light" then
        WindUI:SetTheme("Dark")
        WindUI:Notify({ Title = "已切换暗黑主题", Duration = 2, Icon = "moon" })
    else
        WindUI:SetTheme("Light")
        WindUI:Notify({ Title = "已切换明亮主题", Duration = 2, Icon = "sun" })
    end
end, 990)

-- ============================================
-- 屏幕浮动打开按钮（小球）
-- ============================================
Window:EditOpenButton({
    Title           = BRAND.name,
    Icon            = BRAND.icon,
    CornerRadius    = UDim.new(0, 26),
    StrokeThickness = 4,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,   Color3.fromHex("ADD8E6")),
        ColorSequenceKeypoint.new(0.5, Color3.fromHex("4169E1")),
        ColorSequenceKeypoint.new(1,   Color3.fromHex("ADD8E6")),
    }),
    Draggable = true,
})

-- ============================================
-- 角标标签
-- ============================================
Window:Tag({
    Title = BRAND.name .. " " .. BRAND.version,
    Color = Color3.fromHex(BRAND.accent)
})

local timeTag = Window:Tag({
    Title = os.date("%H:%M:%S"),
    Color = Color3.fromHex("#00ffff")
})
task.spawn(function()
    while Window do
        task.wait(1)
        pcall(function() timeTag:SetTitle(os.date("%H:%M:%S")) end)
    end
end)

--
-- 创建功能分类标签页
-- 
local Tabs = {" 功能", " 公告"}
local Btns = {}
local Pages = {}
local yPos = 15

for i, name in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 42)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundTransparency = 1
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Sidebar
    table.insert(Btns, btn)
    
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -10, 1, -10)
    page.Position = UDim2.new(0, 5, 0, 5)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = Content
    table.insert(Pages, page)
    
    btn.MouseButton1Click:Connect(function()
        for _, b in ipairs(Btns) do b.TextColor3 = Color3.fromRGB(180, 180, 180); b.BackgroundTransparency = 1 end
        for _, p in ipairs(Pages) do p.Visible = false end
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        btn.BackgroundTransparency = 0.2
        page.Visible = true
    end)
    yPos = yPos + 50
end

Btns[1].TextColor3 = Color3.fromRGB(255, 255, 255)
Btns[1].BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Btns[1].BackgroundTransparency = 0.2
Pages[1].Visible = true

local function CreateButton(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 50)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.BackgroundTransparency = 0.2
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Parent = Pages[1]
    Instance.new("UICorner", {CornerRadius = UDim.new(0, 10), Parent = btn})
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local isFlying = false
local flyLoop = nil
local function ToggleFly()
    isFlying = not isFlying
    if isFlying then
        if flyLoop then flyLoop:Disconnect(); flyLoop = nil end
        flyLoop = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if not char then return end
            local hum = char:FindFirstChild("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")
            if hum and root then
                hum.PlatformStand = true
                local moveDir = Vector3.new(0, 0, 0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir + Vector3.new(0, -1, 0) end
                root.Velocity = Vector3.new(moveDir.X * 40, moveDir.Y * 25, moveDir.Z * 40)
            end
        end)
        game:GetService("StarterGui"):SetCore("SendNotification", {Title="BI脚本", Text="飞行开启", Duration=2})
    else
        if flyLoop then flyLoop:Disconnect(); flyLoop = nil end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
        end
        game:GetService("StarterGui"):SetCore("SendNotification", {Title="BI脚本", Text="飞行关闭", Duration=2})
    end
end
 
-- Anti-AFK
-- ============================================
local VirtualUser = game:GetService("VirtualUser")
game.Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- 暴露全局
_G._LCF_WindUI = WindUI
_G._LCF_TmplWin = Window


print("[" .. BRAND.name .. "] UI 纯净模板已加载 ✅")