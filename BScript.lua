local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()


local BRAND = {
    name    = "风脚本",
    version = "v1.0.0.0",
    author  = "FEN",
    folder  = "FEN_Hub",
    icon    = "zap",
    theme   = "Dark",
    accent  = "#FFAC9B",
}


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
local speedToggleOn = false

MiscTab:Toggle({
    Title = "开启速度修改",
    Value = false,
    Callback = function(v)
        speedToggleOn = v
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if v then
                hum.WalkSpeed = TargetWalkSpeed
                WindUI:Notify({ Title = "风脚本", Content = "加速已开启！", Duration = 2 })
            else
                hum.WalkSpeed = 16
                WindUI:Notify({ Title = "风脚本", Content = "速度已恢复默认", Duration = 2 })
            end
        end
    end
})

MiscTab:Input({
    Title = "速度数值",
    Default = "16",
    Placeholder = "从16~400的修改",
    Callback = function(text)
        local num = tonumber(text)
        if num and num >= 16 and num <= 400 then
            TargetWalkSpeed = num
            if speedToggleOn then
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChildOfClass("Humanoid") then
                    char:FindFirstChildOfClass("Humanoid").WalkSpeed = TargetWalkSpeed
                end
            end
            WindUI:Notify({ Title = "风脚本", Content = "速度已设定为: "..num, Duration = 2 })
        else
            WindUI:Notify({ Title = "风脚本", Content = "欢迎使用风脚本，已加载成功！", Duration = 2 })
        end
    end
})

task.spawn(function()
    while task.wait(0.5) do
        if speedToggleOn then
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum.WalkSpeed ~= TargetWalkSpeed then
                    hum.WalkSpeed = TargetWalkSpeed
                end
            end
        end
    end
end)

game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if speedToggleOn then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = TargetWalkSpeed
        end
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
local ScriptTab = Window:Tab({
    Title = "脚本库",
    Icon = "box"
})

-- 添加执行按钮
ScriptTab:Button({
    Title = "执行 Homelander 脚本",
    Desc = "点击加载并运行外部脚本",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/giobolqv1/homelander-by-GioBolqv1-/main/homelander.lua"))()
        WindUI:Notify({
            Title = "风脚本",
            Content = "已尝试加载外部脚本！",
            Duration = 2
        })
    end
})
  
--AFK
local VirtualUser = game:GetService("VirtualUser")
game.Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)


_G._LCF_WindUI = WindUI
_G._LCF_TmplWin = Window