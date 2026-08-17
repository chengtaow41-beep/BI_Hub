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

    -- ==========================================
-- 将这段话放入你的 BI脚本 UI 分类中
-- ==========================================
local MainFly = Window:Tab({
    Title = "完美飞行",
    Icon = "plane"
})

local isFlying = false
local flyConnection = nil
local flySpeed = 20 -- 基础飞行速度

MainFly:Button({
    Title = "切换 飞行/降落",
    Callback = function()
        isFlying = not isFlying
        
        local player = game.Players.LocalPlayer
        local char = player.Character
        local hum = char and char:FindFirstChildWhichIsA("Humanoid")
        
        if not isFlying then
            -- 如果关闭飞行
            if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
            if hum then
                hum.PlatformStand = false
                hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
                if char:FindFirstChild("Animate") then char.Animate.Disabled = false end
            end
            WindUI:Notify({ Title = "BI脚本", Content = "已降落 / 飞行关闭", Duration = 2 })
            return
        end
        
        WindUI:Notify({ Title = "BI脚本", Content = "飞行开启！W上升 / S下降", Duration = 3 })
        
        -- 核心循环：让玩家无视重力
        flyConnection = game:GetService("RunService").Stepped:Connect(function()
            if not isFlying then return end
            
            local char = player.Character
            if not char or not char:FindFirstChild("HumanoidRootPart") then return end
            
            local root = char.HumanoidRootPart
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            if not hum then return end
            
            -- 强制开启平台站立（核心飞行姿势）
            hum.PlatformStand = true
            hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
            if char:FindFirstChild("Animate") then char.Animate.Disabled = true end
            
            -- 读取键盘输入控制速度
            local moveDir = Vector3.new(0, 0, 0)
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir + Vector3.new(0, -1, 0) end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir + Vector3.new(-1, 0, 0) end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Vector3.new(1, 0, 0) end
            
            -- 应用力到身体上
            root.Velocity = Vector3.new(moveDir.X * 50, moveDir.Y * 35, moveDir.Z * 50)
        end)
    end
})

-- 增加一个调节速度的滑块（给你做的高级元素）
MainFly:Slider({
    Title = "飞行速度调节",
    Value = { Min = 10, Max = 100, Default = 50 },
    Increment = 5,
    Callback = function(val)
        flySpeed = val
        WindUI:Notify({ Title = "BI脚本", Content = "飞行速度调整至: "..val, Duration = 1 })
    end
})
        -- 这里面就是飞行的核心代码
         -- 开启平台站立，类似飞行
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