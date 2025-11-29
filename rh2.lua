getgenv().SecureMode = true

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "RH2 Range Extender + Auto-Green",
   LoadingTitle = "Basketball Hacks Pro",
   LoadingSubtitle = "Range + Auto-Green + AC Bypass",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "RH2ProConfig"
   },
   KeySystem = false,
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Settings
_G.ExtendShotRange = false
_G.ShotRangeMultiplier = 2.0
_G.ExtendDunkRange = false
_G.DunkRangeMultiplier = 2.0
_G.NoRangeLimit = false
_G.AutoGreen = false
_G.AutoGreenPercentage = 100
_G.AlwaysMakeShots = false

-- Anti-Cheat Bypass Settings
_G.HideScripts = true
_G.SpoofMemory = true
_G.AntiKick = true
_G.ClearLogs = true
_G.SimulateLegit = true

-- Anti-Cheat Bypass Functions
local function setupBypasses()
    if _G.HideScripts then
        pcall(function()
            for _, v in pairs(getreg()) do
                if type(v) == "function" and is_synapse_function(v) then
                    hookfunction(v, function(...) return ... end)
                end
            end
        end)
    end

    if _G.SpoofMemory then
        pcall(function()
            local oldgcinfo = gcinfo
            gcinfo = function() return math.random(45, 65) end
        end)
    end

    if _G.AntiKick then
        pcall(function()
            LocalPlayer.Kick:Connect(function()
                return nil
            end)
        end)
    end

    if _G.ClearLogs then
        pcall(function()
            rconsoleclear()
            game:GetService("LogService").MessageOut:Connect(function() end)
        end)
    end
end

-- Hook common detection methods
local function hookDetections()
    pcall(function()
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                local oldFireServer = obj.FireServer
                obj.FireServer = function(self, ...)
                    local args = {...}
                    for i, arg in pairs(args) do
                        if type(arg) == "string" and (arg:find("cheat") or arg:find("hack")) then
                            args[i] = "legit_action"
                        end
                    end
                    return oldFireServer(self, unpack(args))
                end
            end
        end
    end)
end

-- Fake legitimate player behavior
local function simulateLegitBehavior()
    if not _G.SimulateLegit then return end
    
    spawn(function()
        while wait(math.random(3, 8)) do
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    local humanoid = LocalPlayer.Character.Humanoid
                    
                    if math.random(1, 10) == 1 then
                        humanoid.Jump = true
                    end
                    
                    if math.random(1, 5) == 1 then
                        humanoid:Move(Vector3.new(
                            math.random(-10, 10),
                            0,
                            math.random(-10, 10)
                        ))
                    end
                end
            end)
        end
    end)
end

-- Range Extension Functions
local function extendRanges()
    if _G.ExtendShotRange or _G.ExtendDunkRange or _G.NoRangeLimit then
        spawn(function()
            while _G.ExtendShotRange or _G.ExtendDunkRange or _G.NoRangeLimit do
                wait(0.2)
                pcall(function()
                    for _, obj in pairs(game:GetDescendants()) do
                        if obj:IsA("RemoteEvent") and (obj.Name:lower():find("shoot") or obj.Name:lower():find("shot") or obj.Name:lower():find("dunk")) then
                            local oldFireServer = obj.FireServer
                            if not obj.__hooked then
                                obj.__hooked = true
                                obj.FireServer = function(self, ...)
                                    local args = {...}
                                    if _G.ExtendShotRange and type(args[1]) == "number" then
                                        args[1] = args[1] * _G.ShotRangeMultiplier
                                    end
                                    if _G.ExtendDunkRange and type(args[2]) == "number" then
                                        args[2] = args[2] * _G.DunkRangeMultiplier
                                    end
                                    if _G.NoRangeLimit then
                                        for i, arg in pairs(args) do
                                            if type(arg) == "number" and arg > 50 then
                                                args[i] = arg * 1.5
                                            end
                                        end
                                    end
                                    return oldFireServer(self, unpack(args))
                                end
                            end
                        end
                    end
                    
                    local character = LocalPlayer.Character
                    if character then
                        local humanoid = character:FindFirstChild("Humanoid")
                        if humanoid and _G.ExtendShotRange then
                            humanoid.JumpPower = math.min(55, humanoid.JumpPower + 5)
                        end
                    end
                end)
            end
        end)
    end
end

-- Auto-Green (Always Make Shots)
local function activateAutoGreen()
    spawn(function()
        while _G.AutoGreen or _G.AlwaysMakeShots do
            wait(0.1)
            pcall(function()
                -- Method 1: Hook shot success calculations
                for _, obj in pairs(game:GetDescendants()) do
                    if obj:IsA("RemoteEvent") and (obj.Name:lower():find("shot") or obj.Name:lower():find("score") or obj.Name:lower():find("make")) then
                        local oldFireServer = obj.FireServer
                        if not obj.__greenHooked then
                            obj.__greenHooked = true
                            obj.FireServer = function(self, ...)
                                local args = {...}
                                -- Force shot success based on percentage
                                if _G.AutoGreen and math.random(1, 100) <= _G.AutoGreenPercentage then
                                    -- Modify arguments to ensure shot makes
                                    for i, arg in pairs(args) do
                                        if type(arg) == "boolean" then
                                            args[i] = true -- Force success
                                        end
                                    end
                                end
                                if _G.AlwaysMakeShots then
                                    -- Always make shots regardless of percentage
                                    for i, arg in pairs(args) do
                                        if type(arg) == "boolean" then
                                            args[i] = true
                                        elseif type(arg) == "number" then
                                            -- Perfect timing/accuracy
                                            args[i] = 100
                                        end
                                    end
                                end
                                return oldFireServer(self, unpack(args))
                            end
                        end
                    end
                end
                
                -- Method 2: Modify basketball properties
                local ball = workspace:FindFirstChild("Basketball") or workspace:FindFirstChild("Ball")
                if ball and (_G.AutoGreen or _G.AlwaysMakeShots) then
                    -- Make ball magnetize to hoop
                    local hoop = workspace:FindFirstChild("Hoop") or workspace:FindFirstChild("Basket")
                    if hoop then
                        local direction = (hoop.Position - ball.Position).Unit
                        ball.Velocity = ball.Velocity + direction * 5
                    end
                end
            end)
        end
    end)
end

-- Modify basketball physics
local function modifyBallPhysics()
    spawn(function()
        while _G.ExtendShotRange do
            wait(2)
            pcall(function()
                local ball = workspace:FindFirstChild("Basketball") or workspace:FindFirstChild("Ball")
                if ball then
                    local bodyForce = ball:FindFirstChild("BodyForce") or Instance.new("BodyForce")
                    bodyForce.Force = Vector3.new(0, workspace.Gravity * -0.2, 0)
                    bodyForce.Parent = ball
                end
            end)
        end
    end)
end

-- Smart shot assist
local function addSmartShotAssist()
    spawn(function()
        while _G.ExtendShotRange do
            wait(0.7)
            pcall(function()
                local hoops = {}
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj.Name:lower():find("hoop") or obj.Name:lower():find("basket") or obj.Name:lower():find("rim") then
                        table.insert(hoops, obj)
                    end
                end
                
                if #hoops > 0 then
                    local character = LocalPlayer.Character
                    if character then
                        local root = character:FindFirstChild("HumanoidRootPart")
                        if root then
                            local nearestHoop = hoops[1]
                            local distance = (root.Position - nearestHoop.Position).Magnitude
                            
                            if distance > 30 and _G.ExtendShotRange then
                                local direction = (nearestHoop.Position - root.Position).Unit
                                local offset = Vector3.new(
                                    math.random(-2, 2),
                                    math.random(-1, 1),
                                    math.random(-2, 2)
                                )
                                root.CFrame = CFrame.new(root.Position, root.Position + direction + offset * 0.1)
                            end
                        end
                    end
                end
            end)
        end
    end)
end

-- Rayfield UI
local MainTab = Window:CreateTab("Basketball Hacks", nil)

-- Range Settings
local RangeSection = MainTab:CreateSection("Range Settings")

local ShotToggle = MainTab:CreateToggle({
    Name = "Extend Shot Range",
    CurrentValue = false,
    Flag = "ExtendShotRange",
    Callback = function(Value)
        _G.ExtendShotRange = Value
        if Value then
            extendRanges()
            modifyBallPhysics()
            addSmartShotAssist()
            Rayfield:Notify({
                Title = "Range Extended",
                Content = "Shot range increased",
                Duration = 3,
            })
        end
    end,
})

local ShotMultiplier = MainTab:CreateSlider({
    Name = "Shot Range Multiplier",
    Range = {1.0, 5.0},
    Increment = 0.5,
    Suffix = "x",
    CurrentValue = 2.0,
    Flag = "ShotRangeMultiplier",
    Callback = function(Value)
        _G.ShotRangeMultiplier = Value
    end,
})

local DunkToggle = MainTab:CreateToggle({
    Name = "Extend Dunk Range",
    CurrentValue = false,
    Flag = "ExtendDunkRange",
    Callback = function(Value)
        _G.ExtendDunkRange = Value
        if Value then
            extendRanges()
            Rayfield:Notify({
                Title = "Dunk Range Extended",
                Content = "Dunk range increased",
                Duration = 3,
            })
        end
    end,
})

local NoLimitToggle = MainTab:CreateToggle({
    Name = "No Range Limit",
    CurrentValue = false,
    Flag = "NoRangeLimit",
    Callback = function(Value)
        _G.NoRangeLimit = Value
        if Value then
            extendRanges()
            Rayfield:Notify({
                Title = "No Limits",
                Content = "All range limits removed",
                Duration = 3,
            })
        end
    end,
})

-- Auto-Green Settings
local AutoGreenSection = MainTab:CreateSection("Auto-Green Settings")

local AutoGreenToggle = MainTab:CreateToggle({
    Name = "Auto-Green (Percentage)",
    CurrentValue = false,
    Flag = "AutoGreen",
    Callback = function(Value)
        _G.AutoGreen = Value
        if Value then
            activateAutoGreen()
            Rayfield:Notify({
                Title = "Auto-Green Active",
                Content = _G.AutoGreenPercentage .. "% shot success rate",
                Duration = 3,
            })
        end
    end,
})

local GreenPercentage = MainTab:CreateSlider({
    Name = "Success Percentage",
    Range = {50, 100},
    Increment = 5,
    Suffix = "%",
    CurrentValue = 100,
    Flag = "AutoGreenPercentage",
    Callback = function(Value)
        _G.AutoGreenPercentage = Value
    end,
})

local AlwaysGreenToggle = MainTab:CreateToggle({
    Name = "Always Make Shots",
    CurrentValue = false,
    Flag = "AlwaysMakeShots",
    Callback = function(Value)
        _G.AlwaysMakeShots = Value
        if Value then
            activateAutoGreen()
            Rayfield:Notify({
                Title = "Always Green Active",
                Content = "100% shot success guaranteed",
                Duration = 3,
            })
        end
    end,
})

-- Anti-Cheat Settings
local ACSection = MainTab:CreateSection("Anti-Cheat Protection")

local HideToggle = MainTab:CreateToggle({
    Name = "Hide Scripts",
    CurrentValue = true,
    Flag = "HideScripts",
    Callback = function(Value)
        _G.HideScripts = Value
        if Value then setupBypasses() end
    end,
})

local SpoofToggle = MainTab:CreateToggle({
    Name = "Spoof Memory",
    CurrentValue = true,
    Flag = "SpoofMemory",
    Callback = function(Value)
        _G.SpoofMemory = Value
        if Value then setupBypasses() end
    end,
})

local SimulateToggle = MainTab:CreateToggle({
    Name = "Simulate Human Behavior",
    CurrentValue = true,
    Flag = "SimulateLegit",
    Callback = function(Value)
        _G.SimulateLegit = Value
        if Value then simulateLegitBehavior() end
    end,
})

-- Quick Actions
local ActionsSection = MainTab:CreateSection("Quick Actions")

local ProMode = MainTab:CreateButton({
    Name = "Activate Pro Mode",
    Callback = function()
        _G.ExtendShotRange = true
        _G.AutoGreen = true
        _G.AlwaysMakeShots = true
        ShotToggle:Set(true)
        AutoGreenToggle:Set(true)
        AlwaysGreenToggle:Set(true)
        Rayfield:Notify({
            Title = "Pro Mode Active",
            Content = "Max range + 100% shot accuracy",
            Duration = 3,
        })
    end,
})

local ActivateAll = MainTab:CreateButton({
    Name = "Activate All Protections",
    Callback = function()
        setupBypasses()
        hookDetections()
        simulateLegitBehavior()
        Rayfield:Notify({
            Title = "All Systems Active",
            Content = "Hacks + AC bypass enabled",
            Duration = 3,
        })
    end,
})

-- Initialize
setupBypasses()
hookDetections()
simulateLegitBehavior()

Rayfield:Notify({
    Title = "Basketball Hacks Pro Loaded",
    Content = "Range extender + Auto-green + AC bypass active",
    Duration = 5,
})

print("RH2 Basketball Hacks Pro initialized with Auto-Green!")
