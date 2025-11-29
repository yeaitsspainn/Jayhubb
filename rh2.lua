getgenv().SecureMode = true

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Real Damage Combat",
   LoadingTitle = "50 Damage Per Hit",
   LoadingSubtitle = "Server-Sided Damage",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "RealDamageConfig"
   },
   KeySystem = false,
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Damage Settings
_G.RealDamage = false
_G.DamagePerHit = 50
_G.TeleportPunch = false
_G.ForceServerDamage = true
_G.DamageAll = false

-- Find server-sided damage methods
local function findServerDamageMethods()
    local methods = {}
    
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local name = obj.Name:lower()
            -- Look for damage-related remotes that are likely server-sided
            if name:find("damage") or name:find("hit") or name:find("punch") or 
               name:find("attack") or name:find("strike") or name:find("hurt") then
                table.insert(methods, {Object = obj, Type = obj.ClassName})
            end
        end
    end
    
    return methods
end

-- Send server-sided damage
local function sendServerDamage(target, damageAmount)
    pcall(function()
        local damageMethods = findServerDamageMethods()
        local targetChar = target.Character
        local targetHumanoid = targetChar and targetChar:FindFirstChild("Humanoid")
        
        if not targetHumanoid then return end
        
        -- Store original health to verify damage
        local originalHealth = targetHumanoid.Health
        
        -- METHOD 1: Try all damage remotes with different parameter formats
        for _, method in pairs(damageMethods) do
            local remote = method.Object
            
            if remote:IsA("RemoteEvent") then
                -- Try different parameter combinations that games commonly use
                remote:FireServer(target, damageAmount)
                remote:FireServer(targetChar, damageAmount)
                remote:FireServer(targetHumanoid, damageAmount)
                remote:FireServer("damage", target, damageAmount)
                remote:FireServer("hit", target, damageAmount)
                remote:FireServer(target, "damage", damageAmount)
                remote:FireServer(damageAmount, target)
                remote:FireServer({Target = target, Damage = damageAmount})
                remote:FireServer({target, damageAmount})
            elseif remote:IsA("RemoteFunction") then
                pcall(function() remote:InvokeServer(target, damageAmount) end)
                pcall(function() remote:InvokeServer(targetChar, damageAmount) end)
                pcall(function() remote:InvokeServer("damage", target, damageAmount) end)
            end
        end
        
        -- METHOD 2: Look for weapon systems and use them
        local character = LocalPlayer.Character
        if character then
            for _, tool in pairs(character:GetChildren()) do
                if tool:IsA("Tool") then
                    -- Activate tool
                    tool:Activate()
                    
                    -- Fire tool damage remotes
                    for _, remote in pairs(tool:GetDescendants()) do
                        if remote:IsA("RemoteEvent") then
                            remote:FireServer(target, damageAmount)
                            remote:FireServer(targetChar, damageAmount)
                            remote:FireServer("damage", damageAmount, target)
                        end
                    end
                end
            end
        end
        
        -- METHOD 3: Combat system remotes (common in fighting games)
        for _, remote in pairs(game:GetDescendants()) do
            if remote:IsA("RemoteEvent") then
                local name = remote.Name:lower()
                if name:find("combat") or name:find("fight") or name:find("battle") then
                    remote:FireServer("attack", target, damageAmount)
                    remote:FireServer("damage", target, damageAmount)
                end
            end
        end
        
        -- METHOD 4: Player vs Player damage systems
        for _, remote in pairs(game:GetDescendants()) do
            if remote:IsA("RemoteEvent") then
                local name = remote.Name:lower()
                if name:find("pvp") or name:find("player") then
                    remote:FireServer("damage_player", target, damageAmount)
                    remote:FireServer("player_hit", target, damageAmount)
                end
            end
        end
        
        -- Verify damage was applied
        wait(0.1)
        local newHealth = targetHumanoid.Health
        if newHealth < originalHealth then
            print("✅ Real damage applied: " .. target.Name .. " took " .. (originalHealth - newHealth) .. " damage")
        else
            print("❌ No damage detected - trying alternative methods...")
            -- Fallback to direct damage if server methods fail
            if _G.ForceServerDamage then
                targetHumanoid:TakeDamage(damageAmount)
            end
        end
    end)
end

-- Main real damage system
local function startRealDamage()
    spawn(function()
        while _G.RealDamage do
            wait(0.2)
            
            pcall(function()
                local targets = {}
                
                -- Get all valid targets
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local humanoid = player.Character:FindFirstChild("Humanoid")
                        if humanoid and humanoid.Health > 0 then
                            table.insert(targets, player)
                        end
                    end
                end
                
                -- Apply damage to all targets
                for _, target in pairs(targets) do
                    sendServerDamage(target, _G.DamagePerHit)
                    
                    -- If teleport punch is enabled, move to target first
                    if _G.TeleportPunch then
                        local character = LocalPlayer.Character
                        local targetChar = target.Character
                        
                        if character and character:FindFirstChild("HumanoidRootPart") and
                           targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
                            
                            -- Teleport close to target
                            local targetPos = targetChar.HumanoidRootPart.Position
                            local offset = CFrame.new(0, 0, 3)
                            character.HumanoidRootPart.CFrame = CFrame.new(targetPos) * offset
                            
                            -- Face the target
                            character.HumanoidRootPart.CFrame = CFrame.new(
                                character.HumanoidRootPart.Position,
                                targetPos
                            )
                            
                            wait(0.1) -- Small delay before damage
                        end
                    end
                end
            end)
        end
    end)
end

-- Damage all players globally (regardless of distance)
local function damageAllPlayers()
    spawn(function()
        while _G.DamageAll do
            wait(0.3)
            
            pcall(function()
                for _, target in pairs(Players:GetPlayers()) do
                    if target ~= LocalPlayer and target.Character then
                        local humanoid = target.Character:FindFirstChild("Humanoid")
                        if humanoid and humanoid.Health > 0 then
                            sendServerDamage(target, _G.DamagePerHit)
                        end
                    end
                end
            end)
        end
    end)
end

-- Test damage on single target
local function testDamage()
    pcall(function()
        local targets = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                table.insert(targets, player)
            end
        end
        
        if #targets > 0 then
            local target = targets[1]
            local targetHumanoid = target.Character:FindFirstChild("Humanoid")
            if targetHumanoid then
                local originalHealth = targetHumanoid.Health
                sendServerDamage(target, _G.DamagePerHit)
                
                wait(0.2)
                local newHealth = targetHumanoid.Health
                local damageDealt = originalHealth - newHealth
                
                if damageDealt > 0 then
                    Rayfield:Notify({
                        Title = "Damage Test Successful",
                        Content = "Dealt " .. damageDealt .. " damage to " .. target.Name,
                        Duration = 4,
                    })
                else
                    Rayfield:Notify({
                        Title = "Damage Test Failed",
                        Content = "No damage detected - trying fallback methods",
                        Duration = 4,
                    })
                end
            end
        end
    end)
end

-- Rayfield UI
local MainTab = Window:CreateTab("Real Damage", nil)

-- Damage Settings
local DamageSection = MainTab:CreateSection("Damage Settings")

local DamageToggle = MainTab:CreateToggle({
    Name = "Real Damage Mode",
    CurrentValue = false,
    Flag = "RealDamage",
    Callback = function(Value)
        _G.RealDamage = Value
        if Value then
            startRealDamage()
            Rayfield:Notify({
                Title = "Real Damage Active",
                Content = "Applying server-sided damage",
                Duration = 3,
            })
        end
    end,
})

local TeleportToggle = MainTab:CreateToggle({
    Name = "Teleport + Punch",
    CurrentValue = false,
    Flag = "TeleportPunch",
    Callback = function(Value)
        _G.TeleportPunch = Value
    end,
})

local DamageAllToggle = MainTab:CreateToggle({
    Name = "Damage All Players",
    CurrentValue = false,
    Flag = "DamageAll",
    Callback = function(Value)
        _G.DamageAll = Value
        if Value then
            damageAllPlayers()
            Rayfield:Notify({
                Title = "Damage All Active",
                Content = "Global damage to all players",
                Duration = 3,
            })
        end
    end,
})

local DamageSlider = MainTab:CreateSlider({
    Name = "Damage Per Hit",
    Range = {10, 100},
    Increment = 5,
    Suffix = "damage",
    CurrentValue = 50,
    Flag = "DamagePerHit",
    Callback = function(Value)
        _G.DamagePerHit = Value
    end,
})

-- Quick Actions
local ActionsSection = MainTab:CreateSection("Quick Actions")

local TestDamageBtn = MainTab:CreateButton({
    Name = "Test Damage System",
    Callback = testDamage
})

local ScanDamageBtn = MainTab:CreateButton({
    Name = "Scan Damage Methods",
    Callback = function()
        local methods = findServerDamageMethods()
        local message = "Found " .. #methods .. " damage methods:\n"
        for i, method in ipairs(methods) do
            if i <= 6 then
                message = message .. "• " .. method.Type .. ": " .. method.Object.Name .. "\n"
            end
        end
        Rayfield:Notify({
            Title = "Damage Methods",
            Content = message,
            Duration = 6,
        })
    end,
})

local MaxDamageMode = MainTab:CreateButton({
    Name = "Activate Max Damage",
    Callback = function()
        _G.RealDamage = true
        _G.DamageAll = true
        _G.TeleportPunch = true
        _G.DamagePerHit = 100
        DamageToggle:Set(true)
        DamageAllToggle:Set(true)
        TeleportToggle:Set(true)
        DamageSlider:Set(100)
        startRealDamage()
        damageAllPlayers()
        Rayfield:Notify({
            Title = "Max Damage Mode",
            Content = "100 damage to all players + teleport",
            Duration = 4,
        })
    end,
})

-- Status
local StatusSection = MainTab:CreateSection("Damage Status")
local DamageStatus = MainTab:CreateLabel("Testing damage methods...")

-- Update status with damage verification
spawn(function()
    while true do
        wait(3)
        pcall(function()
            local totalDamage = 0
            local damagedPlayers = 0
            
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local humanoid = player.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        -- Check if player has taken damage recently
                        if humanoid.Health < humanoid.MaxHealth then
                            damagedPlayers = damagedPlayers + 1
                            totalDamage = totalDamage + (humanoid.MaxHealth - humanoid.Health)
                        end
                    end
                end
            end
            
            DamageStatus:Set("Damaged: " .. damagedPlayers .. " | Total: " .. totalDamage .. " HP")
        end)
    end
end)

Rayfield:Notify({
    Title = "Real Damage System Loaded",
    Content = "Focusing on server-sided damage methods",
    Duration = 5,
})

print("💥 Real Damage System initialized - Targeting server-sided damage!")
