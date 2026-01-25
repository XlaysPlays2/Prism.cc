-- [[ Prism.cc | Created by xlaysplays ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Prism.cc | Private Hub",
   LoadingTitle = "Prism.cc Physics Kit",
   LoadingSubtitle = "by xlaysplays",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "PrismConfig",
      FileName = "PrismHub"
   },
   KeySystem = false -- Set to true if you want a key system later
})

-- Main Tab
local MainTab = Window:CreateTab("Physics Kit", 4483345998) -- Tab name and Icon

local Section = MainTab:CreateSection("Modules")

MainTab:CreateLabel("Status: Active")

-- The Loader Button
MainTab:CreateButton({
   Name = "Execute All Modules (G, H, C)",
   Callback = function()
       -- SafeLoad function to fetch scripts
       local function SafeLoad(url)
           local success, err = pcall(function()
               loadstring(game:HttpGet(url, true))()
           end)
           if not success then
               Rayfield:Notify({
                  Title = "Load Error",
                  Content = "Failed to load a module. Check console (F9).",
                  Duration = 5,
                  Image = 4483345998,
               })
               warn("Prism.cc Error: " .. tostring(err))
           end
       end

       -- Loading your GitHub scripts
       SafeLoad("https://raw.githubusercontent.com/XlaysPlays2/Prism.cc/refs/heads/main/scripts/fly.lua")
       SafeLoad("https://raw.githubusercontent.com/XlaysPlays2/Prism.cc/refs/heads/main/scripts/sbomb.lua")
       SafeLoad("https://raw.githubusercontent.com/XlaysPlays2/Prism.cc/refs/heads/main/scripts/kame.lua")

       Rayfield:Notify({
          Title = "Prism.cc Executed",
          Content = "Fly, S-Bomb, and Kame modules are live!",
          Duration = 5,
          Image = 4483345998,
       })
   end,
})

MainTab:CreateSection("Controls")
MainTab:CreateLabel("G: Fly | H: S-Bomb | C: Kame")

-- Footer
MainTab:CreateLabel("Repository: XlaysPlays2/Prism.cc")
