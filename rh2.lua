getgenv().SecureMode = true

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Mobile MyCourt Hacks",
   LoadingTitle = "Mobile Basketball",
   LoadingSubtitle = "Touch Screen Optimized",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "MobileCourtConfig"
   },
   KeySystem = false,
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local LocalPlayer = Players.LocalPlayer

-- Settings
_G.AutoShoot = false
_G.AutoGreen = true
_G.ShotDelay = 0.3
_G.ExtendShotRange = false
_G.ShotRangeMultiplier = 2.0
_G.AlwaysMakeShots = true
_G.MobileUIEnabled = false

-- Mobile UI Elements
local mobileScreenGui = nil
local mobileFrame = nil
local touchButtons = {}

-- Detect if mobile
local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.MouseEnabled
end

-- Create Mobile Touch UI
local function createMobileUI()
    if mobileScreenGui then mobileScreenGui:Destroy() end
    
    mobileScreenGui = Instance.new("ScreenGui")
    mobileScreenGui.Name = "MobileBasketballUI"
    mobileScreenGui.Parent = game.CoreGui
    mobileScreenGui.ResetOnSpawn = false
    
    -- Main Control Panel
    local controlFrame = Instance.new("Frame")
    controlFrame.Size = UDim2.new(0, 200, 0, 250)
    controlFrame.Position = UDim2.new(0, 10, 0.5, -125)
    controlFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    controlFrame.BackgroundTransparency = 0.3
    controlFrame.BorderSizePixel = 0
    controlFrame.Parent = mobileScreenGui
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    title.Text = "Mobile Controls"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 14
    title.Parent = controlFrame
    
    -- Toggle UI Button
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(1, -10, 0, 25)
    toggleBtn.Position = UDim2.new(0, 5, 0, 35)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleBtn.Text = "Hide Panel"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 12
    toggleBtn.Parent = controlFrame
    
    toggleBtn.MouseButton1Click:Connect(function()
        controlFrame.Visible = not controlFrame.Visible
        toggleBtn.Text = controlFrame.Visible and "Hide Panel" or "Show Panel"
    end)
    
    -- Mobile Control Buttons
    local mobileButtons = {
        {"Auto-Shoot", function()
            _G.AutoShoot = not _G.AutoShoot
            if _G.AutoShoot then
                setupMobileAutoShoot()
            end
            updateMobileUI()
        end},
        {"Auto-Green", function()
            _G.AutoGreen = not _G.AutoGreen
            if _G.AutoGreen then
                setupMobileAutoGreen()
            end
            updateMobileUI()
        end},
        {"Extend Range", function()
            _G.ExtendShotRange = not _G.ExtendShotRange
            if _G.ExtendShotRange then
                setupMobileRange()
            end
            updateMobileUI()
        end},
        {"Quick Shoot", quickMobileShot},
        {"God Mode", activateMobileGodMode}
    }
    
    for i, btnData in ipairs(mobileButtons) do
        local btnName, btnFunc = btnData[1], btnData[2]
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -10, 0, 30)
        button.Position = UDim2.new(0, 5, 0, 65 + (i * 35))
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        button.Text = btnName
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 12
        button.Parent = controlFrame
        button.MouseButton1Click = btnFunc
        
        touchButtons[btnName] = button
    end
    
    -- Status Display
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -10, 0, 20)
    statusLabel.Position = UDim2.new(0, 5, 0, 240)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Ready for MyCourt"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    statusLabel.TextSize = 11
    statusLabel.Parent = controlFrame
    touchButtons["Status"] = statusLabel
    
    _G.MobileUIEnabled = true
    updateMobileUI()
end

-- Update Mobile UI Colors
local function updateMobileUI()
    if not touchButtons then return end
    
    local statusMap = {
        ["Auto-Shoot"] = _G.AutoShoot,
        ["Auto-Green"] = _G.AutoGreen,
        ["Extend Range"] = _G.ExtendShotRange
    }
    
    for btnName, button in pairs(touchButtons) do
        if statusMap[btnName] ~= nil then
            if statusMap[btnName] then
                button.BackgroundColor3 = Color3.fromRGB(0, 150, 0) -- Green when active
            else
                button.BackgroundColor3 = Color3.fromRGB(70, 70, 70) -- Gray when inactive
            end
        end
    end
    
    if touchButtons["Status"] then
        local activeCount = (_G.AutoShoot and 1 or 0) + (_G.AutoGreen and 1 or 0) + (_G.ExtendShotRange and 1 or 0)
        touchButtons["Status"].Text = activeCount .. "/3 Features Active"
        touchButtons["Status"].TextColor3 = activeCount > 0 and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
    end
end

-- Mobile Auto-Shoot System
local function setupMobileAutoShoot()
    spawn(function()
        while _G.AutoShoot do
            wait(_G.ShotDelay)
            pcall(function()
                -- Method 1: Find and click shoot buttons (mobile UI)
                for _, obj in pairs(game:GetDescendants()) do
                    if obj:IsA("TextButton") or obj:IsA("ImageButton") then
                        if obj.Text:lower():find("shoot") or obj.Name:lower():find("shoot") or obj.Name:lower():find("shot") then
                            if obj.Visible then
                                -- Simulate mobile tap
                                obj:FireEvent("MouseButton1Click")
                                obj:FireEvent("Activated")
                            end
                        end
                    end
                end
                
                -- Method 2: Trigger touch events for mobile
                for _, obj in pairs(workspace:GetDescendants()) do
                    if obj:IsA("Part") and (obj.Name:lower():find("shoot") or obj.Name:lower():find("trigger")) then
                        local character = LocalPlayer.Character
                        if character and character:FindFirstChild("HumanoidRootPart") then
                            -- Simulate touch
                            firetouchinterest(character.HumanoidRootPart, obj, 0)
                            wait()
                            firetouchinterest(character.HumanoidRootPart, obj, 1)
                        end
                    end
                end
                
                -- Method 3: Direct ball shooting for mobile
                local ball = workspace:FindFirstChild("Basketball") or workspace:FindFirstChild("Ball")
                if ball then
                    local hoop = workspace:FindFirstChild("Hoop") or workspace:FindFirstChild("Basket")
                    if hoop then
                        -- Auto-shoot the ball
                        local direction = (hoop.Position - ball.Position).Unit
                        local power = 40
                        if _G.ExtendShotRange then
                            power = power * _G.ShotRangeMultiplier
                        end
                        ball.Velocity = direction * power
                    end
                end
            end)
        end
    end)
end

-- Mobile Auto-Green System
local function setupMobileAutoGreen()
    spawn(function()
        while _G.AutoGreen or _G.AlwaysMakeShots do
            wait(0.1)
            pcall(function()
                -- Hook all remote events for mobile
                for _, obj in pairs(game:GetDescendants()) do
                    if obj:IsA("RemoteEvent") then
                        local oldFireServer = obj.FireServer
                        if not obj.__mobileHooked then
                            obj.__mobileHooked = true
                            obj.FireServer = function(self, ...)
                                local args = {...}
                                
                                if _G.AutoGreen or _G.AlwaysMakeShots then
                                    for i, arg in pairs(args) do
                                        if type(arg) == "boolean" then
                                            args[i] = true
                                        elseif type(arg) == "number" and arg < 100 then
                                            args[i] = 100
                                        end
                                    end
                                end
                                
                                return oldFireServer(self, unpack(args))
                            end
                        end
                    end
                end
                
                -- Mobile ball guidance
                local ball = workspace:FindFirstChild("Basketball") or workspace:FindFirstChild("Ball")
                if ball and (_G.AutoGreen or _G.AlwaysMakeShots) then
                    local hoop = workspace:FindFirstChild("Hoop") or workspace:FindFirstChild("Basket")
                    if hoop then
                        -- Guide ball toward hoop (mobile-friendly)
                        local direction = (hoop.Position - ball.Position).Unit
                        local distance = (hoop.Position - ball.Position).Magnitude
                        
                        if distance < 80 then
                            ball.Velocity = ball.Velocity + direction * 8
                        end
                    end
                end
            end)
        end
    end)
end

-- Mobile Range Extension
local function setupMobileRange()
    spawn(function()
        while _G.ExtendShotRange do
            wait(0.3)
            pcall(function()
                -- Mobile character adjustments
                local character = LocalPlayer.Character
                if character then
                    local humanoid = character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.JumpPower = 50
                        humanoid.WalkSpeed = 20
                    end
                end
                
                -- Mobile ball physics
                local ball = workspace:FindFirstChild("Basketball") or workspace:FindFirstChild("Ball")
                if ball then
                    local bodyForce = ball:FindFirstChild("BodyForce") or Instance.new("BodyForce")
                    bodyForce.Force = Vector3.new(0, workspace.Gravity * -0.25, 0)
                    bodyForce.Parent = ball
                end
            end)
        end
    end)
end

-- Quick Mobile Shot (Single Tap)
local function quickMobileShot()
    pcall(function()
        local ball = workspace:FindFirstChild("Basketball") or workspace:FindFirstChild("Ball")
        if ball then
            local hoop = workspace:FindFirstChild("Hoop") or workspace:FindFirstChild("Basket")
            if hoop then
                -- Perfect shot calculation for mobile
                local targetPos = hoop.Position + Vector3.new(0, 4, 0)
                local direction = (targetPos - ball.Position).Unit
                local power = 45
                
                if _G.ExtendShotRange then
                    power = power * _G.ShotRangeMultiplier
                end
                
                ball.Velocity = direction * power
                
                if touchButtons["Status"] then
                    touchButtons["Status"].Text = "Quick Shot Fired!"
                    wait(2)
                    updateMobileUI()
                end
            end
        end
    end)
end

-- Mobile God Mode
local function activateMobileGodMode()
    _G.AutoShoot = true
    _G.AutoGreen = true
    _G.ExtendShotRange = true
    _G.AlwaysMakeShots = true
    
    setupMobileAutoShoot()
    setupMobileAutoGreen()
    setupMobileRange()
    
    updateMobileUI()
    
    if touchButtons["Status"] then
        touchButtons["Status"].Text = "GOD MODE ACTIVATED!"
        touchButtons["Status"].TextColor3 = Color3.fromRGB(255, 215, 0)
    end
end

-- Mobile Touch Detection
local function setupMobileTouchDetection()
    -- Detect screen touches that might be shoot attempts
    UserInputService.TouchStarted:Connect(function(touch, gameProcessed)
        if gameProcessed then return end
        
        -- If auto-green is on, enhance any potential shot
        if _G.AutoGreen then
            pcall(function()
                local ball = workspace:FindFirstChild("Basketball") or workspace:FindFirstChild("Ball")
                if ball then
                    local hoop = workspace:FindFirstChild("Hoop") or workspace:FindFirstChild("Basket")
                    if hoop then
                        -- Perfect the shot
                        local direction = (hoop.Position - ball.Position).Unit
                        ball.Velocity = direction * 35
                    end
                end
            end)
        end
    end)
end

-- Rayfield UI (for desktop users who might see this)
local MainTab = Window:CreateTab("Mobile Hacks", nil)
local MobileSection = MainTab:CreateSection("Mobile Controls")

local MobileStatus = MainTab:CreateLabel("Device: Detecting...")

local AutoShootToggle = MainTab:CreateToggle({
    Name = "Auto-Shoot (Mobile)",
    CurrentValue = false,
    Flag = "AutoShoot",
    Callback = function(Value)
        _G.AutoShoot = Value
        if Value then
            setupMobileAutoShoot()
        end
        updateMobileUI()
    end,
})

local AutoGreenToggle = MainTab:CreateToggle({
    Name = "Auto-Green (Mobile)",
    CurrentValue = true,
    Flag = "AutoGreen",
    Callback = function(Value)
        _G.AutoGreen = Value
        if Value then
            setupMobileAutoGreen()
        end
        updateMobileUI()
    end,
})

local RangeToggle = MainTab:CreateToggle({
    Name = "Extend Range (Mobile)",
    CurrentValue = false,
    Flag = "ExtendShotRange",
    Callback = function(Value)
        _G.ExtendShotRange = Value
        if Value then
            setupMobileRange()
        end
        updateMobileUI()
    end,
})

-- Initialize based on device
spawn(function()
    wait(2)
    if isMobile() then
        MobileStatus:Set("Device: Mobile ✓ Touch UI Created")
        createMobileUI()
        setupMobileTouchDetection()
        Rayfield:Notify({
            Title = "Mobile Mode Activated",
            Content = "Touch controls enabled for MyCourt",
            Duration = 5,
        })
    else
        MobileStatus:Set("Device: Desktop - Using Standard UI")
        Rayfield:Notify({
            Title = "Desktop Mode",
            Content = "Using standard interface",
            Duration = 3,
        })
    end
    
    -- Start auto-green by default
    setupMobileAutoGreen()
end)

Rayfield:Notify({
    Title = "Mobile Basketball Hacks",
    Content = "Optimized for touch screen",
    Duration = 5,
})

print("Mobile Basketball Hacks initialized!")
