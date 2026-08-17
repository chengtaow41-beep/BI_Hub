local BScriptUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/chengtaow41-beep/BI_Hub/main/BScriptUI.lua"))()

-- 在 UI 里面搭建你的功能
local SectionMain = BScriptUI:CreateSection()
BScriptUI:AddLabel(SectionMain, "永久免费！永不跑路！")

local SectionAction = BScriptUI:CreateSection()
BScriptUI:AddButton(SectionAction, "无限跳跃测试", function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = 100
        char.Humanoid.Jump = true
        BScriptUI:SendNotification("B脚本", "无限跳跃已开启！", 3)
    end
end)

BScriptUI:SendNotification("B脚本 启动成功", " UI 加载完成！", 5)