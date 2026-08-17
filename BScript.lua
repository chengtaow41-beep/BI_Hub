local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()

-- ============================================
-- 品牌配置（改这 4 行就行）
-- ============================================
local BRAND = {
    name    = "BI脚本",
    version = "v1.0",
    author  = "BI",
    folder  = "BIHub",
    icon    = "zap",
    theme   = "Dark",
    accent  = "#FF6B35",
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

-- ============================================
-- 创建功能分类标签页
-- ============================================
-- 创建“通用功能”这个分类
local Tab_Utility = Window:Tab({
    Title = "通用功能",
    Icon = "zap" -- 你可以换成你想要的图标名字
})

-- 添加第一个功能：通用飞行
Tab_Utility:Button({
    Title = "通用飞行",
    Desc = "点击启用基础飞行",
    Callback = function()
        -- 这里面就是飞行的核心代码
        local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 防止重复生成 GUI
local oldGui = playerGui:FindFirstChild("NightFlyUI")
if oldGui then
        oldGui:Destroy()
end

-- =========================
-- 配置区
-- =========================

local UI_NAME = "NightFlyUI"
local TITLE_NAME = "夜脚本制作"
local TITLE_OFF = "夜脚本制作 · 开启飞行"
local TITLE_ON = "夜脚本制作 · 飞行中"

-- 用户看到的速度：1, 2, 3, 4...
local speed = 1
local minSpeed = 1
local maxSpeed = 80
local speedStep = 1

-- 每 1 点速度映射成多少真实速度
-- 想更快就改大，比如 70 / 90 / 120
local speedScale = 55

local function getRealSpeed()
        return speed * speedScale
end

-- =========================
-- UI 工具函数
-- =========================

local function addCorner(obj, radius)
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, radius or 6)
        corner.Parent = obj
        return corner
end

local function addStroke(obj, color, thickness)
        local stroke = Instance.new("UIStroke")
        stroke.Color = color or Color3.fromRGB(120, 120, 255)
        stroke.Thickness = thickness or 1
        stroke.Parent = obj
        return stroke
end

local function makeTextButton(parent, size, position, text)
        local btn = Instance.new("TextButton")
        btn.Size = size
        btn.Position = position
        btn.Text = text
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamBold
        btn.BackgroundColor3 = Color3.fromRGB(42, 42, 48)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.AutoButtonColor = true
        btn.Parent = parent

        addCorner(btn, 6)

        return btn
end

local function makeTextLabel(parent, size, position, text)
        local label = Instance.new("TextLabel")
        label.Size = size
        label.Position = position
        label.Text = text
        label.TextScaled = false
        label.TextSize = 15
        label.Font = Enum.Font.Gotham
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(230, 230, 230)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = parent

        return label
end

-- =========================
-- 创建 UI
-- =========================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = UI_NAME
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 190, 0, 126)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
mainFrame.BackgroundTransparency = 0.12
mainFrame.Active = true
mainFrame.Parent = screenGui

addCorner(mainFrame, 8)
addStroke(mainFrame, Color3.fromRGB(100, 100, 170), 1)

-- 顶部拖动栏
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, -8, 0, 28)
topBar.Position = UDim2.new(0, 4, 0, 4)
topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
topBar.BackgroundTransparency = 0.05
topBar.Active = true
topBar.Parent = mainFrame

addCorner(topBar, 6)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -38, 1, 0)
titleLabel.Position = UDim2.new(0, 8, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = TITLE_NAME
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = Color3.fromRGB(235, 235, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

local closeBtn = makeTextButton(
        topBar,
        UDim2.new(0, 26, 0, 22),
        UDim2.new(1, -30, 0, 3),
        "×"
)
closeBtn.BackgroundColor3 = Color3.fromRGB(95, 35, 45)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local toggleBtn = makeTextButton(
        mainFrame,
        UDim2.new(0, 174, 0, 32),
        UDim2.new(0, 8, 0, 38),
        TITLE_OFF
)
addStroke(toggleBtn, Color3.fromRGB(120, 120, 255), 1.5)

local speedLabel = makeTextLabel(
        mainFrame,
        UDim2.new(0, 174, 0, 20),
        UDim2.new(0, 8, 0, 73),
        ""
)

local minusBtn = makeTextButton(
        mainFrame,
        UDim2.new(0, 34, 0, 26),
        UDim2.new(0, 8, 0, 95),
        "-"
)

local plusBtn = makeTextButton(
        mainFrame,
        UDim2.new(0, 34, 0, 26),
        UDim2.new(0, 148, 0, 95),
        "+"
)

local speedHint = Instance.new("TextLabel")
speedHint.Size = UDim2.new(0, 100, 0, 26)
speedHint.Position = UDim2.new(0, 45, 0, 95)
speedHint.BackgroundTransparency = 1
speedHint.Text = "速度"
speedHint.TextScaled = true
speedHint.Font = Enum.Font.GothamBold
speedHint.TextColor3 = Color3.fromRGB(210, 210, 210)
speedHint.Parent = mainFrame

local function refreshSpeedLabel()
        speedLabel.Text = string.format("速度：%d  |  实速：%d", speed, getRealSpeed())
end

refreshSpeedLabel()

-- =========================
-- 拖动功能
-- =========================

local dragging = false
local dragStart = nil
local star -- 开启平台站立，类似飞行
            -- 如果你想找更完美的飞行代码，可以去搜 "Roblox Lua Fly script"
        end
    end
})

-- 添加第二个功能：车辆加速
Tab_Utility:Button({
    Title = "车辆加速",
    Desc = "让你开的车变得飞快",
    Callback = function()
        -- 车辆加速逻辑
        local car = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("VehicleSeat")
        if car and car.Parent and car.Parent:FindFirstChild("BodyVelocity") then
            car.Parent.BodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 10000 -- 给车加力
        end
    end
})

-- 添加第三个功能：无限子弹（开关）
Tab_Utility:Toggle({
    Title = "无限子弹",
    Value = false,
    Callback = function(state)
        if state then
            print("无限子弹已开启")
            -- 这里写开启无限子弹的代码
        else
            print("无限子弹已关闭")
        end
    end
})
-- 添加一个开关 (比如无限跳跃)
Tab_Player:Toggle({
    Title = "无限跳跃",
    Value = false,
    Callback = function(state)
        if state then
            loadstring(game:HttpGet("https://pastebin.com/raw/V5PQy3y0", true))()
        end
    end
})
-- ==========================================
-- 自己添加功能分类
-- ==========================================

-- 1. 添加一个分类叫“玩家功能”
local Tab_Player = Window:Tab({
    Title = "玩家功能",
    Icon = "user"
})

-- 2. 在这个分类下，加个“回血”按钮
Tab_Player:Button({
    Title = "立刻回满血",
    Desc = "点击回复 100% 血量",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.Health = char.Humanoid.MaxHealth
            WindUI:Notify({ Title = "B脚本", Content = "血量已拉满！", Duration = 2 })
        end
    end
})



-- ============================================
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