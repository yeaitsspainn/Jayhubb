-- Nameless Hub | Rivals
-- Fixed & Working Version

if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Load services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Wait for player
repeat wait() until LocalPlayer.Character

-- Simple UI Library (since Orion might not load properly)
local function CreateSimpleUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NamelessHub"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 350, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 8)
    HeaderCorner.Parent = Header
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "NAMELESS HUB | RIVALS"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.Parent = Header
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 14
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = Header
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton
    
    -- Content Frame
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, -20, 1, -60)
    ContentFrame.Position = UDim2.new(0, 10, 0, 50)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Parent = MainFrame
    
    -- Toggles
    local toggles = {}
    
    local function CreateToggle(name, yPosition, defaultValue)
        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(1, 0, 0, 35)
        toggle.Position = UDim2.new(0, 0, 0, yPosition)
        toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        toggle.Text = name .. ": OFF"
        toggle.TextColor3 = Color3.fromRGB(255, 100, 100)
        toggle.TextSize = 14
        toggle.Font = Enum.Font.Gotham
        toggle.Parent = ContentFrame
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = toggle
        
        toggles[name] = {
            Button = toggle,
            Value = defaultValue,
            Callback = nil
        }
        
        return toggles[name]
    end
    
    -- Create toggles
    local silentAimToggle = CreateToggle("Silent Aim", 10, false)
    local espToggle = CreateToggle("ESP", 55, false)
    local fovToggle = CreateToggle("FOV Circle", 100, false)
    
    -- FOV Slider
    local FOVLabel = Instance.new("TextLabel")
    FOVLabel.Size = UDim2.new(1, 0, 0, 20)
    FOVLabel.Position = UDim2.new(0, 0, 0, 145)
    FOVLabel.BackgroundTransparency = 1
    FOVLabel.Text = "Aim FOV: 100"
    FOVLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    FOVLabel.TextSize = 14
    FOVLabel.Font = Enum.Font.Gotham
    FOVLabel.Parent = ContentFrame
    
    local FOVSlider = Instance.new("TextButton")
    FOVSlider.Size = UDim2.new(1, 0, 0, 25)
    FOVSlider.Position = UDim2.new(0, 0, 0, 170)
    FOVSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    FOVSlider.Text = ""
    FOVSlider.AutoButtonColor = false
    FOVSlider.Parent = ContentFrame
    
    local FOVFill = Instance.new("Frame")
    FOVFill.Size = UDim2.new(0.5, 0, 1, 0)
    FOVFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    FOVFill.BorderSizePixel = 0
    FOVFill.Parent = FOVSlider
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 6)
    sliderCorner.Parent = FOVSlider
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 6)
    fillCorner.Parent = FOVFill
    
    -- Make draggable
    local dragging = false
    local dragStart, startPos
    
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    Header.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    Header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    return {
        ScreenGui = ScreenGui,
        Toggles = toggles,
        FOVLabel = FOVLabel,
        FOVSlider = FOVSlider,
        FOVFill = FOVFill
    }
end

-- Create UI
local UI = CreateSimpleUI()

-- Configuration
local SilentAimEnabled = false
local ESPEnabled = false
local FOVCircleEnabled = false
local AimFOV = 100
local AimPartName = "Head"

-- Mobile detection
local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.MouseEnabled
end

-- FOV Circle
local FOVCircle = nil
local function CreateFOVCircle()
    if FOVCircle then FOVCircle:Remove() end
    
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Visible = FOVCircleEnabled
    FOVCircle.Radius = AimFOV
    FOVCircle.Color = Color3.fromRGB(255, 255, 255)
    FOVCircle.Thickness = 2
    FOVCircle.Filled = false
    
    if isMobile() then
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    else
        local mousePos = UserInputService:GetMouseLocation()
        FOVCircle.Position = Vector2.new(mousePos.X, mousePos.Y)
    end
end

local function UpdateFOVCircle()
    if not FOVCircle or not FOVCircleEnabled then return end
    
    if not isMobile() then
        local mousePos = UserInputService:GetMouseLocation()
        FOVCircle.Position = Vector2.new(mousePos.X, mousePos.Y)
    end
    FOVCircle.Radius = AimFOV
end

-- Target finding
local function GetClosestTarget()
    local closestTarget = nil
    local shortestDistance = AimFOV

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local aimPart = player.Character:FindFirstChild(AimPartName)
            
            if humanoid and humanoid.Health > 0 and aimPart then
                local targetPos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
                if onScreen then
                    local inputPos = isMobile() and Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) or UserInputService:GetMouseLocation()
                    local distance = (Vector2.new(targetPos.X, targetPos.Y) - inputPos).Magnitude
                    
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestTarget = player
                    end
                end
            end
        end
    end

    return closestTarget
end

-- Silent Aim Logic
local function GetClosestTargetPosition()
    if not SilentAimEnabled then return nil end
    
    local target = GetClosestTarget()
    if target and target.Character and target.Character:FindFirstChild(AimPartName) then
        return target.Character[AimPartName].Position
    end
    return nil
end

-- Hook for shooting
local oldNamecall
if metatable then
    local meta = getrawmetatable(game)
    oldNamecall = meta.__namecall
    
    setreadonly(meta, false)
    
    meta.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if SilentAimEnabled and (method == "FireServer" or method == "InvokeServer") then
            local targetPos = GetClosestTargetPosition()
            if targetPos then
                -- Modify shooting arguments for Rivals
                if type(args[1]) == "table" and args[1].Position then
                    args[1].Position = targetPos
                elseif type(args[1]) == "Vector3" then
                    args[1] = targetPos
                end
            end
        end
        
        return oldNamecall(self, unpack(args))
    end)
    
    setreadonly(meta, true)
end

-- ESP System
local espObjects = {}
local function CreateESP(player)
    local espBox = Drawing.new("Square")
    local espName = Drawing.new("Text")
    
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
    
    return {Box = espBox, Name = espName}
end

local function UpdateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and humanoid.Health > 0 and rootPart then
                local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                
                if onScreen then
                    if not espObjects[player] then
                        espObjects[player] = CreateESP(player)
                    end
                    
                    local esp = espObjects[player]
                    local size = 1000 / pos.Z
                    
                    esp.Box.Size = Vector2.new(size, size)
                    esp.Box.Position = Vector2.new(pos.X - size/2, pos.Y - size/2)
                    esp.Box.Visible = ESPEnabled
                    
                    esp.Name.Position = Vector2.new(pos.X, pos.Y - size/2 - 15)
                    esp.Name.Visible = ESPEnabled
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
end

-- UI Interactions
-- Silent Aim Toggle
UI.Toggles["Silent Aim"].Button.MouseButton1Click:Connect(function()
    SilentAimEnabled = not SilentAimEnabled
    if SilentAimEnabled then
        UI.Toggles["Silent Aim"].Button.Text = "Silent Aim: ON"
        UI.Toggles["Silent Aim"].Button.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        UI.Toggles["Silent Aim"].Button.Text = "Silent Aim: OFF"
        UI.Toggles["Silent Aim"].Button.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- ESP Toggle
UI.Toggles["ESP"].Button.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    if ESPEnabled then
        UI.Toggles["ESP"].Button.Text = "ESP: ON"
        UI.Toggles["ESP"].Button.TextColor3 = Color3.fromRGB(100, 255, 100)
    else
        UI.Toggles["ESP"].Button.Text = "ESP: OFF"
        UI.Toggles["ESP"].Button.TextColor3 = Color3.fromRGB(255, 100, 100)
        -- Hide ESP
        for _, esp in pairs(espObjects) do
            esp.Box.Visible = false
            esp.Name.Visible = false
        end
    end
end)

-- FOV Circle Toggle
UI.Toggles["FOV Circle"].Button.MouseButton1Click:Connect(function()
    FOVCircleEnabled = not FOVCircleEnabled
    if FOVCircleEnabled then
        UI.Toggles["FOV Circle"].Button.Text = "FOV Circle: ON"
        UI.Toggles["FOV Circle"].Button.TextColor3 = Color3.fromRGB(100, 255, 100)
        CreateFOVCircle()
    else
        UI.Toggles["FOV Circle"].Button.Text = "FOV Circle: OFF"
        UI.Toggles["FOV Circle"].Button.TextColor3 = Color3.fromRGB(255, 100, 100)
        if FOVCircle then
            FOVCircle.Visible = false
        end
    end
end)

-- FOV Slider
local isSliding = false
UI.FOVSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isSliding = true
    end
end)

UI.FOVSlider.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isSliding = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isSliding and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UserInputService:GetMouseLocation()
        local sliderPos = UI.FOVSlider.AbsolutePosition
        local sliderSize = UI.FOVSlider.AbsoluteSize
        local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
        
        UI.FOVFill.Size = UDim2.new(relativeX, 0, 1, 0)
        AimFOV = math.floor(50 + relativeX * 200) -- 50-250 range
        UI.FOVLabel.Text = "Aim FOV: " .. AimFOV
        
        if FOVCircle then
            FOVCircle.Radius = AimFOV
        end
    end
end)

-- Clean up ESP when players leave
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
    end
    
    if FOVCircleEnabled then
        UpdateFOVCircle()
    end
end)

print("Nameless Hub | Rivals Loaded Successfully!")
print("Mobile Mode: " .. tostring(isMobile()))
