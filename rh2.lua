getgenv().SecureMode = true

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Force Character Death",
   LoadingTitle = "True Kill System",
   LoadingSubtitle = "Forces Visual + Server Death",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "TrueKillConfig"
   },
   KeySystem = false,
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Kill Settings
_G.ForceDeath = false
_G.RagdollPlayers = true
_G.RemoveCharacters = false
_G.DeathAura = false
_G.DeathRange = 30

-- Force character death (visual + server)
local function forceCharacterDeath(target)
    pcall(function()
        local targetChar = target.Character
        if not targetChar then return end
        
        local humanoid = targetChar:FindFirstChild("Humanoid")
        if not humanoid then return end
        
        print("💀 Forcing death on: " .. target.Name)
        
        -- METHOD 1: Force server death via remotes
        for _, remote in pairs(game:GetDescendants()) do
            if remote:IsA("RemoteEvent") then
                local name = remote.Name:lower()
                if name:find("death") or name:find("die") or name:find("dead") or name:find("kill") then
                    remote:FireServer(target)
                    remote:FireServer(targetChar)
                    remote:FireServer("death")
                    remote:FireServer("die")
                end
            end
        end
        
        -- METHOD 2: Break character physically
        if _G.RagdollPlayers then
            for _, part in pairs(targetChar:GetChildren()) do
                if part:IsA("Part") or part:IsA("MeshPart") then
                    part:BreakJoints() -- This forces ragdoll
                    
                    -- Make parts fall through floor
                    if part:FindFirstChild("BodyVelocity") then
                        part.BodyVelocity:Destroy()
                    end
                    if part:FindFirstChild("BodyGyro") then
                        part.BodyGyro:Destroy()
                    end
                    
                    -- Add gravity force
                    local bodyForce = Instance.new("BodyForce")
                    bodyForce.Force = Vector3.new(0, part:GetMass() * -196.2, 0)
                    bodyForce.Parent = part
                end
            end
        end
        
        -- METHOD 3: Remove humanoid (forces respawn)
        if _G.RemoveCharacters then
            humanoid:Destroy()
            
            -- Also remove other essential parts
            local root = targetChar:FindFirstChild("HumanoidRootPart")
            if root then
                root:Destroy()
            end
        end
        
        -- METHOD 4: Force respawn via player controller
        pcall(function()
            target:LoadCharacter() -- Force respawn which shows death
        end)
        
        -- METHOD 5: Teleport to death zone
        local root = targetChar:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = CFrame.new(0, -1000, 0) -- Far underground
        end
        
        -- METHOD 6: Set health to 0 on client AND try to sync to server
        humanoid.Health = 0
        
        -- METHOD 7: Force death animation
        for _, animTrack in pairs(humanoid:GetPlayingAnimationTracks()) do
            if animTrack.Name:lower():find("death") or animTrack.Name:lower():find("die") then
                animTrack:Play()
            end
        end
        
        -- METHOD 8: Look for custom death systems
        for _, script in pairs(targetChar:GetDescendants()) do
            if script:IsA("Script") then
                if script.Name:lower():find("death") or script.Name:lower():find("health") then
                    pcall(function()
                        script:FireServer("death")
                        script:FireServer("die")
                    end)
                end
            end
        end
        
        -- METHOD 9: Force server update via network ownership
        if root then
            root:SetNetworkOwner(nil) -- Makes physics server-sided
        end
        
        print("✅ Death forced: " .. target.Name)
    end)
end

-- Death aura system
local function startDeathAura()
    spawn(function()
        while _G.DeathAura do
            wait(0.2)
            pcall(function()
                local myChar = LocalPlayer.Character
                if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then
                    return
                end
                
                local myRoot = myChar.HumanoidRootPart
                
                for _, target in pairs(Players:GetPlayers()) do
                    if target ~= LocalPlayer and target.Character then
                        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
                        if targetRoot then
                            local distance = (myRoot.Position - targetRoot.Position).Magnitude
                            if distance <= _G.DeathRange then
                                forceCharacterDeath(target)
                            end
                        end
                    end
                end
            end)
        end
    end)
end

-- Force death on all players
local function forceAllDeaths()
    spawn(function()
        while _G.ForceDeath do
            wait(0.5)
            pcall(function()
                for _, target in pairs(Players:GetPlayers()) do
                    if target ~= LocalPlayer then
                        forceCharacterDeath(target)
                    end
                end
            end)
        end
    end)
end

-- Test death on one player
local function testDeath()
    pcall(function()
        local targets = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                table.insert(targets, player)
            end
        end
        
        if #targets > 0 then
            local target = targets[1]
            Rayfield:Notify({
                Title = "Testing Death",
                Content = "Forcing death on " .. target.Name,
                Duration = 3,
            })
            forceCharacterDeath(target)
        end
    end)
end

-- Check if players are actually dead
local function checkDeathStatus()
    local deadPlayers = 0
    local totalPlayers = 0
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            totalPlayers = totalPlayers + 1
            if not player.Character or (player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health <= 0) then
                deadPlayers = deadPlayers + 1
            end
        end
    end
    
    return deadPlayers, totalPlayers
end

-- Rayfield UI
local MainTab = Window:CreateTab("Force Death", nil)

-- Death Settings
local DeathSection = MainTab:CreateSection("Death Settings")

local ForceDeathToggle = MainTab:CreateToggle({
    Name = "Force Death All Players",
    CurrentValue = false,
    Flag = "ForceDeath",
    Callback = function(Value)
        _G.ForceDeath = Value
        if Value then
            forceAllDeaths()
            Rayfield:Notify({
                Title = "Force Death Active",
                Content = "Forcing visual + server death",
                Duration = 3,
            })
        end
    end,
})

local DeathAuraToggle = MainTab:CreateToggle({
    Name = "Death Aura",
    CurrentValue = false,
    Flag = "DeathAura",
    Callback = function(Value)
        _G.DeathAura = Value
        if Value then
            startDeathAura()
            Rayfield:Notify({
                Title = "Death Aura Active",
                Content = "Killing players in range",
                Duration = 3,
            })
        end
    end,
})

local RagdollToggle = MainTab:CreateToggle({
    Name = "Force Ragdoll",
    CurrentValue = true,
    Flag = "RagdollPlayers",
    Callback = function(Value)
        _G.RagdollPlayers = Value
    end,
})

local RemoveToggle = MainTab:CreateToggle({
    Name = "Remove Characters",
    CurrentValue = false,
    Flag = "RemoveCharacters",
    Callback = function(Value)
        _G.RemoveCharacters = Value
    end,
})

local RangeSlider = MainTab:CreateSlider({
    Name = "Death Range",
    Range = {10, 50},
    Increment = 5,
    Suffix = "studs",
    CurrentValue = 30,
    Flag = "DeathRange",
    Callback = function(Value)
        _G.DeathRange = Value
    end,
})

-- Quick Actions
local ActionsSection = MainTab:CreateSection("Quick Actions")

local TestDeathBtn = MainTab:CreateButton({
    Name = "Test Death System",
    Callback = testDeath
})

local CheckStatusBtn = MainTab:CreateButton({
    Name = "Check Death Status",
    Callback = function()
        local dead, total = checkDeathStatus()
        Rayfield:Notify({
            Title = "Death Status",
            Content = dead .. "/" .. total .. " players dead",
            Duration = 4,
        })
    end,
})

local AnnihilationBtn = MainTab:CreateButton({
    Name = "Activate Annihilation",
    Callback = function()
        _G.ForceDeath = true
        _G.DeathAura = true
        _G.RagdollPlayers = true
        _G.RemoveCharacters = true
        ForceDeathToggle:Set(true)
        DeathAuraToggle:Set(true)
        RagdollToggle:Set(true)
        RemoveToggle:Set(true)
        forceAllDeaths()
        startDeathAura()
        Rayfield:Notify({
            Title = "ANNIHILATION ACTIVE",
            Content = "Maximum death force enabled",
            Duration = 4,
        })
    end,
})

-- Status
local StatusSection = MainTab:CreateSection("Death Status")
local DeathStatus = MainTab:CreateLabel("Monitoring...")

-- Update death status
spawn(function()
    while true do
        wait(2)
        local dead, total = checkDeathStatus()
        DeathStatus:Set("Dead: " .. dead .. "/" .. total .. " | Force: " .. (_G.ForceDeath and "ON" or "OFF"))
    end
end)

Rayfield:Notify({
    Title = "Force Death System Loaded",
    Content = "Fixes visual desync - forces actual death",
    Duration = 5,
})

print("💀 Force Death System initialized - Fixing visual desync!")
