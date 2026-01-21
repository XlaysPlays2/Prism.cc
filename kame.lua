local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local Character = Player.Character or Player.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")
local isCharging = false
local kameParts = {}

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
            if data.Part and data.Part.Parent then data.AP.Position = handPos + Vector3.new(math.random(-2,2), math.random(-2,2), math.random(-2,2)) end
        end
    end
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.C then
        if not isCharging then isCharging = true else
            isCharging = false
            local toFire = kameParts; kameParts = {}
            task.spawn(function()
                for i, data in ipairs(toFire) do
                    if data.Part then
                        data.AP:Destroy(); data.Tag:Destroy(); data.Part.CanCollide = true
                        local lv = Instance.new("LinearVelocity", data.Part); lv.Attachment0 = data.Att; lv.MaxForce = 1e8
                        lv.VectorVelocity = (Mouse.Hit.p - data.Part.Position).Unit * 450; lv.Parent = data.Part
                        game.Debris:AddItem(lv, 2)
                    end
                    if i % 2 == 0 then game:GetService("RunService").Heartbeat:Wait() end
                end
            end)
        end
    end
end)
