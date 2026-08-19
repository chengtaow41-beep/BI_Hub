local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()

-- ============================================
-- 品牌配置（改这 4 行就行）
-- ============================================
local BRAND = {
    name    = "风脚本",
    version = "v1.0.0.0",
    author  = "FEN",
    folder  = "FEN_Hub",
    icon    = "zap",
    theme   = "Dark",
    accent  = "#FFAC9B",
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

--====================================
-- 创建Tab分类标签页
-- ===================================
local AnnounceTab = Window:Tab({
    Title = "公告",
    Icon = "megaphone"
})
AnnounceTab:Section({
    Title = "风脚本",
    Desc = "永久免费\n公益脚本禁止倒卖，认准风脚本"
})
AnnounceTab:Button({
     Title = "风脚本主群",
     Desc = "群聊暂时不定",
     Callback = function()
         setclipboard("待定")
         WindUI:Notify({
             Title = "已复制群号",
             Content = "待定",
             Duration = 2
         })
     end
})

 local MiscTab = Window:Tab({
     Title = "通用",
     Icon = "settings"
 })
local TargetWalkSpeed = 16
local OriginalWalkSpeed = 16
local speedToggleOn = false

MiscTab:Slider({
    Title = "速度数值",
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = function(value)
        TargetWalkSpeed = value
        -- 只要在游戏里，立刻修改速度上限 (不管开关开没开)
        local char = game.Players.LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = TargetWalkSpeed
            end
        end
        Window:Notify({ Title = "BI脚本", Content = "速度已设为: "..TargetWalkSpeed, Duration = 2 })
    end
})

MiscTab:Toggle({
    Title = "开启速度修改",
    Value = false,
    Callback = function(v)
        speedToggleOn = v
        local char = game.Players.LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        if v then
            OriginalWalkSpeed = hum.WalkSpeed
            hum.WalkSpeed = TargetWalkSpeed
            Window:Notify({ Title = "风脚本", Content = "加速已开启！", Duration = 2 })
        else
            hum.WalkSpeed = OriginalWalkSpeed
            Window:Notify({ Title = "风脚本", Content = "速度已恢复", Duration = 2 })
        end
    end
})

task.spawn(function()
    while task.wait(0.5) do
        if speedToggleOn then
            local char = game.Players.LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.WalkSpeed ~= TargetWalkSpeed then
                    hum.WalkSpeed = TargetWalkSpeed
                end
            end
        end
    end
end)

game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if speedToggleOn then
        local hum = char:WaitForChild("Humanoid")
        OriginalWalkSpeed = hum.WalkSpeed
        hum.WalkSpeed = TargetWalkSpeed
    end
end)

local VirtualUser = game:GetService("VirtualUser")
game.Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)
 local InfoTab = Window:Tab({
     Title = "服务器功能",
     Icon = "info"
 })
  
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