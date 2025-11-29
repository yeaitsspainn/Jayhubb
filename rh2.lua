getgenv().SecureMode = true

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "RH2 Auto-Shoot + Auto-Green",
   LoadingTitle = "Auto Basketball Pro",
   LoadingSubtitle = "Auto-Shoot + Auto-Green + Range",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "RH2AutoConfig"
   },
   KeySystem = false,
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Settings
_G.AutoShoot = false
_G.AutoGreen = true
_G.ShotDelay = 0.1
_G.ExtendShotRange = false
_G.ShotRangeMultiplier = 2.0
_G.AlwaysMakeShots = true

-- Anti-Cheat Bypass
_G.HideScripts = true
_G.SpoofMemory = true
_G.AntiKick = true

-- Auto-Shoot System
local function setupAutoShoot()
    spawn(function()
        while _G.AutoShoot do
            wait(_G.ShotDelay)
            pcall(function()
                -- Find and trigger shoot buttons/remotes automatically
                for _, obj in pairs(game:GetDescendants()) do
                    if obj:IsA("TextButton") and (obj.Text:lower():find("shoot") or obj.Text:lower():find("shot") or obj.Name:lower():find("shoot")) then
                        -- Auto-click shoot buttons
                        if obj.Visible then
                            obj:FireEvent("MouseButton1Click")
                        end
                    end
                    
                    if obj:IsA("RemoteEvent") and (obj.Name:lower():find("shoot") or obj.Name:lower():find("shot")) then
                        -- Auto-fire shoot remotes
                        obj:FireServer("shoot", LocalPlayer)
                    end
                end
                
                -- Also check for touch events (mobile)
                for _, obj in pairs(game:GetDescendants()) do
                    if obj:IsA("Part") and obj.Name:lower():find("shoot") then
                        -- Trigger touch events
                        firetouchinterest(obj, LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), 0)
                        wait()
                        firetouchinterest(obj, LocalPlayer.Character:FindFirstChild("HumanoidRootPart"), 1)
                    end
                end
            end)
        end
    end)
end

-- Detect when player tries to shoot and auto-complete
local function setupShootDetection()
    -- Hook keyboard input
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if _G.AutoShoot and (input.KeyCode == Enum.KeyCode.E or input.KeyCode == Enum.KeyCode.F or input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA) then
            -- Player pressed a potential shoot key - enhance their shot
            pcall(function()
                if _G.AutoGreen then
                    -- Force perfect shot
                    for _, obj in pairs(game:GetDescendants()) do
                        if obj:IsA("RemoteEvent") and (obj.Name:lower():find("shoot") or obj.Name:lower():find("shot")) then
                            local oldFireServer = obj.FireServer
                            if not obj.__autoHooked then
                                obj.__autoHooked = true
                                obj.FireServer = function(self, ...)
                                    local args = {...}
                                    -- Modify for perfect shot
                                    for i, arg in pairs(args) do
                                        if type(arg) == "boolean" then
                                            args[i] = true -- Force success
                                        elseif type(arg) == "number" then
                                            -- Perfect timing/accuracy
                                            if arg < 100 then
                                                args[i] = 100
                                            end
                                        elseif type(arg) == "string" and arg:find("miss") then
                                            args[i] = "make" -- Change miss to make
                                        end
                                    end
                                    
                                    -- Add range extension if enabled
                                    if _G.ExtendShotRange then
                                        for i, arg in pairs(args) do
                                            if type(arg) == "number" and arg < 100 then
                                                args[i] = arg * _G.ShotRangeMultiplier
                                            end
                                        end
                                    end
                                    
                                    return oldFireServer(self, unpack(args))
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
    
    -- Hook mobile touch events
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("TextButton") and (obj.Text:lower():find("shoot") or obj.Name:lower():find("shoot")) then
            local oldActivate = obj.Activate
            obj.Activate = function(...)
                if _G.AutoShoot and _G.AutoGreen then
                    -- Enhance the shot when button is pressed
                    pcall(function()
                        -- Force perfect shot parameters
                        for _, remote in pairs(game:GetDescendants()) do
                            if remote:IsA("RemoteEvent") and remote.Name:lower():find("shoot") then
                                remote:FireServer("perfect_shot", 100, true, LocalPlayer)
                            end
                        end
                    end)
                end
                return oldActivate(...)
            end
        end
    end
end

-- Auto-Green System
local function activateAutoGreen()
    spawn(function()
        while _G.AutoGreen or _G.AlwaysMakeShots do
            wait(0.1)
            pcall(function()
                -- Hook all shot-related remotes for auto-success
                for _, obj in pairs(game:GetDescendants()) do
                    if obj:IsA("RemoteEvent") and (obj.Name:lower():find("shot") or obj.Name:lower():find("score") or obj.Name:lower():find("make") or obj.Name:lower():find("basket")) then
                        local oldFireServer = obj.FireServer
                        if not obj.__greenHooked then
                            obj.__greenHooked = true
                            obj.FireServer = function(self, ...)
                                local args = {...}
                                
                                -- Force shot success
                                if _G.AutoGreen or _G.AlwaysMakeShots then
                                    for i, arg in pairs(args) do
                                        if type(arg) == "boolean" then
                                            args[i] = true -- Force success
                                        elseif type(arg) == "number" then
                                            -- Perfect timing/accuracy (100%)
                                            if arg < 100 then
                                                args[i] = 100
                                            end
                                        elseif type(arg) == "string" then
                                            -- Replace miss with make
                                            if arg:lower():find("miss") or arg:lower():find("fail") then
                                                args[i] = "make"
                                            end
                                        end
                                    end
                                end
                                
                                return oldFireServer(self, unpack(args))
                            end
                        end
                    end
                end
                
                -- Modify basketball to always go in
                local ball = workspace:FindFirstChild("Basketball") or workspace:FindFirstChild("Ball")
                if ball and (_G.AutoGreen or _G.AlwaysMakeShots) then
                    local hoop = workspace:FindFirstChild("Hoop") or workspace:FindFirstChild("Basket") or workspace:FindFirstChild("Score")
                    if hoop then
                        -- Make ball magnetize towards hoop
                        local direction = (hoop.Position - ball.Position).Unit
                        local distance = (hoop.Position - ball.Position).Magnitude
                        
                        if distance < 50 then -- Only when ball is somewhat close
                            ball.Velocity = ball.Velocity + direction * 10
                        end
                    end
                end
            end)
        end
    end)
end

-- Range Extension
local function extendRanges()
    spawn(function()
        while _G.ExtendShotRange do
            wait(0.2)
            pcall(function()
                for _, obj in pairs(game:GetDescendants()) do
                    if obj:IsA("RemoteEvent") and (obj.Name:lower():find("shoot") or obj.Name:lower():find("shot")) then
                        local oldFireServer = obj.FireServer
                        if not obj.__rangeHooked then
                            obj.__rangeHooked = true
                            obj.FireServer = function(self, ...)
                                local args = {...}
                                if _G.ExtendShotRange then
                                    for i, arg in pairs(args) do
                                        if type(arg) == "number" and arg < 1000 then
                                            args[i] = arg * _G.ShotRangeMultiplier
                                        end
                                    end
                                end
                                return oldFireServer(self, unpack(args))
                            end
                        end
                    end
                end
            end)
        end
    end)
end

-- Anti-Cheat Bypass
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
end

-- Rayfield UI
local MainTab = Window:CreateTab("Auto Basketball", nil)

-- Auto-Shoot Section
local AutoShootSection = MainTab:CreateSection("Auto-Shoot Settings")

local AutoShootToggle = MainTab:CreateToggle({
    Name = "Auto-Shoot (Automatic Shooting)",
    CurrentValue = false,
    Flag = "AutoShoot",
    Callback = function(Value)
        _G.AutoShoot = Value
        if Value then
            setupAutoShoot()
            Rayfield:Notify({
                Title = "Auto-Shoot Active",
                Content = "Shooting automatically when possible",
                Duration = 3,
            })
        end
    end,
})

local ShotDelaySlider = MainTab:CreateSlider({
    Name = "Shot Delay",
    Range = {0.1, 2.0},
    Increment = 0.1,
    Suffix = "seconds",
    CurrentValue = 0.1,
    Flag = "ShotDelay",
    Callback = function(Value)
        _G.ShotDelay = Value
    end,
})

-- Auto-Green Section
local AutoGreenSection = MainTab:CreateSection("Auto-Green Settings")

local AutoGreenToggle = MainTab:CreateToggle({
    Name = "Auto-Green (Always Make Shots)",
    CurrentValue = true,
    Flag = "AutoGreen",
    Callback = function(Value)
        _G.AutoGreen = Value
        if Value then
            activateAutoGreen()
            Rayfield:Notify({
                Title = "Auto-Green Active",
                Content = "Every shot will be perfect",
                Duration = 3,
            })
        end
    end,
})

local AlwaysGreenToggle = MainTab:CreateToggle({
    Name = "Always Make Shots (Forced)",
    CurrentValue = true,
    Flag = "AlwaysMakeShots",
    Callback = function(Value)
        _G.AlwaysMakeShots = Value
        if Value then
            activateAutoGreen()
            Rayfield:Notify({
                Title = "Forced Green Active",
                Content = "100% shot success guaranteed",
                Duration = 3,
            })
        end
    end,
})

-- Range Section
local RangeSection = MainTab:CreateSection("Range Settings")

local RangeToggle = MainTab:CreateToggle({
    Name = "Extend Shot Range",
    CurrentValue = false,
    Flag = "ExtendShotRange",
    Callback = function(Value)
        _G.ExtendShotRange = Value
        if Value then
            extendRanges()
            Rayfield:Notify({
                Title = "Range Extended",
                Content = "Shooting range increased",
                Duration = 3,
            })
        end
    end,
})

local RangeMultiplier = MainTab:CreateSlider({
    Name = "Range Multiplier",
    Range = {1.0, 5.0},
    Increment = 0.5,
    Suffix = "x",
    CurrentValue = 2.0,
    Flag = "ShotRangeMultiplier",
    Callback = function(Value)
        _G.ShotRangeMultiplier = Value
    end,
})

-- Quick Actions
local ActionsSection = MainTab:CreateSection("Quick Actions")

local GodMode = MainTab:CreateButton({
    Name = "Activate God Mode",
    Callback = function()
        _G.AutoShoot = true
        _G.AutoGreen = true
        _G.AlwaysMakeShots = true
        _G.ExtendShotRange = true
        AutoShootToggle:Set(true)
        AutoGreenToggle:Set(true)
        AlwaysGreenToggle:Set(true)
        RangeToggle:Set(true)
        setupAutoShoot()
        activateAutoGreen()
        extendRanges()
        Rayfield:Notify({
            Title = "God Mode Active",
            Content = "Auto-shoot + Auto-green + Max range",
            Duration = 3,
        })
    end,
})

local AutoOnly = MainTab:CreateButton({
    Name = "Auto-Shoot Only",
    Callback = function()
        _G.AutoShoot = true
        _G.AutoGreen = true
        AutoShootToggle:Set(true)
        AutoGreenToggle:Set(true)
        setupAutoShoot()
        activateAutoGreen()
        Rayfield:Notify({
            Title = "Auto-Shoot Only",
            Content = "Auto-shooting with perfect accuracy",
            Duration = 3,
        })
    end,
})

-- Initialize systems
setupBypasses()
setupShootDetection()
activateAutoGreen()

Rayfield:Notify({
    Title = "Auto Basketball Pro Loaded",
    Content = "Auto-shoot + Auto-green ready!",
    Duration = 5,
})

print("Auto Basketball Pro initialized!")
print("Features: Auto-shoot, Auto-green, Range extension")
