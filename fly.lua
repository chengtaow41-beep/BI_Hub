-- 飞行核心引擎
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")

local isFlying = false
local flyConnection = nil

local function ToggleFly()
    isFlying = not isFlying
    
    if not isFlying then
        if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
        end
        return
    end
    
    flyConnection = RunService.Stepped:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if hum and root then
            hum.PlatformStand = true
            local moveDir = Vector3.new(0, 0, 0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir + Vector3.new(0, -1, 0) end
            root.Velocity = Vector3.new(moveDir.X * 50, moveDir.Y * 35, moveDir.Z * 50)
        end
    end)
end

-- 暴露给外部使用（将函数设为全局）
_G.FlyToggle = ToggleFly