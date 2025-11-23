-- Fixed ESP & Aimbot GUI - HAXZO PRODUCTIONS
-- Make sure to enable the correct permissions in your executor

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Wait for game to load
if not Players.LocalPlayer then
    repeat wait() until Players.LocalPlayer
end

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Settings
local ESP_Enabled = false
local Aimbot_Enabled = false
local TeamCheck = true
local FOV = 100

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "HAXZO_GUI"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Wait for PlayerGui
if not LocalPlayer:FindFirstChild("PlayerGui") then
    repeat wait() until LocalPlayer:FindFirstChild("PlayerGui")
end
gui.Parent = LocalPlayer.PlayerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

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
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
title.Text = "HAXZO PRODUCTIONS"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.SourceSansBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- ESP Button
local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(0.8, 0, 0, 40)
espBtn.Position = UDim2.new(0.1, 0, 0.15, 0)
espBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 80)
espBtn.Text = "ESP: OFF"
espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
espBtn.TextSize = 16
espBtn.Font = Enum.Font.SourceSansBold
espBtn.Parent = mainFrame

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 6)
espCorner.Parent = espBtn

-- Aimbot Button
local aimBtn = Instance.new("TextButton")
aimBtn.Size = UDim2.new(0.8, 0, 0, 40)
aimBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
aimBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 80)
aimBtn.Text = "AIMBOT: OFF"
aimBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
aimBtn.TextSize = 16
aimBtn.Font = Enum.Font.SourceSansBold
aimBtn.Parent = mainFrame

local aimCorner = Instance.new("UICorner")
aimCorner.CornerRadius = UDim.new(0, 6)
aimCorner.Parent = aimBtn

-- Team Check
local teamBtn = Instance.new("TextButton")
teamBtn.Size = UDim2.new(0.8, 0, 0, 40)
teamBtn.Position = UDim2.new(0.1, 0, 0.45, 0)
teamBtn.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
teamBtn.Text = "TEAM CHECK: ON"
teamBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teamBtn.TextSize = 14
teamBtn.Font = Enum.Font.SourceSansBold
teamBtn.Parent = mainFrame

local teamCorner = Instance.new("UICorner")
teamCorner.CornerRadius = UDim.new(0, 6)
teamCorner.Parent = teamBtn

-- FOV Display
local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(0.8, 0, 0, 30)
fovLabel.Position = UDim2.new(0.1, 0, 0.6, 0)
fovLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
fovLabel.Text = "FOV: " .. FOV
fovLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fovLabel.TextSize = 14
fovLabel.Font = Enum.Font.SourceSansBold
fovLabel.Parent = mainFrame

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(0, 6)
fovCorner.Parent = fovLabel

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0.8, 0, 0, 40)
closeBtn.Position = UDim2.new(0.1, 0, 0.75, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 60, 60)
closeBtn.Text = "CLOSE GUI"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

-- Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 30)
status.Position = UDim2.new(0, 0, 1, -30)
status.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
status.Text = "Status: Ready"
status.TextColor3 = Color3.fromRGB(180, 180, 255)
status.TextSize = 12
status.Font = Enum.Font.SourceSans
status.Parent = mainFrame

-- Button Functions
espBtn.MouseButton1Click:Connect(function()
    ESP_Enabled = not ESP_Enabled
    espBtn.Text = ESP_Enabled and "ESP: ON" or "ESP: OFF"
    espBtn.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(200, 60, 80)
    status.Text = ESP_Enabled and "ESP Enabled" or "ESP Disabled"
end)

aimBtn.MouseButton1Click:Connect(function()
    Aimbot_Enabled = not Aimbot_Enabled
    aimBtn.Text = Aimbot_Enabled and "AIMBOT: ON" or "AIMBOT: OFF"
    aimBtn.BackgroundColor3 = Aimbot_Enabled and Color3.fromRGB(80, 200, 120) or Color3.fromRGB(200, 60, 80)
    status.Text = Aimbot_Enabled and "Aimbot Enabled" or "Aimbot Disabled"
end)

teamBtn.MouseButton1Click:Connect(function()
    TeamCheck = not TeamCheck
    teamBtn.Text = TeamCheck and "TEAM CHECK: ON" or "TEAM CHECK: OFF"
    teamBtn.BackgroundColor3 = TeamCheck and Color3.fromRGB(80, 120, 200) or Color3.fromRGB(120, 80, 80)
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- FOV Circle (if Drawing library works)
local fovCircle = nil
if pcall(function() 
    fovCircle = Drawing.new("Circle")
    fovCircle.Visible = false
    fovCircle.Color = Color3.fromRGB(255, 255, 0)
    fovCircle.Thickness = 1
    fovCircle.Filled = false
end) then
    status.Text = "FOV Circle: Available"
else
    status.Text = "FOV Circle: Not Available"
end

-- Simple ESP using Billboards (more reliable)
local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_" .. player.Name
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.Enabled = false
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = player.Name
    textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    textLabel.TextSize = 14
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Parent = billboard
    
    local function update()
        if not ESP_Enabled or not player.Character then
            billboard.Enabled = false
            return
        end
        
        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            if TeamCheck and player.Team == LocalPlayer.Team then
                billboard.Enabled = false
                return
            end
            
            billboard.Adornee = humanoidRootPart
            billboard.Enabled = true
        else
            billboard.Enabled = false
        end
    end
    
    if player.Character then
        billboard.Parent = player.Character
        update()
    end
    
    player.CharacterAdded:Connect(function(character)
        wait(1) -- Wait for character to load
        billboard.Parent = character
        update()
    end)
    
    return billboard
end

-- Initialize ESP for all players
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    wait(2) -- Wait for player to load
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end)

-- Simple Aimbot
local function GetClosestPlayer()
    local closest = nil
    local shortestDistance = FOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if TeamCheck and player.Team == LocalPlayer.Team then
                continue
            end
            
            local head = player.Character:FindFirstChild("Head")
            if head then
                local screenPoint = Camera:WorldToViewportPoint(head.Position)
                if screenPoint.Z > 0 then
                    local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - 
                                   Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closest = player
                    end
                end
            end
        end
    end
    
    return closest
end

-- Main loop
RunService.RenderStepped:Connect(function()
    -- Update FOV circle
    if fovCircle then
        fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        fovCircle.Radius = FOV
        fovCircle.Visible = Aimbot_Enabled
    end
    
    -- Aimbot logic
    if Aimbot_Enabled then
        local target = GetClosestPlayer()
        if target and target.Character then
            local head = target.Character:FindFirstChild("Head")
            if head then
                -- Simple camera look (be careful with this)
                Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, head.Position)
            end
        end
    end
end)

-- Keybind to toggle GUI
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

print("HAXZO PRODUCTIONS Loaded Successfully!")
print("Press Right Shift to hide/show GUI")
print("Use at your own risk!")
