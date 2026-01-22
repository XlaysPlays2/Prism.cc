-- [[ Prism.cc | Created by XlaysPlays2 ]]
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
MainTab:AddLabel("Repository: XlaysPlays2/Prism.cc")

-- The Loader Button
MainTab:AddButton({
    Name = "Execute All Modules (G, H, C)",
    Callback = function()
        -- Pulling files from the /scripts/ folder
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XlaysPlays2/Prism.cc/refs/heads/main/scripts/fly.lua"))()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XlaysPlays2/Prism.cc/refs/heads/main/scripts/sbomb.lua"))()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XlaysPlays2/Prism.cc/refs/heads/main/scripts/kame.lua"))()
        
        OrionLib:MakeNotification({
            Name = "Prism.cc",
            Content = "Fly, S-Bomb, and Kame loaded.",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end    
})

MainTab:AddLabel("Binds: G (Fly) | H (S-Bomb) | C (Kame)")

OrionLib:Init()
