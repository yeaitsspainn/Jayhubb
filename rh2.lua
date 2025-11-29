--[[
    CYBER NEXUS - Complete Bronx Integration
    Full integration of all 5000+ lines with phenomenal UI
]]

-- First, let's integrate the core configuration system
local function integrateConfigSystem()
    -- Connect all configuration systems to UI
    local Config = getgenv().Config or {}
    
    -- Combat Systems Integration
    local function setupCombatSystems()
        -- Aimlock System
        createToggle("Aimlock Enabled", Config.Aimlock.Enabled, function(value)
            Config.Aimlock.Enabled = value
            if value and Config.Aimlock.Mode == "Always" then
                Config.Aimlock.Aiming = true
            end
        end, CombatTab, 0)
        
        createToggle("Silent Aim Enabled", Config.Silent.Enabled, function(value)
            Config.Silent.Enabled = value
            if value and Config.Silent.Mode == "Always" then
                Config.Silent.Targetting = true
            end
        end, CombatTab, 35)
        
        -- Weapon Modifications
        createToggle("Infinite Ammo", Config.TheBronx._Modifications.InfiniteAmmo, function(value)
            Config.TheBronx._Modifications.InfiniteAmmo = value
            ModWeapons()
        end, CombatTab, 70)
        
        createToggle("No Recoil", Config.TheBronx._Modifications.ModifyRecoilValue, function(value)
            Config.TheBronx._Modifications.ModifyRecoilValue = value
            ModWeapons()
        end, CombatTab, 105)
        
        createToggle("No Spread", Config.TheBronx._Modifications.ModifySpreadValue, function(value)
            Config.TheBronx._Modifications.ModifySpreadValue = value
            ModWeapons()
        end, CombatTab, 140)
        
        createToggle("Automatic Fire", Config.TheBronx._Modifications.Automatic, function(value)
            Config.TheBronx._Modifications.Automatic = value
            ModWeapons()
        end, CombatTab, 175)
        
        createToggle("Disable Jamming", Config.TheBronx._Modifications.DisableJamming, function(value)
            Config.TheBronx._Modifications.DisableJamming = value
            ModWeapons()
        end, CombatTab, 210)
        
        -- Kill Aura
        createToggle("Kill Aura", Config.TheBronx.KillAura, function(value)
            Config.TheBronx.KillAura = value
        end, CombatTab, 245)
        
        createSlider("Kill Aura Range", Config.TheBronx.KillAuraRange, 50, 500, function(value)
            Config.TheBronx.KillAuraRange = value
        end, CombatTab, 280)
    end

    -- Player Systems Integration
    local function setupPlayerSystems()
        -- Movement
        createToggle("Speed Hack", Config.MiscSettings.ModifySpeed.Enabled, function(value)
            Config.MiscSettings.ModifySpeed.Enabled = value
        end, PlayerTab, 0)
        
        createSlider("Speed Value", Config.MiscSettings.ModifySpeed.Value, 16, 200, function(value)
            Config.MiscSettings.ModifySpeed.Value = value
        end, PlayerTab, 35)
        
        createToggle("Fly Hack", Config.MiscSettings.Fly.Enabled, function(value)
            Config.MiscSettings.Fly.Enabled = value
            if value then
                StartFlight()
            else
                ResetFlight()
            end
        end, PlayerTab, 70)
        
        createSlider("Fly Speed", Config.MiscSettings.Fly.Speed, 10, 200, function(value)
            Config.MiscSettings.Fly.Speed = value
        end, PlayerTab, 105)
        
        -- Player Modifications
        createToggle("Infinite Health", Config.TheBronx.PlayerModifications.InfiniteHealth, function(value)
            Config.TheBronx.PlayerModifications.InfiniteHealth = value
        end, PlayerTab, 140)
        
        createToggle("Infinite Stamina", Config.TheBronx.PlayerModifications.InfiniteStamina, function(value)
            Config.TheBronx.PlayerModifications.InfiniteStamina = value
        end, PlayerTab, 175)
        
        createToggle("Infinite Hunger", Config.TheBronx.PlayerModifications.InfiniteHunger, function(value)
            Config.TheBronx.PlayerModifications.InfiniteHunger = value
        end, PlayerTab, 210)
        
        createToggle("No Fall Damage", Config.TheBronx.PlayerModifications.NoFallDamage, function(value)
            Config.TheBronx.PlayerModifications.NoFallDamage = value
        end, PlayerTab, 245)
        
        createToggle("No Knockback", Config.TheBronx.PlayerModifications.NoKnockback, function(value)
            Config.TheBronx.PlayerModifications.NoKnockback = value
        end, PlayerTab, 280)
        
        createToggle("Instant Interact", Config.TheBronx.PlayerModifications.InstantInteract, function(value)
            Config.TheBronx.PlayerModifications.InstantInteract = value
        end, PlayerTab, 315)
    end

    -- Visual Systems Integration
    local function setupVisualSystems()
        -- ESP System
        createToggle("ESP Enabled", ESP.Enabled, function(value)
            ESP.Enabled = value
            updateESP()
        end, VisualsTab, 0)
        
        createToggle("Box ESP", ESP.Drawing.Boxes.Full.Enabled, function(value)
            ESP.Drawing.Boxes.Full.Enabled = value
            updateESP()
        end, VisualsTab, 35)
        
        createToggle("Name ESP", ESP.Drawing.Names.Enabled, function(value)
            ESP.Drawing.Names.Enabled = value
            updateESP()
        end, VisualsTab, 70)
        
        createToggle("Health Bar", ESP.Drawing.Healthbar.Enabled, function(value)
            ESP.Drawing.Healthbar.Enabled = value
            updateESP()
        end, VisualsTab, 105)
        
        createToggle("Weapon ESP", ESP.Drawing.Weapons.Enabled, function(value)
            ESP.Drawing.Weapons.Enabled = value
            updateESP()
        end, VisualsTab, 140)
        
        createToggle("Distance ESP", ESP.Drawing.Distances.Enabled, function(value)
            ESP.Drawing.Distances.Enabled = value
            updateESP()
        end, VisualsTab, 175)
        
        -- World Visuals
        createToggle("Fullbright", Config.WorldVisuals.Fullbright, function(value)
            Config.WorldVisuals.Fullbright = value
        end, VisualsTab, 210)
        
        createToggle("Saturation", Config.WorldVisuals.SaturationEnabled, function(value)
            Config.WorldVisuals.SaturationEnabled = value
        end, VisualsTab, 245)
        
        createToggle("Ambient Lighting", Config.WorldVisuals.AmbientEnabled, function(value)
            Config.WorldVisuals.AmbientEnabled = value
        end, VisualsTab, 280)
        
        createSlider("Field of View", Config.WorldVisuals.FieldOfViewValue, 70, 120, function(value)
            Config.WorldVisuals.FieldOfViewValue = value
            Config.WorldVisuals.FieldOfViewEnabled = true
        end, VisualsTab, 315)
    end

    -- Automation Systems Integration
    local function setupAutomationSystems()
        -- The Bronx Farming
        createToggle("Farm Construction", Config.TheBronx.Farms.FarmConstructionJob, function(value)
            Config.TheBronx.Farms.FarmConstructionJob = value
        end, AutomationTab, 0)
        
        createToggle("Farm Bank", Config.TheBronx.Farms.FarmBank, function(value)
            Config.TheBronx.Farms.FarmBank = value
        end, AutomationTab, 35)
        
        createToggle("Collect Money", Config.TheBronx.Farms.CollectDroppedMoney, function(value)
            Config.TheBronx.Farms.CollectDroppedMoney = value
        end, AutomationTab, 70)
        
        createToggle("Collect Loot", Config.TheBronx.Farms.CollectDroppedLoot, function(value)
            Config.TheBronx.Farms.CollectDroppedLoot = value
        end, AutomationTab, 105)
        
        -- South Bronx Farming
        createToggle("Card Farm", Config.South_Bronx.FarmingUtilities.CardFarm, function(value)
            Config.South_Bronx.FarmingUtilities.CardFarm = value
            if value then
                Start_CardFarm()
            else
                Stop_CardFarm()
            end
        end, AutomationTab, 140)
        
        createToggle("Chip Farm", Config.South_Bronx.FarmingUtilities.ChipFarm, function(value)
            Config.South_Bronx.FarmingUtilities.ChipFarm = value
            if value then
                Start_ChipFarm()
            else
                Stop_ChipFarm()
            end
        end, AutomationTab, 175)
        
        createToggle("Marshmallow Farm", Config.South_Bronx.FarmingUtilities.MarshmallowFarm, function(value)
            Config.South_Bronx.FarmingUtilities.MarshmallowFarm = value
            if value then
                Start_MarshmallowFarm()
            else
                Stop_MarshmallowFarm()
            end
        end, AutomationTab, 210)
        
        createToggle("Box Farm", Config.South_Bronx.FarmingUtilities.BoxFarm, function(value)
            Config.South_Bronx.FarmingUtilities.BoxFarm = value
            if value then
                Start_BoxFarm()
            else
                Stop_BoxFarm()
            end
        end, AutomationTab, 245)
        
        -- BlockSpin Farming
        createToggle("Mop Farm", Config.BlockSpin.AutoFarming.FarmMops, function(value)
            Config.BlockSpin.AutoFarming.FarmMops = value
            if value then
                Start_MopFarm()
            else
                Stop_MopFarm()
            end
        end, AutomationTab, 280)
    end

    -- Vehicle Systems Integration
    local function setupVehicleSystems()
        createToggle("Vehicle Speed", Config.TheBronx.VehicleModifications.SpeedEnabled, function(value)
            Config.TheBronx.VehicleModifications.SpeedEnabled = value
        end, VehicleTab, 0)
        
        createSlider("Speed Multiplier", Config.TheBronx.VehicleModifications.SpeedValue * 1000, 10, 100, function(value)
            Config.TheBronx.VehicleModifications.SpeedValue = value / 1000
        end, VehicleTab, 35)
        
        createToggle("Better Brakes", Config.TheBronx.VehicleModifications.BreakEnabled, function(value)
            Config.TheBronx.VehicleModifications.BreakEnabled = value
        end, VehicleTab, 70)
        
        createSlider("Brake Strength", Config.TheBronx.VehicleModifications.BreakValue * 1000, 10, 100, function(value)
            Config.TheBronx.VehicleModifications.BreakValue = value / 1000
        end, VehicleTab, 105)
        
        createToggle("Instant Stop", Config.TheBronx.VehicleModifications.InstantStop, function(value)
            Config.TheBronx.VehicleModifications.InstantStop = value
        end, VehicleTab, 140)
    end

    -- Player Utilities Integration
    local function setupPlayerUtilities()
        local playerList = {}
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player ~= game:GetService("Players").LocalPlayer then
                table.insert(playerList, player.Name)
            end
        end
        
        createDropdown("Select Player", playerList, Config.TheBronx.PlayerUtilities.SelectedPlayer, function(value)
            Config.TheBronx.PlayerUtilities.SelectedPlayer = value
        end, UtilitiesTab, 0)
        
        createToggle("Bring Player", Config.TheBronx.PlayerUtilities.BringingPlayer, function(value)
            Config.TheBronx.PlayerUtilities.BringingPlayer = value
        end, UtilitiesTab, 35)
        
        createToggle("Auto Kill", Config.TheBronx.PlayerUtilities.AutoKill, function(value)
            Config.TheBronx.PlayerUtilities.AutoKill = value
        end, UtilitiesTab, 70)
        
        createToggle("Auto Ragdoll", Config.TheBronx.PlayerUtilities.AutoRagdoll, function(value)
            Config.TheBronx.PlayerUtilities.AutoRagdoll = value
        end, UtilitiesTab, 105)
        
        createToggle("Bug Player", Config.TheBronx.PlayerUtilities.BugPlayer, function(value)
            Config.TheBronx.PlayerUtilities.BugPlayer = value
        end, UtilitiesTab, 140)
        
        createToggle("Spectate Player", Config.TheBronx.PlayerUtilities.SpectatePlayer, function(value)
            Config.TheBronx.PlayerUtilities.SpectatePlayer = value
        end, UtilitiesTab, 175)
    end

    -- Initialize all systems
    setupCombatSystems()
    setupPlayerSystems()
    setupVisualSystems()
    setupAutomationSystems()
    setupVehicleSystems()
    setupPlayerUtilities()
end

-- Integrate the anti-cheat bypass systems
local function integrateAntiCheatSystems()
    if not Solara and Game_Name == "The Bronx" then
        -- Anti-detection systems
        createToggle("Anti-Cheat Bypass", getgenv().AntiCheatBypass, function(value)
            getgenv().AntiCheatBypass = value
        end, SettingsTab, 0)
    end
end

-- Integrate teleportation systems
local function integrateTeleportationSystems()
    local locations = {}
    
    if Game_Name == "The Bronx" then
        locations = Config.TheBronx.TeleportationList
    elseif Game_Name == "South Bronx" then
        locations = Config.South_Bronx.Locations
    elseif Game_Name == "Road To Riches" then
        locations = Config.Road_To_Riches.Locations
    end
    
    local locationNames = {}
    for name, _ in pairs(locations) do
        table.insert(locationNames, name)
    end
    
    table.sort(locationNames)
    
    createDropdown("Teleport Location", locationNames, Config.TheBronx.Selected_Location, function(value)
        Config.TheBronx.Selected_Location = value
        local locationCFrame = locations[value]
        if locationCFrame then
            if Game_Name == "South Bronx" then
                Teleport(locationCFrame)
            else
                LocalPlayer.Character.HumanoidRootPart.CFrame = locationCFrame
            end
        end
    end, UtilitiesTab, 210)
    
    createButton("Teleport", function()
        local selectedLocation = Config.TheBronx.Selected_Location
        local locationCFrame = locations[selectedLocation]
        if locationCFrame then
            if Game_Name == "South Bronx" then
                Teleport(locationCFrame)
            else
                LocalPlayer.Character.HumanoidRootPart.CFrame = locationCFrame
            end
        end
    end, UtilitiesTab, 245)
end

-- Create additional UI tabs
local function createAdditionalTabs()
    -- Automation Tab
    local AutomationTab = Instance.new("Frame")
    AutomationTab.BackgroundTransparency = 1
    AutomationTab.Size = UDim2.new(1, 0, 1, 0)
    AutomationTab.Visible = false
    AutomationTab.Parent = ContentFrame
    
    -- Vehicle Tab
    local VehicleTab = Instance.new("Frame")
    VehicleTab.BackgroundTransparency = 1
    VehicleTab.Size = UDim2.new(1, 0, 1, 0)
    VehicleTab.Visible = false
    VehicleTab.Parent = ContentFrame
    
    -- Utilities Tab
    local UtilitiesTab = Instance.new("Frame")
    UtilitiesTab.BackgroundTransparency = 1
    UtilitiesTab.Size = UDim2.new(1, 0, 1, 0)
    UtilitiesTab.Visible = false
    UtilitiesTab.Parent = ContentFrame
    
    -- Settings Tab
    local SettingsTab = Instance.new("Frame")
    SettingsTab.BackgroundTransparency = 1
    SettingsTab.Size = UDim2.new(1, 0, 1, 0)
    SettingsTab.Visible = false
    SettingsTab.Parent = ContentFrame
    
    return {
        Automation = AutomationTab,
        Vehicle = VehicleTab,
        Utilities = UtilitiesTab,
        Settings = SettingsTab
    }
end

-- Enhanced navigation system
local function setupEnhancedNavigation()
    local tabs = {
        Combat = CombatTab,
        Visuals = VisualsTab,
        Player = PlayerTab,
        Automation = additionalTabs.Automation,
        Vehicle = additionalTabs.Vehicle,
        Utilities = additionalTabs.Utilities,
        Settings = additionalTabs.Settings
    }
    
    local navButtons = Sidebar:GetChildren()
    for i, button in pairs(navButtons) do
        if button:IsA("TextButton") then
            button.MouseButton1Click:Connect(function()
                local tabName = button.Text:split("\n")[2]
                local targetTab = tabs[tabName:upper():gsub(" ", "")]
                if targetTab then
                    switchToTab(targetTab)
                end
            end)
        end
    end
end

-- Initialize everything
local additionalTabs = createAdditionalTabs()
integrateConfigSystem()
integrateAntiCheatSystems()
integrateTeleportationSystems()
setupEnhancedNavigation()

-- Final initialization
StatusText.Text = "CYBER NEXUS | " .. Game_Name .. " | FULLY INTEGRATED"
library.notifications:create_notification({
    name = "CYBER NEXUS",
    info = "All systems integrated successfully",
    lifetime = 5
})

-- Update ESP when players join/leave
game:GetService("Players").PlayerAdded:Connect(function()
    if ESP.Enabled then
        updateESP()
    end
end)

game:GetService("Players").PlayerRemoving:Connect(function()
    if ESP.Enabled then
        updateESP()
    end
end)
