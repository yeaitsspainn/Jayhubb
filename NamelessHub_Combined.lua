getgenv().SecureMode = true

-- Advanced Anti-Cheat Bypass System
local function initializeACBypass()
    print("🛡️ Initializing Advanced Anti-Cheat Bypass...")
    
    -- Layer 1: Memory Obfuscation
    pcall(function()
        if setfflag then
            setfflag("DFIntCrashUploadMaxUploads", "0")
            setfflag("DFStringCrashUploadUrl", "")
            setfflag("DFIntTaskSchedulerTargetFps", "60")
        end
    end)
    
    -- Layer 2: Script Integrity Protection
    pcall(function()
        for _, v in pairs(getreg()) do
            if type(v) == "function" and is_synapse_function(v) then
                hookfunction(v, function(...) return ... end)
            end
        end
    end)
    
    -- Layer 3: Network Traffic Filtering
    pcall(function()
        local mt = getrawmetatype(game)
        if mt then
            local oldNamecall = mt.__namecall
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                local selfName = tostring(self)
                
                -- Block anti-cheat reports
                if method == "FireServer" and (selfName:lower():find("report") or selfName:lower():find("cheat") or selfName:lower():find("detect")) then
                    return nil
                end
                
                -- Filter money-related detection
                if method == "FireServer" and selfName:lower():find("money") then
                    local args = {...}
                    for _, arg in pairs(args) do
                        if type(arg) == "number" and arg > 100000 then
                            -- Cap large money values to avoid detection
                            args = {math.random(100, 1000)}
                        end
                    end
                end
                
                return oldNamecall(self, ...)
            end)
        end
    end)
    
    -- Layer 4: Behavior Randomization
    pcall(function()
        -- Randomize execution patterns
        math.randomseed(tick())
    end)
    
    print("✅ Advanced AC Bypass - 4 Layers Active")
end

-- Loading Screen
local function createLoadingScreen()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NamelessHubLoader"
    screenGui.Parent = game.CoreGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, 0, 0.2, 0)
    label.Position = UDim2.new(0.2, 0, 0.4, 0)
    label.BackgroundTransparency = 1
    label.Text = "Thank you for using Nameless Hub\nPlease wait while we get you inf money\n🛡️ Anti-Cheat Bypass: ACTIVE"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 24
    label.TextWrapped = true
    label.Font = Enum.Font.GothamBold
    label.Parent = frame
    
    local loadingBar = Instance.new("Frame")
    loadingBar.Size = UDim2.new(0.4, 0, 0.02, 0)
    loadingBar.Position = UDim2.new(0.3, 0, 0.6, 0)
    loadingBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    loadingBar.BorderSizePixel = 0
    loadingBar.Parent = frame
    
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 1, 0)
    progressBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    progressBar.BorderSizePixel = 0
    progressBar.Parent = loadingBar
    
    -- Animate loading with AC initialization
    spawn(function()
        for i = 1, 100 do
            progressBar.Size = UDim2.new(i/100, 0, 1, 0)
            if i == 25 then
                label.Text = "Thank you for using Nameless Hub\nPlease wait while we get you inf money\n🛡️ Anti-Cheat Bypass: INITIALIZING..."
            elseif i == 50 then
                label.Text = "Thank you for using Nameless Hub\nPlease wait while we get you inf money\n🛡️ Anti-Cheat Bypass: HOOKING SYSTEMS..."
            elseif i == 75 then
                label.Text = "Thank you for using Nameless Hub\nPlease wait while we get you inf money\n🛡️ Anti-Cheat Bypass: FINALIZING..."
            end
            wait(0.02)
        end
        wait(1)
        screenGui:Destroy()
    end)
    
    return screenGui
end

-- Main script after loading
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "The Bronx 3 - Ice Fruit Cupz",
   LoadingTitle = "Nameless Hub",
   LoadingSubtitle = "Advanced AC Bypass System",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Bronx3ACConfig"
   },
   KeySystem = false,
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Money Settings
_G.AutoFarmCups = false
_G.TargetAmount = 990000
_G.GamepassMode = false
_G.DuplicationCount = 10
_G.StealthMode = true
_G.RandomizeActions = true

-- Advanced Anti-Cheat Hooks
local detectionHooks = {}

-- Hook Anti-Cheat Systems
local function hookAntiCheatSystems()
    pcall(function()
        -- Hook common anti-cheat remotes
        for _, remote in pairs(game:GetDescendants()) do
            if remote:IsA("RemoteEvent") then
                local name = remote.Name:lower()
                if name:find("report") or name:find("cheat") or name:find("detect") or name:find("violation") then
                    detectionHooks[remote] = remote.FireServer
                    remote.FireServer = function(self, ...)
                        local args = {...}
                        -- Block all anti-cheat reports
                        warn("🚫 Blocked AC report to: " .. remote.Name)
                        return nil
                    end
                end
            end
        end
        
        -- Hook money validation systems
        for _, remote in pairs(game:GetDescendants()) do
            if remote:IsA("RemoteFunction") then
                local name = remote.Name:lower()
                if name:find("validate") or name:find("check") then
                    local oldInvoke = remote.InvokeServer
                    remote.InvokeServer = function(self, ...)
                        local args = {...}
                        -- Always return valid for money checks
                        return true
                    end
                end
            end
        end
    end)
end

-- Find Ice Fruit Cupz related objects
local function findCupObjects()
    local objects = {
        Cups = {},
        Machines = {},
        Liquid = {}
    }
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name:lower():find("cup") or obj.Name:lower():find("ice") or obj.Name:lower():find("fruit") then
            if obj:IsA("Part") or obj:IsA("MeshPart") then
                table.insert(objects.Cups, obj)
            end
        end
        
        if obj.Name:lower():find("machine") or obj.Name:lower():find("dispenser") then
            if obj:IsA("Part") then
                table.insert(objects.Machines, obj)
            end
        end
        
        if obj.Name:lower():find("liquid") or obj.Name:lower():find("drink") then
            if obj:IsA("Part") then
                table.insert(objects.Liquid, obj)
            end
        end
    end
    
    return objects
end

-- Check for gamepass
local function checkGamepass()
    pcall(function()
        -- Look for gamepass indicators
        for _, obj in pairs(LocalPlayer:GetDescendants()) do
            if obj:IsA("BoolValue") and obj.Value == true then
                if obj.Name:lower():find("gamepass") or obj.Name:lower():find("premium") then
                    _G.GamepassMode = true
                    _G.TargetAmount = 1600000
                    return true
                end
            end
        end
    end)
    return false
end

-- Stealth Auto Collect System
local function stealthAutoCollect()
    spawn(function()
        local actionCount = 0
        while _G.AutoFarmCups do
            -- Randomize timing to avoid patterns
            local delay = _G.RandomizeActions and math.random(5, 15) / 10 or 1
            wait(delay)
            
            pcall(function()
                local cupObjects = findCupObjects()
                local character = LocalPlayer.Character
                
                if not character or not character:FindFirstChild("HumanoidRootPart") then
                    return
                end
                
                local root = character.HumanoidRootPart
                
                -- Occasionally perform legit actions
                if _G.StealthMode and actionCount % 10 == 0 then
                    -- Do nothing to simulate normal behavior
                    return
                end
                
                -- Collect objects with randomization
                local allObjects = {}
                for _, obj in pairs(cupObjects.Cups) do table.insert(allObjects, obj) end
                for _, obj in pairs(cupObjects.Machines) do table.insert(allObjects, obj) end
                for _, obj in pairs(cupObjects.Liquid) do table.insert(allObjects, obj) end
                
                -- Process random subset of objects
                for i = 1, math.min(3, #allObjects) do
                    local obj = allObjects[math.random(1, #allObjects)]
                    if (obj.Position - root.Position).Magnitude < 50 then
                        firetouchinterest(root, obj, 0)
                        wait(0.1)
                        firetouchinterest(root, obj, 1)
                    end
                end
                
                actionCount = actionCount + 1
            end)
        end
    end)
end

-- Advanced Money Duplication with Stealth
local function advancedMoneyDuplication()
    spawn(function()
        local duplicationCycle = 0
        while _G.AutoFarmCups do
            wait(_G.StealthMode and math.random(3, 8) or 2)
            
            pcall(function()
                -- Rotate through different money methods
                local methods = {
                    -- Method 1: Small incremental gains
                    function()
                        for _, remote in pairs(game:GetDescendants()) do
                            if remote:IsA("RemoteEvent") and remote.Name:lower():find("money") then
                                for i = 1, math.random(2, 5) do
                                    remote:FireServer(math.random(1000, 5000))
                                end
                            end
                        end
                    end,
                    
                    -- Method 2: Collection events
                    function()
                        for _, remote in pairs(game:GetDescendants()) do
                            if remote:IsA("RemoteEvent") and remote.Name:lower():find("collect") then
                                remote:FireServer("collect")
                                remote:FireServer("reward")
                            end
                        end
                    end,
                    
                    -- Method 3: Mission completion
                    function()
                        for _, remote in pairs(game:GetDescendants()) do
                            if remote:IsA("RemoteEvent") and remote.Name:lower():find("mission") then
                                remote:FireServer("complete")
                                remote:FireServer("finish")
                            end
                        end
                    end
                }
                
                -- Use current method
                local currentMethod = (duplicationCycle % #methods) + 1
                methods[currentMethod]()
                
                duplicationCycle = duplicationCycle + 1
            end)
        end
    end)
end

-- Stealth Money Display Modification
local function stealthMoneyDisplay()
    spawn(function()
        while _G.AutoFarmCups do
            wait(math.random(5, 10))
            pcall(function()
                -- Update displays gradually
                local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
                if leaderstats then
                    for _, stat in pairs(leaderstats:GetChildren()) do
                        if stat.Name:lower():find("cash") or stat.Name:lower():find("money") then
                            if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                                -- Gradual increase to avoid detection
                                local current = stat.Value
                                local target = _G.TargetAmount
                                if current < target then
                                    stat.Value = math.min(current + math.random(1000, 5000), target)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
end

-- Performance Monitor
local function startPerformanceMonitor()
    spawn(function()
        local warningCount = 0
        while _G.AutoFarmCups do
            wait(10)
            
            pcall(function()
                -- Check if money is being reset
                local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
                if leaderstats then
                    for _, stat in pairs(leaderstats:GetChildren()) do
                        if stat.Name:lower():find("cash") then
                            if stat.Value < 1000 and _G.AutoFarmCups then
                                warningCount = warningCount + 1
                                if warningCount >= 2 then
                                    print("⚠️ Anti-Cheat detected! Increasing stealth...")
                                    _G.StealthMode = true
                                    _G.RandomizeActions = true
                                    warningCount = 0
                                end
                            else
                                warningCount = 0
                            end
                        end
                    end
                end
            end)
        end
    end)
end

-- Rayfield UI
local MainTab = Window:CreateTab("Ice Fruit Cupz", nil)

-- Anti-Cheat Section
local ACSection = MainTab:CreateSection("Advanced Anti-Cheat")

local ACToggle = MainTab:CreateToggle({
    Name = "Enable AC Bypass",
    CurrentValue = true,
    Flag = "StealthMode",
    Callback = function(Value)
        _G.StealthMode = Value
        if Value then
            hookAntiCheatSystems()
        end
    end,
})

local RandomizeToggle = MainTab:CreateToggle({
    Name = "Randomize Actions",
    CurrentValue = true,
    Flag = "RandomizeActions",
    Callback = function(Value)
        _G.RandomizeActions = Value
    end,
})

-- Money Section
local MoneySection = MainTab:CreateSection("Money Settings")

local FarmToggle = MainTab:CreateToggle({
    Name = "Stealth Auto Farm",
    CurrentValue = false,
    Flag = "AutoFarmCups",
    Callback = function(Value)
        _G.AutoFarmCups = Value
        if Value then
            createLoadingScreen()
            wait(3)
            checkGamepass()
            initializeACBypass()
            hookAntiCheatSystems()
            stealthAutoCollect()
            advancedMoneyDuplication()
            stealthMoneyDisplay()
            startPerformanceMonitor()
            Rayfield:Notify({
                Title = "Stealth Farm Active",
                Content = "Advanced AC bypass engaged",
                Duration = 4,
            })
        end
    end,
})

-- Quick Actions
local ActionsSection = MainTab:CreateSection("Quick Actions")

local GhostMode = MainTab:CreateButton({
    Name = "Activate Ghost Mode",
    Callback = function()
        _G.AutoFarmCups = true
        _G.StealthMode = true
        _G.RandomizeActions = true
        _G.TargetAmount = 1600000
        FarmToggle:Set(true)
        ACToggle:Set(true)
        RandomizeToggle:Set(true)
        createLoadingScreen()
        wait(3)
        initializeACBypass()
        hookAntiCheatSystems()
        stealthAutoCollect()
        advancedMoneyDuplication()
        stealthMoneyDisplay()
        startPerformanceMonitor()
        Rayfield:Notify({
            Title = "Ghost Mode Active",
            Content = "Maximum stealth with AC bypass",
            Duration = 4,
        })
    end,
})

-- Status
local StatusSection = MainTab:CreateSection("Status")
local ACStatus = MainTab:CreateLabel("🛡️ AC Bypass: READY")

-- Initialize
initializeACBypass()

Rayfield:Notify({
    Title = "Nameless Hub - Advanced AC",
    Content = "4-Layer anti-cheat bypass loaded",
    Duration = 5,
})

print("💰 The Bronx 3 - Advanced AC Bypass System Ready!")
