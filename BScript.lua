-- ==========================================
-- 使用 WindUI 引擎构建的 BI 脚本
-- ==========================================

-- 1. 在线加载 WindUI 引擎 (替换了你原来的 require)
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/zyq2g/Test-Repo/main/WindUI/Source.lua"))()

-- 2. 设置 UI 样式 (设为深色模式)
WindUI:SetTheme("Dark")
WindUI.TransparencyValue = 0.15

-- 3. 弹窗确认 (像你代码里一样，加个渐变弹出窗)
WindUI:Popup({
    Title = "BI 脚本",
    Icon = "sparkles",
    Content = "欢迎使用 BI 脚本\n永久免费！永不跑路！",
    Buttons = {
        { Title = "进入菜单", Icon = "arrow-right", Variant = "Primary", Callback = function() end }
    }
})

-- 4. 创建主窗口
local Window = WindUI:CreateWindow({
    Title = "BI 脚本",
    Icon = "sparkles",
    Size = UDim2.fromOffset(500, 400), -- 宽度和高度
    Position = UDim2.new(0.5, -250, 0.5, -200), -- 居中
    Theme = "Dark"
})

-- 5. 左侧侧边栏
local Tab1 = Window:Tab({ Title = "公告", Icon = "star" })
local Tab2 = Window:Tab({ Title = "功能", Icon = "settings" })

-- 6. 公告页内容
Tab1:Paragraph({
    Title = "BI 脚本公告",
    Desc = "这里是你的专属脚本界面\n\n如果你能看到这个漂亮的彩色渐变菜单，说明 WindUI 已经成功运行了！\n\n交流群：待定",
    Image = "https://c-ssl.duitang.com/uploads/blog/202310/21/oVS4gnBVIg4A1yJ.jpg",
    ImageSize = 42,
    Thumbnail = "https://c-ssl.duitang.com/uploads/blog/202103/27/20210327131203_74b6b.jpg",
    ThumbnailSize = 120
})

-- 7. 功能页内容
Tab2:Slider({
    Title = "移动速度",
    Value = { Min = 16, Max = 100, Default = 16 },
    Increment = 1,
    Callback = function(val)
        if game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
        end
    end
})

Tab2:Toggle({
    Title = "无限跳跃",
    Value = false,
    Callback = function(state)
        if state then
            loadstring(game:HttpGet("https://pastebin.com/raw/V5PQy3y0", true))()
        end
    end
})