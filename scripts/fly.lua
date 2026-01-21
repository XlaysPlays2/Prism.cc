local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")
local UIS = game:GetService("UserInputService")
local isFlying = false
local flyBV = Instance.new("BodyVelocity", RootPart)
flyBV.MaxForce = Vector3.new(0, 0, 0)

game:GetService("RunService").RenderStepped:Connect(function()
    if isFlying then
        local flyVel = Humanoid.MoveDirection * 60
        if UIS:IsKeyDown(Enum.KeyCode.Space) then flyVel += Vector3.new(0, 50, 0)
        elseif UIS:IsKeyDown(Enum.KeyCode.LeftShift) then flyVel += Vector3.new(0, -50, 0) end
        flyBV.Velocity = flyVel
    end
end)

UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.G then
        isFlying = not isFlying
        flyBV.MaxForce = isFlying and Vector3.new(math.huge, math.huge, math.huge) or Vector3.new(0,0,0)
        Humanoid.PlatformStand = isFlying
    end
end)
