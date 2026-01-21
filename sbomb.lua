local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local Character = Player.Character or Player.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")
local isCharging = false
local bombParts = {}

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
                data.AP.Position = RootPart.Position + Vector3.new(0, 45, 0) + (CFrame.Angles(0, tick(), 0) * data.Offset)
            end
        end
    end
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.H then
        if not isCharging then isCharging = true else
            isCharging = false
            for _, data in ipairs(bombParts) do
                if data.Part then
                    data.AP:Destroy(); data.Tag:Destroy(); data.Part.CanCollide = true
                    local lv = Instance.new("LinearVelocity", data.Part); lv.Attachment0 = data.Att; lv.MaxForce = 1e7
                    lv.VectorVelocity = (Mouse.Hit.p - data.Part.Position).Unit * 250; lv.Parent = data.Part
                    game.Debris:AddItem(lv, 3)
                end
            end
            bombParts = {}
        end
    end
end)
