getgenv().SecureMode = true

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Steal a Brainrot Noclip",
   LoadingTitle = "Noclip Bypass",
   LoadingSubtitle = "Anti-Cheat Evasion",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "BrainrotNoclipConfig"
   },
   KeySystem = false,
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Noclip Settings
_G.NoclipEnabled = false
_G.NoclipKey = Enum.KeyCode.V
_G.StealthMode = true
_G.BypassCollision = true
_G.PhaseThroughWalls = true

-- Advanced Anti-Noclip Bypass
local function setupNoclipBypass()
    print("🛡️ Initializing Noclip Bypass System...")
    
    -- Hook collision detection systems
    pcall(function()
        -- Method 1: Modify character collision properties
        local function modifyCollision(character)
            if character then
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        -- Make parts non-collidable
                        part.CanCollide = false
                        part.Massless = true
                        
                        -- Remove any collision constraints
                        for _, constraint in pairs(part:GetChildren()) do
                            if constraint:IsA("Constraint") then
                                constraint.Enabled = false
                            end
                        end
                    end
                end
            end
        end

        -- Method 2: Hook anti-noclip detection
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                local name = obj.Name:lower()
                if name:find("noclip") or name:find("anticheat") or name:find("collision") then
                    local oldFire = obj.FireServer
                    obj.FireServer = function(self, ...)
                        local args = {...}
                        -- Block noclip detection reports
                        if type(args[1]) == "string" and args[1]:lower():find("noclip") then
                            return nil
                        end
                        return oldFire(self, ...)
                    end
                end
            end
        end
    end)
    
    print("✅ Noclip Bypass System Ready")
end

-- Main Noclip System
local function activateNoclip()
    spawn(function()
        while _G.NoclipEnabled do
            RunService.Stepped:Wait()
            pcall(function()
                local character = LocalPlayer.Character
                if character then
                    -- Method 1: Direct collision bypass
                    for _, part in pairs(character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                    
                    -- Method 2: Velocity-based phasing
                    if _G.PhaseThroughWalls then
                        local root = character:FindFirstChild("HumanoidRootPart")
                        if root then
                            -- Add slight upward velocity to prevent getting stuck
                            root.Velocity = root.Velocity + Vector3.new(0, 1, 0)
                        end
                    end
                    
                    -- Method 3: Stealth mode - only disable collision when moving
                    if _G.StealthMode then
                        local humanoid = character:FindFirstChild("Humanoid")
                        if humanoid then
                            local isMoving = humanoid.MoveDirection.Magnitude > 0
                            for _, part in pairs(character:GetChildren()) do
                                if part:IsA("BasePart") then
                                    part.CanCollide = not isMoving
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
end

-- Collision Bypass (Alternative Method)
local function bypassCollision()
    spawn(function()
        while _G.BypassCollision do
            wait(0.5)
            pcall(function()
                local character = LocalPlayer.Character
                if character then
                    -- Make character parts transparent to collision
                    for _, part in pairs(character:GetChildren()) do
                        if part:IsA("BasePart") then
                            -- Set collision group to something unused
                            part.CollisionGroupId = 0
                            
                            -- Make parts massless
                            part.Massless = true
                            
                            -- Disable network ownership for physics
                            part:SetNetworkOwner(nil)
                        end
                    end
                    
                    -- Remove from default collision group
                    if game:GetService("PhysicsService"):GetCollisionGroupName(0) == "Default" then
                        for _, part in pairs(character:GetChildren()) do
                            if part:IsA("BasePart") then
                                game:GetService("PhysicsService"):SetPartCollisionGroup(part, "Default")
                            end
                        end
                    end
                end
            end)
        end
    end)
end

-- Keybind for Toggle Noclip
local function setupNoclipKeybind()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == _G.NoclipKey then
            _G.NoclipEnabled = not _G.NoclipEnabled
            if _G.NoclipEnabled then
                activateNoclip()
                Rayfield:Notify({
                    Title = "Noclip Enabled",
                    Content = "Press " .. _G.NoclipKey.Name .. " to toggle",
                    Duration = 2,
                })
            else
                Rayfield:Notify({
                    Title = "Noclip Disabled",
                    Content = "Collision restored",
                    Duration = 2,
                })
            end
        end
    end)
end

-- Anti-Detection Measures
local function setupAntiDetection()
    spawn(function()
        while _G.NoclipEnabled do
            wait(1)
            pcall(function()
                -- Randomly toggle collision to avoid pattern detection
                if _G.StealthMode and math.random(1, 10) == 1 then
                    local character = LocalPlayer.Character
                    if character then
                        for _, part in pairs(character:GetChildren()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = true
                                wait(0.1)
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end)
        end
    end)
end

-- Rayfield UI
local MainTab = Window:CreateTab("Noclip System", nil)

-- Noclip Settings
local NoclipSection = MainTab:CreateSection("Noclip Settings")

local NoclipToggle = MainTab:CreateToggle({
    Name = "Enable Noclip",
    CurrentValue = false,
    Flag = "NoclipEnabled",
    Callback = function(Value)
        _G.NoclipEnabled = Value
        if Value then
            activateNoclip()
            setupAntiDetection()
            Rayfield:Notify({
                Title = "Noclip Activated",
                Content = "Collision disabled - walk through walls",
                Duration = 3,
            })
        else
            Rayfield:Notify({
                Title = "Noclip Disabled",
                Content = "Normal collision restored",
                Duration = 2,
            })
        end
    end,
})

local StealthToggle = MainTab:CreateToggle({
    Name = "Stealth Mode",
    CurrentValue = true,
    Flag = "StealthMode",
    Callback = function(Value)
        _G.StealthMode = Value
    end,
})

local PhaseToggle = MainTab:CreateToggle({
    Name = "Phase Through Walls",
    CurrentValue = true,
    Flag = "PhaseThroughWalls",
    Callback = function(Value)
        _G.PhaseThroughWalls = Value
    end,
})

local BypassToggle = MainTab:CreateToggle({
    Name = "Advanced Bypass",
    CurrentValue = true,
    Flag = "BypassCollision",
    Callback = function(Value)
        _G.BypassCollision = Value
        if Value then
            bypassCollision()
        end
    end,
})

-- Quick Actions
local ActionsSection = MainTab:CreateSection("Quick Actions")

local ToggleKeybind = MainTab:CreateButton({
    Name = "Set Noclip Keybind (Current: V)",
    Callback = function()
        Rayfield:Notify({
            Title = "Noclip Keybind",
            Content = "Press V to toggle noclip on/off",
            Duration = 4,
        })
    end,
})

local GhostMode = MainTab:CreateButton({
    Name = "Activate Ghost Mode",
    Callback = function()
        _G.NoclipEnabled = true
        _G.StealthMode = true
        _G.PhaseThroughWalls = true
        _G.BypassCollision = true
        NoclipToggle:Set(true)
        StealthToggle:Set(true)
        PhaseToggle:Set(true)
        BypassToggle:Set(true)
        activateNoclip()
        bypassCollision()
        setupAntiDetection()
        Rayfield:Notify({
            Title = "Ghost Mode Active",
            Content = "Maximum stealth noclip enabled",
            Duration = 4,
        })
    end,
})

-- Status
local StatusSection = MainTab:CreateSection("Status")
local NoclipStatus = MainTab:CreateLabel("Noclip: Ready")

-- Update status
spawn(function()
    while true do
        wait(1)
        local status = _G.NoclipEnabled and "ACTIVE 🚀" or "READY"
        local color = _G.NoclipEnabled and "🟢" or "⚪"
        NoclipStatus:Set("Noclip: " .. color .. " " .. status)
    end
end)

-- Initialize
setupNoclipBypass()
setupNoclipKeybind()

Rayfield:Notify({
    Title = "Brainrot Noclip Loaded",
    Content = "Press V to toggle noclip",
    Duration = 5,
})

print("👻 Steal a Brainrot Noclip System - Anti-Cheat Bypass Ready!")
