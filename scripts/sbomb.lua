-- [[ Prism.cc S-Bomb Module | Mobile & PC ]]
local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local Character = Player.Character or Player.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local isCharging = false
local bombParts = {}

-- Aiming Logic (Center of screen for Mobile, Mouse for PC)
local function getTarget()
    if UIS.TouchEnabled then
        local unitRay = Camera:ScreenPointToRay(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        return unitRay.Origin + unitRay.Direction * 1000
    else
        return Mouse.Hit.Position
    end
end

-- Toggle Function
local function toggleBomb()
    if not isCharging then 
        isCharging = true 
    else
        isCharging = false
        local targetPos = getTarget()
        for _, data in ipairs(bombParts) do
            if data.Part and data.Part.Parent then
                data.AP:Destroy()
                data.Tag:Destroy()
                data.Part.CanCollide = true
                
                local lv = Instance.new("LinearVelocity")
                lv.Attachment0 = data.Att
                lv.MaxForce = 1e7
                lv.VectorVelocity = (targetPos - data.Part.Position).Unit * 250
                lv.Parent = data.Part
                
                game.Debris:AddItem(lv, 3)
                game.Debris:AddItem(data.Att, 3) -- Cleanup
            end
        end
        bombParts = {}
    end
end

-- Orbit & Physics Logic
game:GetService("RunService").Heartbeat:Connect(function()
    if isCharging then
        local nearby = workspace:FindPartsInRegion3(Region3.new(RootPart.Position - Vector3.new(100,100,100), RootPart.Position + Vector3.new(100,100,100)), Character, 50)
        for _, part in ipairs(nearby) do
            if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(Character) and not part.Parent:FindFirstChild("Humanoid") then
                if not part:FindFirstChild("BombTag") then
                    local tag = Instance.new("BoolValue", part); tag.Name = "BombTag"
                    part.CanCollide = false
                    local att = Instance.new("Attachment", part)
                    local ap = Instance.new("AlignPosition", part); ap.Attachment0 = att; ap.Mode = Enum.PositionAlignmentMode.OneAttachment
                    ap.MaxForce = 1e6; ap.Responsiveness = 20; ap.Parent = part
                    table.insert(bombParts, {Part = part, AP = ap, Att = att, Tag = tag, Offset = Vector3.new(math.random(-25,25), math.random(-25,25), math.random(-25,25))})
                end
            end
        end
        for _, data in ipairs(bombParts) do
            if data.Part and data.Part.Parent then
                -- This creates the spinning orbit effect above your head
                data.AP.Position = RootPart.Position + Vector3.new(0, 45, 0) + (CFrame.Angles(0, tick(), 0) * data.Offset)
            end
        end
    end
end)

-- PC Keybind (H)
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.H then
        toggleBomb()
    end
end)

-- MOBILE UI
if UIS.TouchEnabled then
    local ScreenGui = Player.PlayerGui:FindFirstChild("PrismMobile") or Instance.new("ScreenGui", Player.PlayerGui)
    
    local BombBtn = Instance.new("TextButton", ScreenGui)
    BombBtn.Size = UDim2.new(0, 70, 0, 70)
    BombBtn.Position = UDim2.new(0.1, 160, 0.5, 0) -- Positioned next to Kame button
    BombBtn.Text = "S-Bomb"
    BombBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    BombBtn.TextColor3 = Color3.new(1, 1, 1)
    
    local UICorner = Instance.new("UICorner", BombBtn)
    UICorner.CornerRadius = UDim.new(0, 10)

    BombBtn.MouseButton1Click:Connect(function()
        toggleBomb()
        BombBtn.Text = isCharging and "DROP IT" or "S-Bomb"
        BombBtn.BackgroundColor3 = isCharging and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 150, 0)
    end)
end
