getgenv().SecureMode = true

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Hoop Life Pro",
   LoadingTitle = "Auto Green + Dribble",
   LoadingSubtitle = "Basketball Enhancement",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "HoopLifeConfig"
   },
   KeySystem = false,
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Hoop Life Settings
_G.AutoGreen = false
_G.GreenPercentage = 100
_G.DribbleModifier = false
_G.DribbleSpeed = 2.0
_G.PerfectRelease = false
_G.ShotAssist = false
_G.BallControl = false

-- Find Basketball
local function findBasketball()
    local ball = Workspace:FindFirstChild("Basketball") or Workspace:FindFirstChild("Ball")
    if not ball then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name:lower():find("basketball") or obj.Name:lower():find("ball") then
                if obj:IsA("Part") or obj:IsA("MeshPart") then
                    return obj
                end
            end
        end
    end
    return ball
end

-- Find Hoop
local function findHoop()
    local hoop = Workspace:FindFirstChild("Hoop") or Workspace:FindFirstChild("Basket")
    if not hoop then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name:lower():find("hoop") or obj.Name:lower():find("basket") or obj.Name:lower():find("rim") then
                if obj:IsA("Part") or obj:IsA("MeshPart") then
                    return obj
                end
            end
        end
    end
    return hoop
end

-- Auto Green System (Perfect Shots)
local function activateAutoGreen()
    spawn(function()
        while _G.AutoGreen do
            wait(0.1)
            pcall(function()
                -- Hook shot success calculations
                for _, remote in pairs(game:GetDescendants()) do
                    if remote:IsA("RemoteEvent") then
                        local name = remote.Name:lower()
                        if name:find("shot") or name:find("shoot") or name:find("make") or name:find("score") then
                            local oldFire = remote.FireServer
                            if not remote.__greenHooked then
                                remote.__greenHooked = true
                                remote.FireServer = function(self, ...)
                                    local args = {...}
                                    
                                    -- Force shot success based on percentage
                                    if _G.AutoGreen and math.random(1, 100) <= _G.GreenPercentage then
                                        for i, arg in pairs(args) do
                                            if type(arg) == "boolean" then
                                                args[i] = true -- Force make
                                            elseif type(arg) == "number" then
                                                -- Perfect timing/accuracy
                                                if arg < 100 then
                                                    args[i] = 100
                                                end
                                            elseif type(arg) == "string" then
                                                -- Replace miss with make
                                                if arg:lower():find("miss") then
                                                    args[i] = "make"
                                                end
                                            end
                                        end
                                    end
                                    
                                    return oldFire(self, unpack(args))
                                end
                            end
                        end
                    end
                end
                
                -- Ball guidance system
                local ball = findBasketball()
                local hoop = findHoop()
                
                if ball and hoop and _G.AutoGreen then
                    -- Make ball magnetize to hoop when shot
                    local ballVelocity = ball.Velocity.Magnitude
                    if ballVelocity > 20 then -- Ball is moving fast (shot taken)
                        local direction = (hoop.Position - ball.Position).Unit
                        local distance = (hoop.Position - ball.Position).Magnitude
                        
                        -- Apply correction force
                        if distance < 100 then
                            local correctionForce = direction * 8
                            ball.Velocity = ball.Velocity + correctionForce
                        end
                    end
                end
            end)
        end
    end)
end

-- Dribble Modifier System
local function activateDribbleModifier()
    spawn(function()
        while _G.DribbleModifier do
            RunService.Heartbeat:Wait()
            pcall(function()
                local ball = findBasketball()
                local character = LocalPlayer.Character
                
                if ball and character and character:FindFirstChild("HumanoidRootPart") then
                    local root = character.HumanoidRootPart
                    local distance = (ball.Position - root.Position).Magnitude
                    
                    -- If ball is close to player (dribbling range)
                    if distance < 10 then
                        -- Method 1: Increase dribble speed
                        ball.Velocity = ball.Velocity * _G.DribbleSpeed
                        
                        -- Method 2: Better ball control
                        if _G.BallControl then
                            -- Keep ball closer to player
                            local direction = (root.Position - ball.Position).Unit
                            ball.Velocity = ball.Velocity + direction * 5
                            
                            -- Reduce ball bounce
                            if ball.Velocity.Y > 0 then
                                ball.Velocity = Vector3.new(ball.Velocity.X, ball.Velocity.Y * 0.7, ball.Velocity.Z)
                            end
                        end
                    end
                end
            end)
        end
    end)
end

-- Perfect Release System
local function activatePerfectRelease()
    spawn(function()
        while _G.PerfectRelease do
            wait(0.1)
            pcall(function()
                -- Hook release timing systems
                for _, remote in pairs(game:GetDescendants()) do
                    if remote:IsA("RemoteEvent") then
                        local name = remote.Name:lower()
                        if name:find("release") or name:find("timing") then
                            local oldFire = remote.FireServer
                            if not remote.__releaseHooked then
                                remote.__releaseHooked = true
                                remote.FireServer = function(self, ...)
                                    local args = {...}
                                    
                                    -- Force perfect release timing
                                    for i, arg in pairs(args) do
                                        if type(arg) == "number" then
                                            -- Perfect release value (usually 100)
                                            if arg < 100 then
                                                args[i] = 100
                                            end
                                        elseif type(arg) == "string" and arg:lower():find("perfect") then
                                            args[i] = "perfect"
                                        end
                                    end
                                    
                                    return oldFire(self, unpack(args))
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
end

-- Shot Assist System
local function activateShotAssist()
    spawn(function()
        while _G.ShotAssist do
            wait(0.2)
            pcall(function()
                local ball = findBasketball()
                local character = LocalPlayer.Character
                local hoop = findHoop()
                
                if ball and character and character:FindFirstChild("HumanoidRootPart") and hoop then
                    local root = character.HumanoidRootPart
                    local ballDistance = (ball.Position - root.Position).Magnitude
                    
                    -- If player has ball and is facing hoop
                    if ballDistance < 8 then
                        local directionToHoop = (hoop.Position - root.Position).Unit
                        local characterDirection = root.CFrame.LookVector
                        
                        -- Auto-align with hoop for better shots
                        if directionToHoop:Dot(characterDirection) > 0.5 then
                            root.CFrame = CFrame.new(root.Position, Vector3.new(hoop.Position.X, root.Position.Y, hoop.Position.Z))
                        end
                    end
                end
            end)
        end
    end)
end

-- Ball Control Enhancement
local function activateBallControl()
    spawn(function()
        while _G.BallControl do
            RunService.Heartbeat:Wait()
            pcall(function()
                local ball = findBasketball()
                local character = LocalPlayer.Character
                
                if ball and character and character:FindFirstChild("HumanoidRootPart") then
                    local root = character.HumanoidRootPart
                    local distance = (ball.Position - root.Position).Magnitude
                    
                    -- Magnetic ball when close
                    if distance < 15 then
                        local direction = (root.Position - ball.Position).Unit
                        local force = direction * 3
                        ball.Velocity = ball.Velocity + force
                    end
                    
                    -- Reduce ball rolling away
                    if distance < 25 then
                        local horizontalVelocity = Vector3.new(ball.Velocity.X, 0, ball.Velocity.Z)
                        if horizontalVelocity.Magnitude > 10 then
                            ball.Velocity = Vector3.new(
                                ball.Velocity.X * 0.9,
                                ball.Velocity.Y,
                                ball.Velocity.Z * 0.9
                            )
                        end
                    end
                end
            end)
        end
    end)
end

-- Auto Dunk System
local function autoDunk()
    spawn(function()
        while _G.AutoGreen do
            wait(0.3)
            pcall(function()
                local ball = findBasketball()
                local character = LocalPlayer.Character
                local hoop = findHoop()
                
                if ball and character and character:FindFirstChild("HumanoidRootPart") and hoop then
                    local root = character.HumanoidRootPart
                    local ballDistance = (ball.Position - root.Position).Magnitude
                    local hoopDistance = (hoop.Position - root.Position).Magnitude
                    
                    -- Auto-dunk when close to hoop with ball
                    if ballDistance < 6 and hoopDistance < 15 then
                        -- Trigger dunk animation/remote
                        for _, remote in pairs(game:GetDescendants()) do
                            if remote:IsA("RemoteEvent") and remote.Name:lower():find("dunk") then
                                remote:FireServer()
                            end
                        end
                        
                        -- Force ball into hoop
                        local dunkDirection = (hoop.Position - ball.Position).Unit
                        ball.Velocity = dunkDirection * 50
                    end
                end
            end)
        end
    end)
end

-- Rayfield UI
local MainTab = Window:CreateTab("Hoop Life Pro", nil)

-- Shooting Section
local ShootingSection = MainTab:CreateSection("Shooting")

local AutoGreenToggle = MainTab:CreateToggle({
    Name = "Auto Green (Perfect Shots)",
    CurrentValue = false,
    Flag = "AutoGreen",
    Callback = function(Value)
        _G.AutoGreen = Value
        if Value then
            activateAutoGreen()
            autoDunk()
            Rayfield:Notify({
                Title = "Auto Green Active",
                Content = _G.GreenPercentage .. "% shot success",
                Duration = 3,
            })
        end
    end,
})

local GreenSlider = MainTab:CreateSlider({
    Name = "Green Percentage",
    Range = {50, 100},
    Increment = 5,
    Suffix = "%",
    CurrentValue = 100,
    Flag = "GreenPercentage",
    Callback = function(Value)
        _G.GreenPercentage = Value
    end,
})

local ReleaseToggle = MainTab:CreateToggle({
    Name = "Perfect Release",
    CurrentValue = false,
    Flag = "PerfectRelease",
    Callback = function(Value)
        _G.PerfectRelease = Value
        if Value then
            activatePerfectRelease()
            Rayfield:Notify({
                Title = "Perfect Release Active",
                Content = "Always perfect shot timing",
                Duration = 3,
            })
        end
    end,
})

local AssistToggle = MainTab:CreateToggle({
    Name = "Shot Assist",
    CurrentValue = false,
    Flag = "ShotAssist",
    Callback = function(Value)
        _G.ShotAssist = Value
        if Value then
            activateShotAssist()
            Rayfield:Notify({
                Title = "Shot Assist Active",
                Content = "Auto-aim assistance",
                Duration = 3,
            })
        end
    end,
})

-- Dribble Section
local DribbleSection = MainTab:CreateSection("Dribble & Control")

local DribbleToggle = MainTab:CreateToggle({
    Name = "Dribble Modifier",
    CurrentValue = false,
    Flag = "DribbleModifier",
    Callback = function(Value)
        _G.DribbleModifier = Value
        if Value then
            activateDribbleModifier()
            Rayfield:Notify({
                Title = "Dribble Modifier Active",
                Content = "Enhanced dribble speed",
                Duration = 3,
            })
        end
    end,
})

local DribbleSlider = MainTab:CreateSlider({
    Name = "Dribble Speed",
    Range = {1.0, 3.0},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = 2.0,
    Flag = "DribbleSpeed",
    Callback = function(Value)
        _G.DribbleSpeed = Value
    end,
})

local ControlToggle = MainTab:CreateToggle({
    Name = "Ball Control",
    CurrentValue = false,
    Flag = "BallControl",
    Callback = function(Value)
        _G.BallControl = Value
        if Value then
            activateBallControl()
            Rayfield:Notify({
                Title = "Ball Control Active",
                Content = "Magnetic ball handling",
                Duration = 3,
            })
        end
    end,
})

-- Quick Actions
local ActionsSection = MainTab:CreateSection("Quick Actions")

local ProMode = MainTab:CreateButton({
    Name = "Activate Pro Mode",
    Callback = function()
        _G.AutoGreen = true
        _G.DribbleModifier = true
        _G.PerfectRelease = true
        _G.ShotAssist = true
        _G.BallControl = true
        AutoGreenToggle:Set(true)
        DribbleToggle:Set(true)
        ReleaseToggle:Set(true)
        AssistToggle:Set(true)
        ControlToggle:Set(true)
        activateAutoGreen()
        activateDribbleModifier()
        activatePerfectRelease()
        activateShotAssist()
        activateBallControl()
        autoDunk()
        Rayfield:Notify({
            Title = "Pro Mode Activated",
            Content = "All basketball enhancements enabled",
            Duration = 4,
        })
    end,
})

-- Status
local StatusSection = MainTab:CreateSection("Status")
local BallStatus = MainTab:CreateLabel("Basketball: Searching...")

-- Update ball status
spawn(function()
    while true do
        wait(2)
        local ball = findBasketball()
        local hoop = findHoop()
        
        if ball then
            local distance = 999
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                distance = (ball.Position - character.HumanoidRootPart.Position).Magnitude
            end
            
            local status = "Ball: " .. math.floor(distance) .. " studs"
            if hoop then
                status = status .. " | Hoop: Found"
            else
                status = status .. " | Hoop: Searching"
            end
            
            BallStatus:Set(status)
        else
            BallStatus:Set("Basketball: Not found")
        end
    end
end)

Rayfield:Notify({
    Title = "Hoop Life Pro Loaded",
    Content = "Auto green + dribble mods ready",
    Duration = 5,
})

print("🏀 Hoop Life Pro - Basketball Enhancement System Ready!")
