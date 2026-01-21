-- [[ Prism.cc | Created by xlaysplays ]]
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "Prism.cc | Private Hub", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "PrismConfig"
})

-- Main Tab
local MainTab = Window:MakeTab({
    Name = "Physics Kit",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Credits Section
MainTab:AddLabel("Status: Active")
MainTab:AddLabel("Created by: xlaysplays")

-- The Loader Button
MainTab:AddButton({
    Name = "Execute All Modules (G, H, C)",
    Callback = function()
        -- Replace these with your actual Raw GitHub links for each file
        loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USER/YOUR_REPO/main/Fly.lua"))()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USER/YOUR_REPO/main/SpiritBomb.lua"))()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USER/YOUR_REPO/main/Kamehameha.lua"))()
        
        OrionLib:MakeNotification({
            Name = "Prism.cc",
            Content = "Modules Loaded Successfully.",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end    
})

MainTab:AddLabel("Binds: G (Fly) | H (Bomb) | C (Beam)")

OrionLib:Init()
