getgenv().SecureMode = true

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Mobile No Pump Fake",
   LoadingTitle = "Mobile Pump Fix",
   LoadingSubtitle = "Touch Screen Optimized",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "MobilePumpFix"
   },
   KeySystem = false,
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Mobile Settings
_G.MobileRealShots = true
_G.TapToShoot = true
_G.InstantRelease = true
_G.ShotPower = 85
_G.MobileUIEnabled = false

-- Mobile UI Elements
local mobileScreenGui = nil
local shootButton = nil

-- Create Mobile Shoot Button (Bypasses RH2's button)
local function createMobileShootButton()
    if mobileScreenGui then mobileScreenGui:Destroy() end
    
    mobileScreenGui = Instance.new("ScreenGui")
    mobileScreenGui.Name = "MobileRealShootUI"
    mobileScreenGui.Parent = game.CoreGui
    mobileScreenGui.ResetOnSpawn = false
    
    -- Big Red Shoot Button (replaces RH2's button)
    shootButton = Instance.new("TextButton")
    shootButton.Size = UDim2.new(0, 120, 0, 120)
    shootButton.Position = UDim2.new(1, -140, 1, -140)
    shootButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    shootButton.Text = "REAL\nSHOOT"
    shootButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    shootButton.TextSize = 16
    shootButton.TextWrapped = true
    shootButton.ZIndex = 10
    shootButton.Parent = mobileScreenGui
    
    -- Mobile touch event for real shots
    shootButton.MouseButton1Click:Connect(function()
        triggerRealMobileShot()
    end)
    
    -- Also work with touch events
    shootButton.TouchTap:Connect(function()
        triggerRealMobileShot()
    end)
    
    _G.MobileUIEnabled = true
end

-- Real Mobile Shot Function (Bypasses pump fake completely)
local function triggerRealMobileShot()
    pcall(function()
        print("Mobile Real Shot Triggered")
        
        -- Method 1: Direct ball control
        local ball = workspace:FindFirstChild("Basketball") or workspace:FindFirstChild("Ball")
        if ball then
            local hoop = workspace:FindFirstChild("Hoop") or workspace:FindFirstChild("Basket") or workspace:FindFirstChild("Score")
            if hoop then
                -- Calculate perfect shot trajectory
                local targetPos = hoop.Position + Vector3.new(0, 4, 0) -- Aim for center of hoop
                local direction = (targetPos - ball.Position).Unit
                local distance = (targetPos - ball.Position).Magnitude
                
                -- Apply shot force (mobile optimized)
                local power = _G.ShotPower * (distance / 50)
                power = math.min(power, 120) -- Cap power
                
                ball.Velocity = direction * power
                print("Direct ball shot with power: " .. power)
            end
        end
        
        -- Method 2: Force all shoot remote events
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                -- Try all possible shoot commands
                if obj.Name:lower():find("shoot") or obj.Name:lower():find("shot") or obj.Name:lower():find("fire") then
                    obj:FireServer("shoot", _G.ShotPower, true)
                    obj:FireServer("release", _G.ShotPower, true)
                    obj:FireServer("shot", _G.ShotPower, true)
                end
            end
        end
        
        -- Method 3: Stop any pump fake animations
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                    if track.Name:lower():find("fake") or track.Name:lower():find("pump") then
                        track:Stop()
                        print("Stopped pump fake animation")
                    end
                end
            end
        end
    end)
end

-- Hook RH2's Mobile Shoot Button
local function hookRH2MobileButton()
    spawn(function()
        while _G.MobileRealShots do
            wait(0.5)
            pcall(function()
                -- Find RH2's mobile shoot button
                for _, obj in pairs(game:GetDescendants()) do
                    if obj:IsA("TextButton") or obj:IsA("ImageButton") then
                        if obj.Text:lower():find("shoot") or obj.Name:lower():find("shoot") or obj.Name:lower():find("shot") then
                            -- Replace RH2's button function with real shot
                            local oldActivate = obj.Activate
                            if not obj.__hooked then
                                obj.__hooked = true
                                obj.Activate = function(...)
                                    print("RH2 Shoot Button Pressed - Converting to Real Shot")
                                    triggerRealMobileShot()
                                    return oldActivate(...)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
end

-- Mobile Touch Detection (for any screen taps)
local function setupMobileTouchDetection()
    UserInputService.TouchStarted:Connect(function(touch, gameProcessed)
        if gameProcessed then return end
        
        -- Check if tap is near where shoot button would be (bottom right)
        local viewportSize = workspace.CurrentCamera.ViewportSize
        local tapPosition = touch.Position
        
        -- If tap is in bottom right quadrant (where shoot buttons usually are)
        if tapPosition.X > viewportSize.X * 0.6 and tapPosition.Y > viewportSize.Y * 0.6 then
            if _G.TapToShoot then
                wait(0.1) -- Small delay
                triggerRealMobileShot()
            end
        end
    end)
end

-- Auto-Release for Mobile (Prevents holding too long)
local function setupMobileAutoRelease()
    spawn(function()
        while _G.InstantRelease do
            wait(0.1)
            pcall(function()
                -- Detect if player is in shooting state and force release
                local character = LocalPlayer.Character
                if character then
                    local humanoid = character:FindFirstChild("Humanoid")
                    if humanoid then
                        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                            if track.Name:lower():find("shoot") or track.Name:lower():find("hold") then
                                -- Force shot release
                                for _, obj in pairs(game:GetDescendants()) do
                                    if obj:IsA("RemoteEvent") and obj.Name:lower():find("release") then
                                        obj:FireServer("release", _G.ShotPower, true)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
end

-- Direct Ball Control for Mobile
local function setupMobileBallControl()
    spawn(function()
        while _G.MobileRealShots do
            wait(0.2)
            pcall(function()
                local ball = workspace:FindFirstChild("Basketball") or workspace:FindFirstChild("Ball")
                local character = LocalPlayer.Character
                
                if ball and character then
                    local root = character:FindFirstChild("HumanoidRootPart")
                    local hoop = workspace:FindFirstChild("Hoop") or workspace:FindFirstChild("Basket")
                    
                    if root and hoop then
                        -- Auto-shoot when ball is close to player and facing hoop
                        local ballDistance = (ball.Position - root.Position).Magnitude
                        local directionToHoop = (hoop.Position - root.Position).Unit
                        local characterDirection = root.CFrame.LookVector
                        
                        if ballDistance < 8 and directionToHoop:Dot(characterDirection) > 0.5 then
                            -- Small chance to auto-shoot for convenience
                            if math.random(1, 20) == 1 then
                                triggerRealMobileShot()
                            end
                        end
                    end
                end
            end)
        end
    end)
end

-- Rayfield UI
local MainTab = Window:CreateTab("Mobile Pump Fix", nil)
local MobileSection = MainTab:CreateSection("Mobile Settings")

local MobileRealToggle = MainTab:CreateToggle({
    Name = "Mobile Real Shots",
    CurrentValue = true,
    Flag = "MobileRealShots",
    Callback = function(Value)
        _G.MobileRealShots = Value
        if Value then
            hookRH2MobileButton()
            setupMobileBallControl()
            Rayfield:Notify({
                Title = "Mobile Real Shots",
                Content = "All mobile shots will be real",
                Duration = 3,
            })
        end
    end,
})

local TapShootToggle = MainTab:CreateToggle({
    Name = "Tap to Shoot",
    CurrentValue = true,
    Flag = "TapToShoot",
    Callback = function(Value)
        _G.TapToShoot = Value
        if Value then
            setupMobileTouchDetection()
            Rayfield:Notify({
                Title = "Tap to Shoot",
                Content = "Screen taps trigger real shots",
                Duration = 3,
            })
        end
    end,
})

local InstantReleaseToggle = MainTab:CreateToggle({
    Name = "Instant Release",
    CurrentValue = true,
    Flag = "InstantRelease",
    Callback = function(Value)
        _G.InstantRelease = Value
        if Value then
            setupMobileAutoRelease()
            Rayfield:Notify({
                Title = "Instant Release",
                Content = "No more shot holding",
                Duration = 3,
            })
        end
    end,
})

local PowerSlider = MainTab:CreateSlider({
    Name = "Mobile Shot Power",
    Range = {50, 120},
    Increment = 5,
    Suffix = "power",
    CurrentValue = 85,
    Flag = "ShotPower",
    Callback = function(Value)
        _G.ShotPower = Value
    end,
})

-- Quick Actions
local ActionsSection = MainTab:CreateSection("Mobile Quick Actions")

local CreateShootButton = MainTab:CreateButton({
    Name = "Create Mobile Shoot Button",
    Callback = function()
        createMobileShootButton()
        Rayfield:Notify({
            Title = "Mobile Button Created",
            Content = "Use the red REAL SHOOT button",
            Duration = 3,
        })
    end,
})

local TestRealShot = MainTab:CreateButton({
    Name = "Test Real Shot Now",
    Callback = function()
        triggerRealMobileShot()
        Rayfield:Notify({
            Title = "Real Shot Test",
            Content = "Sent real shot command",
            Duration = 2,
        })
    end,
})

-- Initialize for Mobile
if UserInputService.TouchEnabled then
    createMobileShootButton()
    hookRH2MobileButton()
    setupMobileTouchDetection()
    setupMobileAutoRelease()
    setupMobileBallControl()
    
    Rayfield:Notify({
        Title = "Mobile Pump Fix Loaded",
        Content = "Use the red REAL SHOOT button",
        Duration = 5,
    })
else
    Rayfield:Notify({
        Title = "Desktop Mode",
        Content = "Mobile features not available",
        Duration = 3,
    })
end

print("Mobile No Pump Fake system loaded!")
