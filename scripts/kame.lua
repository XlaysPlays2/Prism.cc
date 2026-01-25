-- [[ Prism.cc Kame Module | Mobile & PC ]]
local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local Character = Player.Character or Player.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local isCharging = false
local kameParts = {}

-- Function to get the target position (Works for both PC and Mobile)
local function getTarget()
    if UIS.TouchEnabled then
        -- Aim at the center of the screen for mobile
        local unitRay = Camera:ScreenPointToRay(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        return unitRay.Origin + unitRay.Direction * 1000
    else
        return Mouse.Hit.Position
    end
end

-- Function to handle the Fire logic
local function toggleKame()
    if not isCharging then 
        isCharging = true 
    else
        isCharging = false
        local targetPos = getTarget()
        local toFire = kameParts
        kameParts = {}
        
        task.spawn(function()
            for i, data in ipairs(toFire) do
                if data.Part and data.Part.Parent then
                    data.AP:Destroy()
                    data.Tag:Destroy()
                    data.Part.CanCollide = true
                    
                    local lv = Instance.new("LinearVelocity")
                    lv.Attachment0 = data.Att
                    lv.MaxForce = 1e8
                    lv.VectorVelocity = (targetPos - data.Part.Position).Unit * 450
                    lv.Parent = data.Part
                    
                    game.Debris:AddItem(lv, 2)
                    game.Debris:AddItem(data.Att, 2)
                end
                if i % 2 == 0 then game:GetService("RunService").Heartbeat:Wait() end
            end
        end)
    end
end

-- Core Physics Logic
game:GetService("RunService").Heartbeat:Connect(function()
    if isCharging then
        local nearby = workspace:FindPartsInRegion3(Region3.new(RootPart.Position - Vector3.new(100,100,100), RootPart.Position + Vector3.new(100,100,100)), Character, 50)
        for _, part in ipairs(nearby) do
            if #kameParts < 30 and part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(Character) and not part.Parent:FindFirstChild("Humanoid") then
                if not part:FindFirstChild("KameTag") then
                    local tag = Instance.new("BoolValue", part); tag.Name = "KameTag"
                    part.CanCollide = false
                    local att = Instance.new("Attachment", part)
                    local ap = Instance.new("AlignPosition", part); ap.Attachment0 = att; ap.Mode = Enum.PositionAlignmentMode.OneAttachment
                    ap.MaxForce = 1e7; ap.Responsiveness = 40; ap.Parent = part
                    table.insert(kameParts, {Part = part, AP = ap, Att = att, Tag = tag})
                end
            end
        end
        local handPos = (RootPart.CFrame * CFrame.new(0, 0, -6)).Position
        for _, data in ipairs(kameParts) do
            if data.Part and data.Part.Parent then 
                data.AP.Position = handPos + Vector3.new(math.random(-2,2), math.random(-2,2), math.random(-2,2)) 
            end
        end
    end
end)

-- PC Keybind (C)
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.C then
        toggleKame()
    end
end)

-- MOBILE UI (Only shows if Touch is enabled)
if UIS.TouchEnabled then
    local ScreenGui = Player.PlayerGui:FindFirstChild("PrismMobile") or Instance.new("ScreenGui", Player.PlayerGui)
    ScreenGui.Name = "PrismMobile"
    
    local KameBtn = Instance.new("TextButton", ScreenGui)
    KameBtn.Size = UDim2.new(0, 70, 0, 70)
    KameBtn.Position = UDim2.new(0.1, 80, 0, 5, 0.5, 0) -- Positioned next to the Fly button
    KameBtn.Text = "Kame"
    KameBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    KameBtn.TextColor3 = Color3.new(1, 1, 1)
    
    local UICorner = Instance.new("UICorner", KameBtn)
    UICorner.CornerRadius = UDim.new(0, 10)

    KameBtn.MouseButton1Click:Connect(function()
        toggleKame()
        KameBtn.Text = isCharging and "FIRE!" or "Kame"
        KameBtn.BackgroundColor3 = isCharging and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 100, 255)
    end)
end
