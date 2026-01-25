-- [[ Prism.cc Fly Module | Mobile & PC ]]
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")
local UIS = game:GetService("UserInputService")

local isFlying = false
local flyBV = Instance.new("BodyVelocity")
flyBV.Name = "PrismFly"
flyBV.Parent = RootPart
flyBV.MaxForce = Vector3.new(0, 0, 0)
flyBV.Velocity = Vector3.new(0, 0, 0)

-- Function to toggle flight
local function toggleFlight()
    isFlying = not isFlying
    if isFlying then
        flyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        Humanoid.PlatformStand = true
    else
        flyBV.MaxForce = Vector3.new(0, 0, 0)
        Humanoid.PlatformStand = false
    end
end

-- Flying Logic
game:GetService("RunService").RenderStepped:Connect(function()
    if isFlying then
        local flyVel = Humanoid.MoveDirection * 60
        
        -- Keyboard Controls
        if UIS:IsKeyDown(Enum.KeyCode.Space) then 
            flyVel = flyVel + Vector3.new(0, 50, 0)
        elseif UIS:IsKeyDown(Enum.KeyCode.LeftShift) then 
            flyVel = flyVel + Vector3.new(0, -50, 0) 
        end
        
        flyBV.Velocity = flyVel
    end
end)

-- PC Keybind (G)
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.G then
        toggleFlight()
    end
end)

-- MOBILE UI (Only shows if Touch is enabled)
if UIS.TouchEnabled then
    local ScreenGui = Instance.new("ScreenGui", Player.PlayerGui)
    ScreenGui.Name = "PrismMobile"
    
    local ToggleBtn = Instance.new("TextButton", ScreenGui)
    ToggleBtn.Size = UDim2.new(0, 70, 0, 70)
    ToggleBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
    ToggleBtn.Text = "Fly"
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
    ToggleBtn.BorderSizePixel = 2
    
    -- Rounding the corners for a cleaner look
    local UICorner = Instance.new("UICorner", ToggleBtn)
    UICorner.CornerRadius = UDim.new(0, 10)

    ToggleBtn.MouseButton1Click:Connect(function()
        toggleFlight()
        ToggleBtn.Text = isFlying and "Flying" or "Fly"
        ToggleBtn.BackgroundColor3 = isFlying and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(40, 40, 40)
    end)
end
