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
local Tab_Player = Window:Tab({
    Title = "玩家功能",
    Icon = "user"
})

-- 添加一个按钮
Tab_Player:Button({
    Title = "回满血量",
    Desc = "点击立刻恢复满血",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.Health = char.Humanoid.MaxHealth
            WindUI:Notify({
                Title = "B脚本",
                Content = "血量已恢复！",
                Duration = 2,
                Icon = "heart"
            })
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