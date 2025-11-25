-- Load necessary libraries and services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- UI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NamelessHubUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Mobile Toggle Button (Always visible on mobile)
local MobileToggleButton = Instance.new("TextButton")
MobileToggleButton.Name = "MobileToggleButton"
MobileToggleButton.Size = UDim2.new(0, 80, 0, 40)
MobileToggleButton.Position = UDim2.new(0, 10, 0, 10)
MobileToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
MobileToggleButton.Text = "OPEN"
MobileToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MobileToggleButton.TextSize = 14
MobileToggleButton.Font = Enum.Font.GothamBold
MobileToggleButton.Visible = false
MobileToggleButton.Parent = ScreenGui

local MobileToggleCorner = Instance.new("UICorner")
MobileToggleCorner.CornerRadius = UDim.new(0, 8)
MobileToggleCorner.Parent = MobileToggleButton

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 400)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- UI Corner
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 8)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "NAMELESS HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Name = "Subtitle"
Subtitle.Size = UDim2.new(1, 0, 0, 15)
Subtitle.Position = UDim2.new(0, 0, 1, -5)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Made by Haxzo"
Subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
Subtitle.TextScaled = true
Subtitle.Font = Enum.Font.Gotham
Subtitle.Parent = Header

-- Close Button in Header
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 80, 0, 25)
CloseButton.Position = UDim2.new(1, -85, 0, 7)
CloseButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
CloseButton.Text = "CLOSE"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 12
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -120)
ContentFrame.Position = UDim2.new(0, 10, 0, 60)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Toggle Buttons
local SilentAimToggle = Instance.new("TextButton")
SilentAimToggle.Name = "SilentAimToggle"
SilentAimToggle.Size = UDim2.new(1, 0, 0, 35)
SilentAimToggle.Position = UDim2.new(0, 0, 0, 10)
SilentAimToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
SilentAimToggle.Text = "Silent Aim: OFF"
SilentAimToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
SilentAimToggle.Font = Enum.Font.Gotham
SilentAimToggle.TextSize = 14
SilentAimToggle.Parent = ContentFrame

local ESPToggle = Instance.new("TextButton")
ESPToggle.Name = "ESPToggle"
ESPToggle.Size = UDim2.new(1, 0, 0, 35)
ESPToggle.Position = UDim2.new(0, 0, 0, 55)
ESPToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
ESPToggle.Text = "ESP: OFF"
ESPToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
ESPToggle.Font = Enum.Font.Gotham
ESPToggle.TextSize = 14
ESPToggle.Parent = ContentFrame

-- FOV Slider
local FOVLabel = Instance.new("TextLabel")
FOVLabel.Name = "FOVLabel"
FOVLabel.Size = UDim2.new(1, 0, 0, 20)
FOVLabel.Position = UDim2.new(0, 0, 0, 100)
FOVLabel.BackgroundTransparency = 1
FOVLabel.Text = "Aim FOV: 100"
FOVLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVLabel.TextScaled = true
FOVLabel.Font = Enum.Font.Gotham
FOVLabel.Parent = ContentFrame

local FOVSlider = Instance.new("TextButton")
FOVSlider.Name = "FOVSlider"
FOVSlider.Size = UDim2.new(1, 0, 0, 25)
FOVSlider.Position = UDim2.new(0, 0, 0, 125)
FOVSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
FOVSlider.Text = ""
FOVSlider.AutoButtonColor = false
FOVSlider.Parent = ContentFrame

local FOVFill = Instance.new("Frame")
FOVFill.Name = "FOVFill"
FOVFill.Size = UDim2.new(0.5, 0, 1, 0)
FOVFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
FOVFill.BorderSizePixel = 0
FOVFill.Parent = FOVSlider

local FOVValue = Instance.new("TextLabel")
FOVValue.Name = "FOVValue"
FOVValue.Size = UDim2.new(1, 0, 1, 0)
FOVValue.BackgroundTransparency = 1
FOVValue.Text = "100"
FOVValue.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVValue.TextSize = 14
FOVValue.Font = Enum.Font.GothamBold
FOVValue.Parent = FOVSlider

-- Style buttons
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = SilentAimToggle
buttonCorner:Clone().Parent = ESPToggle
buttonCorner:Clone().Parent = FOVSlider

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 6)
fillCorner.Parent = FOVFill

-- Snowflake Animation System
local Snowflakes = {}
local function createSnowflake()
    local Snowflake = Instance.new("Frame")
    Snowflake.Name = "Snowflake"
    Snowflake.Size = UDim2.new(0, 4, 0, 4)
    Snowflake.BackgroundColor3 = Color3.fromRGB(200, 220, 255)
    Snowflake.BorderSizePixel = 0
    Snowflake.Parent = MainFrame
    
    local SnowflakeCorner = Instance.new("UICorner")
    SnowflakeCorner.CornerRadius = UDim.new(1, 0)
    SnowflakeCorner.Parent = Snowflake
    
    local startPos = UDim2.new(
        math.random() * 0.9 + 0.05,
        0,
        -0.1,
        0
    )
    
    Snowflake.Position = startPos
    
    local tweenInfo = TweenInfo.new(
        math.random(5, 10),
        Enum.EasingStyle.Linear
    )
    
    local goal = {
        Position = UDim2.new(
            startPos.X.Scale + (math.random() - 0.5) * 0.3,
            0,
            1.1,
            0
        )
    }
    
    local tween = TweenService:Create(Snowflake, tweenInfo, goal)
    tween:Play()
    
    table.insert(Snowflakes, Snowflake)
    
    tween.Completed:Connect(function()
        Snowflake:Destroy()
        for i, flake in pairs(Snowflakes) do
            if flake == Snowflake then
                table.remove(Snowflakes, i)
                break
            end
        end
    end)
end

-- Create snowflakes periodically
spawn(function()
    while ScreenGui.Parent do
        if #Snowflakes < 15 then
            createSnowflake()
        end
        wait(0.3)
    end
end)

-- Mobile detection
local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.MouseEnabled
end

-- UI Visibility Management
local function setUIVisibility(visible)
    MainFrame.Visible = visible
    if isMobile() then
        if visible then
            MobileToggleButton.Text = "CLOSE"
            MobileToggleButton.Position = UDim2.new(0, 10, 0, 10)
        else
            MobileToggleButton.Text = "OPEN"
            MobileToggleButton.Position = UDim2.new(0, 10, 0, 10)
        end
    end
end

-- Show mobile toggle if on mobile
if isMobile() then
    MobileToggleButton.Visible = true
    -- Start with UI closed on mobile
    setUIVisibility(false)
else
    -- Start with UI open on PC
    setUIVisibility(true)
end

-- Mobile toggle button functionality
MobileToggleButton.MouseButton1Click:Connect(function()
    local currentlyVisible = MainFrame.Visible
    setUIVisibility(not currentlyVisible)
end)

-- Close button functionality (inside the UI)
CloseButton.MouseButton1Click:Connect(function()
    if isMobile() then
        setUIVisibility(false)
    else
        ScreenGui:Destroy()
    end
end)

-- Make UI draggable
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Header.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Your core code starts here
-- Configuration
local SilentAimEnabled = false
local ESPEnabled = false
local AimFOV = 100
local AimPartName = "Head"

-- Mobile shooting detection
local IsShooting = false
local LastTouchPosition = nil

-- Utility functions
local function GetClosestTarget()
    local closestTarget = nil
    local shortestDistance = AimFOV

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(AimPartName) and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local targetPos, onScreen = Camera:WorldToViewportPoint(player.Character[AimPartName].Position)
            if onScreen then
                local inputPos
                if isMobile() and LastTouchPosition then
                    -- Use last touch position for mobile
                    inputPos = LastTouchPosition
                else
                    -- Use mouse position for PC
                    inputPos = UserInputService:GetMouseLocation()
                end
                
                local distance = (Vector2.new(targetPos.X, targetPos.Y) - Vector2.new(inputPos.X, inputPos.Y)).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestTarget = player
                end
            end
        end
    end

    return closestTarget
end

-- Mobile touch input handling for shooting
if isMobile() then
    -- Track touch positions for mobile aiming
    UserInputService.TouchStarted:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        LastTouchPosition = input.Position
    end)
    
    UserInputService.TouchMoved:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        LastTouchPosition = input.Position
    end)
    
    -- Detect mobile shooting (long press or specific gesture)
    local shootConnection
    UserInputService.TouchStarted:Connect(function(input, gameProcessed)
        if gameProcessed or not SilentAimEnabled then return end
        
        -- Start tracking for shoot detection (long press)
        local touchTime = tick()
        local touchPosition = input.Position
        LastTouchPosition = touchPosition
        
        shootConnection = RunService.Heartbeat:Connect(function()
            -- If touch is held for more than 0.1 seconds, consider it shooting
            if tick() - touchTime > 0.1 and not IsShooting then
                IsShooting = true
                -- Trigger silent aim for mobile
                local target = GetClosestTarget()
                if target and target.Character and target.Character:FindFirstChild(AimPartName) then
                    -- Mobile shooting logic would go here
                    -- This would depend on the specific game's mobile shooting mechanism
                end
            end
        end)
    end)
    
    UserInputService.TouchEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        IsShooting = false
        if shootConnection then
            shootConnection:Disconnect()
            shootConnection = nil
        end
    end)
end

-- Universal shooting detection (works for both PC and mobile)
local function handleShooting()
    if not SilentAimEnabled then return end
    
    local target = GetClosestTarget()
    if target and target.Character and target.Character:FindFirstChild(AimPartName) then
        return target.Character[AimPartName].Position
    end
    return nil
end

-- Silent Aim Hook (Universal for PC and Mobile)
local mt = getrawmetatable or getmetatable
local oldNamecall
if mt then
    local meta = mt(game)
    oldNamecall = meta.__namecall
    setreadonly(meta, false)
    meta.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if SilentAimEnabled and method == "FireServer" then
            -- Check for common shooting event names
            local eventName = tostring(self)
            if eventName == "ShootEvent" or eventName == "RemoteEvent" or eventName:find("Shoot") or eventName:find("Fire") then
                local targetPos = handleShooting()
                if targetPos then
                    -- Modify the shooting position to target position
                    if args[1] and typeof(args[1]) == "Vector3" then
                        args[1] = targetPos
                    elseif args[1] and typeof(args[1]) == "table" and args[1].Position then
                        args[1].Position = targetPos
                    end
                    return oldNamecall(self, unpack(args))
                end
            end
        end

        return oldNamecall(self, ...)
    end)
    setreadonly(meta, true)
end

-- Alternative method for games that don't use RemoteEvents
local function setupMobileShooting()
    if not isMobile() then return end
    
    -- Create a virtual shoot button for mobile if needed
    local virtualShootButton = Instance.new("TextButton")
    virtualShootButton.Name = "VirtualShootBtn"
    virtualShootButton.Size = UDim2.new(0, 80, 0, 80)
    virtualShootButton.Position = UDim2.new(1, -100, 1, -100)
    virtualShootButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    virtualShootButton.BackgroundTransparency = 0.5
    virtualShootButton.Text = "SHOOT"
    virtualShootButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    virtualShootButton.TextSize = 14
    virtualShootButton.Font = Enum.Font.GothamBold
    virtualShootButton.Visible = false
    virtualShootButton.Parent = ScreenGui
    
    local virtualCorner = Instance.new("UICorner")
    virtualCorner.CornerRadius = UDim.new(0, 40)
    virtualCorner.Parent = virtualShootButton
    
    -- Show virtual shoot button when silent aim is enabled on mobile
    SilentAimToggle.MouseButton1Click:Connect(function()
        if isMobile() then
            virtualShootButton.Visible = SilentAimEnabled
        end
    end)
end

-- Initialize mobile shooting
setupMobileShooting()

-- ESP Implementation
local espFolder = Instance.new("Folder", Camera)
espFolder.Name = "ESPFolder"

local function CreateESP(player)
    local espBox = Drawing and Drawing.new("Square") or nil
    local espName = Drawing and Drawing.new("Text") or nil

    if not espBox or not espName then return end

    espBox.Visible = false
    espBox.Color = Color3.new(1, 0, 0)
    espBox.Thickness = 2
    espBox.Filled = false

    espName.Visible = false
    espName.Color = Color3.new(1, 1, 1)
    espName.Size = 14
    espName.Center = true
    espName.Outline = true
    espName.Text = player.Name

    return {
        Box = espBox,
        Name = espName
    }
end

local espObjects = {}

local function UpdateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local rootPart = player.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            if onScreen then
                if not espObjects[player] then
                    espObjects[player] = CreateESP(player)
                end
                local esp = espObjects[player]
                if esp then
                    local size = 1000 / pos.Z
                    esp.Box.Size = Vector2.new(size, size)
                    esp.Box.Position = Vector2.new(pos.X - size / 2, pos.Y - size / 2)
                    esp.Box.Visible = ESPEnabled

                    esp.Name.Position = Vector2.new(pos.X, pos.Y - size / 2 - 15)
                    esp.Name.Visible = ESPEnabled
                end
            else
                if espObjects[player] then
                    espObjects[player].Box.Visible = false
                    espObjects[player].Name.Visible = false
                end
            end
        else
            if espObjects[player] then
                espObjects[player].Box.Visible = false
                espObjects[player].Name.Visible = false
            end
        end
    end
end

-- Cleanup ESP on player removal
Players.PlayerRemoving:Connect(function(player)
    if espObjects[player] then
        if espObjects[player].Box then espObjects[player].Box:Remove() end
        if espObjects[player].Name then espObjects[player].Name:Remove() end
        espObjects[player] = nil
    end
end)

-- Main loop
RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        UpdateESP()
    else
        for _, esp in pairs(espObjects) do
            if esp.Box then esp.Box.Visible = false end
            if esp.Name then esp.Name.Visible = false end
        end
    end
end)

-- UI Toggle Functions
SilentAimToggle.MouseButton1Click:Connect(function()
    SilentAimEnabled = not SilentAimEnabled
    if SilentAimEnabled then
        SilentAimToggle.Text = "Silent Aim: ON"
        SilentAimToggle.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        SilentAimToggle.Text = "Silent Aim: OFF"
        SilentAimToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

ESPToggle.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    if ESPEnabled then
        ESPToggle.Text = "ESP: ON"
        ESPToggle.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        ESPToggle.Text = "ESP: OFF"
        ESPToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
        -- Hide all ESP boxes when turning off
        for _, esp in pairs(espObjects) do
            if esp.Box then esp.Box.Visible = false end
            if esp.Name then esp.Name.Visible = false end
        end
    end
end)

-- Fixed FOV Slider Functionality
local isSliding = false
local slideConnection = nil

local function updateFOVSlider()
    if not isSliding then return end
    
    local mousePos = UserInputService:GetMouseLocation()
    local sliderPos = FOVSlider.AbsolutePosition
    local sliderSize = FOVSlider.AbsoluteSize
    local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
    
    FOVFill.Size = UDim2.new(relativeX, 0, 1, 0)
    AimFOV = math.floor(50 + relativeX * 150) -- Range: 50-200
    FOVLabel.Text = "Aim FOV: " .. AimFOV
    FOVValue.Text = tostring(AimFOV)
end

FOVSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isSliding = true
        
        -- Connect to RenderStepped for smooth updates
        if slideConnection then
            slideConnection:Disconnect()
        end
        slideConnection = RunService.RenderStepped:Connect(updateFOVSlider)
        
        -- Update immediately on click
        updateFOVSlider()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and isSliding then
        isSliding = false
        if slideConnection then
            slideConnection:Disconnect()
            slideConnection = nil
        end
    end
end)

print("NAMELESS HUB Loaded")
print("Made by Haxzo")
print("Mobile Support: " .. tostring(isMobile()))
