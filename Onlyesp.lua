-- Simple Jalbird ESP & Aim GUI
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

-- Settings (all disabled by default)
local ESPEnabled = false
local AimbotEnabled = false
local FOV = 100
local FOVCircleVisible = false

-- Create Simple GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "JalbirdGUI"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Styling
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(100, 80, 200)
stroke.Thickness = 2
stroke.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
title.Text = "Jalbird ESP & Aim"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.SourceSansBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- ESP Toggle
local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0.8, 0, 0, 40)
espButton.Position = UDim2.new(0.1, 0, 0.2, 0)
espButton.BackgroundColor3 = Color3.fromRGB(200, 60, 80)
espButton.Text = "ESP: OFF"
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.TextSize = 16
espButton.Font = Enum.Font.SourceSansBold
espButton.Parent = mainFrame

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 6)
espCorner.Parent = espButton

-- Aimbot Toggle
local aimbotButton = Instance.new("TextButton")
aimbotButton.Size = UDim2.new(0.8, 0, 0, 40)
aimbotButton.Position = UDim2.new(0.1, 0, 0.35, 0)
aimbotButton.BackgroundColor3 = Color3.fromRGB(200, 60, 80)
aimbotButton.Text = "Aimbot: OFF"
aimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
aimbotButton.TextSize = 16
aimbotButton.Font = Enum.Font.SourceSansBold
aimbotButton.Parent = mainFrame

local aimbotCorner = Instance.new("UICorner")
aimbotCorner.CornerRadius = UDim.new(0, 6)
aimbotCorner.Parent = aimbotButton

-- FOV Circle Toggle
local fovToggleButton = Instance.new("TextButton")
fovToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
fovToggleButton.Position = UDim2.new(0.1, 0, 0.5, 0)
fovToggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
fovToggleButton.Text = "FOV Circle: OFF"
fovToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
fovToggleButton.TextSize = 14
fovToggleButton.Font = Enum.Font.SourceSansBold
fovToggleButton.Parent = mainFrame

local fovToggleCorner = Instance.new("UICorner")
fovToggleCorner.CornerRadius = UDim.new(0, 6)
fovToggleCorner.Parent = fovToggleButton

-- FOV Slider
local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(0.8, 0, 0, 30)
fovLabel.Position = UDim2.new(0.1, 0, 0.65, 0)
fovLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
fovLabel.Text = "FOV Size: " .. FOV
fovLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fovLabel.TextSize = 14
fovLabel.Font = Enum.Font.SourceSansBold
fovLabel.Parent = mainFrame

local fovLabelCorner = Instance.new("UICorner")
fovLabelCorner.CornerRadius = UDim.new(0, 6)
fovLabelCorner.Parent = fovLabel

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0.8, 0, 0, 40)
closeButton.Position = UDim2.new(0.1, 0, 0.8, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(150, 60, 60)
closeButton.Text = "CLOSE GUI"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- ESP System
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "JalbirdESP"
ESPFolder.Parent = game.CoreGui

local ESPBoxes = {}

local function createESP(player)
    if player == LocalPlayer then return end
    
    local espBox = Instance.new("BoxHandleAdornment")
    espBox.Adornee = nil
    espBox.AlwaysOnTop = true
    espBox.ZIndex = 10
    espBox.Size = Vector3.new(4, 6, 4)
    espBox.Transparency = 0.5
    espBox.Color3 = Color3.new(1, 0, 0)
    espBox.Visible = false
    espBox.Parent = ESPFolder
    
    ESPBoxes[player] = espBox
    
    local function update()
        if ESPEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            espBox.Adornee = player.Character.HumanoidRootPart
            espBox.Size = Vector3.new(4, player.Character.HumanoidRootPart.Size.Y * 2, 4)
            espBox.Visible = true
        else
            espBox.Visible = false
            espBox.Adornee = nil
        end
    end
    
    RunService.RenderStepped:Connect(update)
end

local function enableESP()
    ESPEnabled = true
    for player, espBox in pairs(ESPBoxes) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            espBox.Visible = true
        end
    end
end

local function disableESP()
    ESPEnabled = false
    for player, espBox in pairs(ESPBoxes) do
        espBox.Visible = false
        espBox.Adornee = nil
    end
end

-- Initialize ESP for all players (but keep disabled)
for _, player in pairs(Players:GetPlayers()) do
    createESP(player)
end

Players.PlayerAdded:Connect(function(player)
    createESP(player)
end)

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Color = Color3.new(1, 1, 0)
FOVCircle.Thickness = 1
FOVCircle.Filled = false
FOVCircle.Radius = FOV

-- Aimbot Functions
local function getClosestEnemyToCenter()
    local closestPlayer = nil
    local shortestDistance = FOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    return closestPlayer
end

-- Button Functions
espButton.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    espButton.Text = ESPEnabled and "ESP: ON" or "ESP: OFF"
    espButton.BackgroundColor3 = ESPEnabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(200, 60, 80)
    
    if ESPEnabled then
        enableESP()
    else
        disableESP()
    end
end)

aimbotButton.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    aimbotButton.Text = AimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
    aimbotButton.BackgroundColor3 = AimbotEnabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(200, 60, 80)
end)

fovToggleButton.MouseButton1Click:Connect(function()
    FOVCircleVisible = not FOVCircleVisible
    fovToggleButton.Text = FOVCircleVisible and "FOV Circle: ON" or "FOV Circle: OFF"
    fovToggleButton.BackgroundColor3 = FOVCircleVisible and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(80, 80, 120)
    FOVCircle.Visible = FOVCircleVisible
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    FOVCircle:Remove()
    disableESP()
end)

-- FOV Slider Controls
fovLabel.MouseButton1Click:Connect(function()
    FOV = FOV + 20
    if FOV > 300 then
        FOV = 50
    end
    FOVCircle.Radius = FOV
    fovLabel.Text = "FOV Size: " .. FOV
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
    -- Update FOV Circle position
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    -- Aimbot logic
    if AimbotEnabled then
        local target = getClosestEnemyToCenter()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = target.Character.HumanoidRootPart
            local newCFrame = CFrame.new(Camera.CFrame.Position, hrp.Position)
            Camera.CFrame = newCFrame
        end
    end
end)

print("Jalbird ESP & Aim loaded successfully!")
print("GUI should be visible on screen")
print("Click buttons to toggle features")
