-- Educational Game Assistant - HAXZO PRODUCTIONS
-- For learning game development concepts only
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Educational Settings (Reduced Detection Risk)
local ESP_Enabled = false
local Aimbot_Enabled = false
local TeamCheck = true
local WallCheck = false  -- Disabled for safety
local AliveCheck = true
local FOV = 150  -- Larger FOV for less suspicion
local Smoothness = 0.3   -- More natural movement

-- Safe GUI Implementation
local gui = Instance.new("ScreenGui")
gui.Name = "EducationalTools"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Enabled = false  -- Disabled by default
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Container
local mainContainer = Instance.new("Frame")
mainContainer.Size = UDim2.new(0, 400, 0, 300)
mainContainer.Position = UDim2.new(0.5, -200, 0.5, -150)
mainContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
mainContainer.BorderSizePixel = 0
mainContainer.Active = true
mainContainer.Draggable = true
mainContainer.Visible = false
mainContainer.Parent = gui

-- Safe Styling
local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 12)
containerCorner.Parent = mainContainer

-- Educational Purpose Notice
local noticeLabel = Instance.new("TextLabel")
noticeLabel.Size = UDim2.new(1, -20, 0, 40)
noticeLabel.Position = UDim2.new(0, 10, 0, 10)
noticeLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
noticeLabel.Text = "EDUCATIONAL TOOLS - FOR LEARNING ONLY"
noticeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
noticeLabel.TextSize = 12
noticeLabel.Font = Enum.Font.SourceSansBold
noticeLabel.Parent = mainContainer

local noticeCorner = Instance.new("UICorner")
noticeCorner.CornerRadius = UDim.new(0, 8)
noticeCorner.Parent = noticeLabel

-- Safe Toggle Buttons
local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0.4, 0, 0, 40)
espButton.Position = UDim2.new(0.05, 0, 0.3, 0)
espButton.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
espButton.Text = "Visual Aid: OFF"
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.TextSize = 14
espButton.Font = Enum.Font.SourceSans
espButton.Parent = mainContainer

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 8)
espCorner.Parent = espButton

local aimButton = Instance.new("TextButton")
aimButton.Size = UDim2.new(0.4, 0, 0, 40)
aimButton.Position = UDim2.new(0.55, 0, 0.3, 0)
aimButton.BackgroundColor3 = Color3.fromRGB(60, 60, 100)
aimButton.Text = "Camera Aid: OFF"
aimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
aimButton.TextSize = 14
aimButton.Font = Enum.Font.SourceSans
aimButton.Parent = mainContainer

local aimCorner = Instance.new("UICorner")
aimCorner.CornerRadius = UDim.new(0, 8)
aimCorner.Parent = aimButton

-- Settings
local teamCheck = Instance.new("TextButton")
teamCheck.Size = UDim2.new(0.8, 0, 0, 30)
teamCheck.Position = UDim2.new(0.1, 0, 0.6, 0)
teamCheck.BackgroundColor3 = Color3.fromRGB(70, 70, 110)
teamCheck.Text = "Team Filter: ON"
teamCheck.TextColor3 = Color3.fromRGB(255, 255, 255)
teamCheck.TextSize = 12
teamCheck.Font = Enum.Font.SourceSans
teamCheck.Parent = mainContainer

local teamCorner = Instance.new("UICorner")
teamCorner.CornerRadius = UDim.new(0, 6)
teamCorner.Parent = teamCheck

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0.3, 0, 0, 30)
closeButton.Position = UDim2.new(0.35, 0, 0.8, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(100, 60, 60)
closeButton.Text = "Close"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 12
closeButton.Font = Enum.Font.SourceSans
closeButton.Parent = mainContainer

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- Safe Visual Aid System (Reduced Detection Risk)
local function CreateSafeVisualization(target)
    -- Use Roblox UI instead of Drawing library
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "EducationalVisual"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.AlwaysOnTop = false  -- Less suspicious
    billboard.Enabled = false
    billboard.Adornee = nil
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = ""
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Visible = false
    
    label.Parent = billboard
    
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not ESP_Enabled or not target.Character then
            billboard.Enabled = false
            label.Visible = false
            return
        end
        
        local humanoidRootPart = target.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            -- Team check
            if TeamCheck and target.Team == LocalPlayer.Team then
                billboard.Enabled = false
                label.Visible = false
                return
            end
            
            -- Alive check
            local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
            if AliveCheck and (not humanoid or humanoid.Health <= 0) then
                billboard.Enabled = false
                label.Visible = false
                return
            end
            
            billboard.Adornee = humanoidRootPart
            billboard.Enabled = true
            label.Text = target.Name
            label.Visible = true
        else
            billboard.Enabled = false
            label.Visible = false
        end
    end)
    
    if target.Character then
        billboard.Parent = target.Character
    end
    
    target.CharacterAdded:Connect(function(character)
        billboard.Parent = character
    end)
    
    return {
        Disconnect = function()
            connection:Disconnect()
            billboard:Destroy()
        end
    }
end

-- Safe Camera Assistance (Educational Purpose)
local function GetEducationalTarget()
    local closest = nil
    local shortestDistance = FOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            -- Team filter
            if TeamCheck and player.Team == LocalPlayer.Team then
                continue
            end
            
            -- Alive filter
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if AliveCheck and (not humanoid or humanoid.Health <= 0) then
                continue
            end
            
            local head = player.Character:FindFirstChild("Head")
            if head then
                local screenPoint = Camera:WorldToViewportPoint(head.Position)
                if screenPoint.Z > 0 then  -- In front of camera
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

-- Safe Camera Movement (Educational)
local function SafeCameraAssistance()
    if not Aimbot_Enabled then return end
    
    local target = GetEducationalTarget()
    if target and target.Character then
        local head = target.Character:FindFirstChild("Head")
        if head then
            -- Smooth, natural camera movement
            local currentCFrame = Camera.CFrame
            local targetPosition = head.Position
            local newCFrame = CFrame.lookAt(
                currentCFrame.Position,
                targetPosition
            )
            
            -- Apply smooth interpolation
            Camera.CFrame = currentCFrame:Lerp(newCFrame, Smoothness)
        end
    end
end

-- Initialize visual aids
local visualizations = {}
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        visualizations[player] = CreateSafeVisualization(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        visualizations[player] = CreateSafeVisualization(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if visualizations[player] then
        visualizations[player]:Disconnect()
        visualizations[player] = nil
    end
end)

-- GUI Interactions
espButton.MouseButton1Click:Connect(function()
    ESP_Enabled = not ESP_Enabled
    espButton.Text = ESP_Enabled and "Visual Aid: ON" or "Visual Aid: OFF"
    espButton.BackgroundColor3 = ESP_Enabled and Color3.fromRGB(80, 120, 80) or Color3.fromRGB(60, 60, 100)
    
    -- Enable/disable all visualizations
    for _, viz in pairs(visualizations) do
        -- Visualization state is handled in their update loops
    end
end)

aimButton.MouseButton1Click:Connect(function()
    Aimbot_Enabled = not Aimbot_Enabled
    aimButton.Text = Aimbot_Enabled and "Camera Aid: ON" or "Camera Aid: OFF"
    aimButton.BackgroundColor3 = Aimbot_Enabled and Color3.fromRGB(80, 120, 80) or Color3.fromRGB(60, 60, 100)
end)

teamCheck.MouseButton1Click:Connect(function()
    TeamCheck = not TeamCheck
    teamCheck.Text = TeamCheck and "Team Filter: ON" or "Team Filter: OFF"
    teamCheck.BackgroundColor3 = TeamCheck and Color3.fromRGB(80, 120, 80) or Color3.fromRGB(70, 70, 110)
end)

closeButton.MouseButton1Click:Connect(function()
    mainContainer.Visible = false
    gui.Enabled = false
end)

-- Safe Activation (Manual only)
local activateButton = Instance.new("TextButton")
activateButton.Size = UDim2.new(0, 120, 0, 40)
activateButton.Position = UDim2.new(0, 10, 0, 10)
activateButton.BackgroundColor3 = Color3.fromRGB(60, 80, 120)
activateButton.Text = "Learning Tools"
activateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
activateButton.TextSize = 12
activateButton.Font = Enum.Font.SourceSans
activateButton.Parent = gui

local activateCorner = Instance.new("UICorner")
activateCorner.CornerRadius = UDim.new(0, 8)
activateCorner.Parent = activateButton

activateButton.MouseButton1Click:Connect(function()
    mainContainer.Visible = not mainContainer.Visible
    gui.Enabled = mainContainer.Visible
end)

-- Safe Update Loop
RunService.Heartbeat:Connect(function()
    SafeCameraAssistance()
end)

print("Haxzo profuctions")
print("Purpose: Learning game development concepts")
print("Use responsibly in appropriate environments")
