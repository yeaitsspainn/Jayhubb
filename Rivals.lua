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

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 350)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -175)
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
SilentAimToggle.Size = UDim2.new(1, 0, 0, 30)
SilentAimToggle.Position = UDim2.new(0, 0, 0, 10)
SilentAimToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
SilentAimToggle.Text = "Silent Aim: OFF"
SilentAimToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
SilentAimToggle.Font = Enum.Font.Gotham
SilentAimToggle.Parent = ContentFrame

local ESPToggle = Instance.new("TextButton")
ESPToggle.Name = "ESPToggle"
ESPToggle.Size = UDim2.new(1, 0, 0, 30)
ESPToggle.Position = UDim2.new(0, 0, 0, 50)
ESPToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
ESPToggle.Text = "ESP: OFF"
ESPToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
ESPToggle.Font = Enum.Font.Gotham
ESPToggle.Parent = ContentFrame

-- FOV Slider
local FOVLabel = Instance.new("TextLabel")
FOVLabel.Name = "FOVLabel"
FOVLabel.Size = UDim2.new(1, 0, 0, 20)
FOVLabel.Position = UDim2.new(0, 0, 0, 90)
FOVLabel.BackgroundTransparency = 1
FOVLabel.Text = "Aim FOV: 100"
FOVLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FOVLabel.TextScaled = true
FOVLabel.Font = Enum.Font.Gotham
FOVLabel.Parent = ContentFrame

local FOVSlider = Instance.new("TextButton")
FOVSlider.Name = "FOVSlider"
FOVSlider.Size = UDim2.new(1, 0, 0, 20)
FOVSlider.Position = UDim2.new(0, 0, 0, 110)
FOVSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
FOVSlider.Text = ""
FOVSlider.Parent = ContentFrame

local FOVFill = Instance.new("Frame")
FOVFill.Name = "FOVFill"
FOVFill.Size = UDim2.new(0.5, 0, 1, 0)
FOVFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
FOVFill.BorderSizePixel = 0
FOVFill.Parent = FOVSlider

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 100, 0, 30)
CloseButton.Position = UDim2.new(0.5, -50, 1, -40)
CloseButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
CloseButton.Text = "Close"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.Gotham
CloseButton.Parent = ContentFrame

-- Style buttons
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 4)
buttonCorner.Parent = SilentAimToggle
buttonCorner:Clone().Parent = ESPToggle
buttonCorner:Clone().Parent = FOVSlider
buttonCorner:Clone().Parent = CloseButton

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 4)
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

-- UI Interactions
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
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
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
    if input.UserInputType == Enum.UserInputType.MouseMovement then
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

-- Utility functions
local function GetClosestTarget()
    local closestTarget = nil
    local shortestDistance = AimFOV

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(AimPartName) and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local targetPos, onScreen = Camera:WorldToViewportPoint(player.Character[AimPartName].Position)
            if onScreen then
                local mousePos = UserInputService:GetMouseLocation()
                local distance = (Vector2.new(targetPos.X, targetPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestTarget = player
                end
            end
        end
    end

    return closestTarget
end

-- Silent Aim Hook
local mt = getrawmetatable or getmetatable
local oldNamecall
if mt then
    local meta = mt(game)
    oldNamecall = meta.__namecall
    setreadonly(meta, false)
    meta.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if SilentAimEnabled and method == "FireServer" and tostring(self) == "ShootEvent" then
            local target = GetClosestTarget()
            if target and target.Character and target.Character:FindFirstChild(AimPartName) then
                args[1] = target.Character[AimPartName].Position
                return oldNamecall(self, unpack(args))
            end
        end

        return oldNamecall(self, ...)
    end)
    setreadonly(meta, true)
end

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

-- FOV Slider Functionality
FOVSlider.MouseButton1Down:Connect(function()
    local connection
    connection = RunService.RenderStepped:Connect(function()
        local mousePos = UserInputService:GetMouseLocation()
        local sliderPos = FOVSlider.AbsolutePosition
        local sliderSize = FOVSlider.AbsoluteSize
        local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
        
        FOVFill.Size = UDim2.new(relativeX, 0, 1, 0)
        AimFOV = math.floor(50 + relativeX * 150) -- Range: 50-200
        FOVLabel.Text = "Aim FOV: " .. AimFOV
    end)
    
    local function disconnect()
        connection:Disconnect()
    end
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            disconnect()
        end
    end)
end)

print("NAMELESS HUB Loaded")
print("Made by Haxzo")
