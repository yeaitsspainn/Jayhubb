-- Roblox ESP Script with Player Names and Health Color (Auto-Reopen on Death)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local espColor = Color3.new(1, 0, 0) -- Red for highlight

-- ESP State
local espEnabled = true
local espObjects = {}

-- Create Screen GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESPGui"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0, 20)
mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Corner
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Stroke
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.new(1, 1, 1)
stroke.Thickness = 2
stroke.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
title.Text = "ESP Controls"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 20
title.Font = Enum.Font.SourceSansBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.8, 0, 0, 50)
toggleButton.Position = UDim2.new(0.1, 0, 0.3, 0)
toggleButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
toggleButton.Text = "DISABLE ESP"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.TextSize = 18
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Parent = mainFrame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = toggleButton

-- Close Button (Mobile)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0.8, 0, 0, 40)
closeButton.Position = UDim2.new(0.1, 0, 0.6, 0)
closeButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
closeButton.Text = "CLOSE"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextSize = 16
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- Mobile Toggle Button (Always visible for mobile)
local mobileToggle = Instance.new("TextButton")
mobileToggle.Size = UDim2.new(0, 120, 0, 50)
mobileToggle.Position = UDim2.new(0, 10, 0, 10)
mobileToggle.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)
mobileToggle.Text = "ESP: ON"
mobileToggle.TextColor3 = Color3.new(1, 1, 1)
mobileToggle.TextSize = 14
mobileToggle.Font = Enum.Font.SourceSansBold
mobileToggle.Visible = false -- Only show on mobile
mobileToggle.Parent = screenGui

local mobileCorner = Instance.new("UICorner")
mobileCorner.CornerRadius = UDim.new(0, 8)
mobileCorner.Parent = mobileToggle

-- Detect if player is on mobile
local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

-- Toggle ESP function
local function toggleESP()
    espEnabled = not espEnabled
    
    if espEnabled then
        toggleButton.Text = "DISABLE ESP"
        toggleButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
        mobileToggle.Text = "ESP: ON"
        mobileToggle.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)
        -- Re-enable all ESP
        for _, target in ipairs(Players:GetPlayers()) do
            if target ~= player then
                createESP(target)
            end
        end
    else
        toggleButton.Text = "ENABLE ESP"
        toggleButton.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)
        mobileToggle.Text = "ESP: OFF"
        mobileToggle.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
        -- Remove all ESP
        for _, obj in pairs(espObjects) do
            if obj.highlight then
                obj.highlight:Destroy()
            end
            if obj.billboard then
                obj.billboard:Destroy()
            end
        end
        espObjects = {}
    end
end

-- Toggle GUI visibility
local function toggleGUI()
    mainFrame.Visible = not mainFrame.Visible
end

-- Button connections
toggleButton.MouseButton1Click:Connect(toggleESP)
closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)
mobileToggle.MouseButton1Click:Connect(toggleESP)

-- F key to open GUI (PC only)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        toggleGUI()
    end
end)

-- Show mobile toggle if on mobile
if isMobile() then
    mobileToggle.Visible = true
end

-- ESP Creation Function
local function createESP(target)
    if not espEnabled or not target.Character then return end

    -- Clean up existing ESP
    if espObjects[target] then
        if espObjects[target].highlight then
            espObjects[target].highlight:Destroy()
        end
        if espObjects[target].billboard then
            espObjects[target].billboard:Destroy()
        end
    end

    -- Highlight
    local highlight = Instance.new("Highlight")
    highlight.FillColor = espColor
    highlight.OutlineColor = espColor
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = target.Character

    -- Billboard for health and name
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Name"
    billboard.Adornee = target.Character:WaitForChild("Head")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = target.Character

    -- Health label (above the name)
    local healthLabel = Instance.new("TextLabel")
    healthLabel.TextColor3 = Color3.new(0, 1, 0) -- Start green
    healthLabel.TextSize = 16
    healthLabel.Font = Enum.Font.SourceSansBold
    healthLabel.BackgroundTransparency = 1
    healthLabel.Size = UDim2.new(1, 0, 0, 20)
    healthLabel.Position = UDim2.new(0, 0, 0, 0)
    healthLabel.Parent = billboard

    -- Name label
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Text = target.Name
    nameLabel.TextColor3 = espColor
    nameLabel.TextSize = 18
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.BackgroundTransparency = 1
    nameLabel.Size = UDim2.new(1, 0, 0, 25)
    nameLabel.Position = UDim2.new(0, 0, 0, 20)
    nameLabel.Parent = billboard

    -- Store ESP objects
    espObjects[target] = {
        highlight = highlight,
        billboard = billboard
    }

    -- Update loop for health
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not espEnabled or not target.Character or not target.Character:FindFirstChild("Humanoid") then
            connection:Disconnect()
            return
        end
        
        local humanoid = target.Character.Humanoid
        healthLabel.Text = "Health: " .. math.floor(humanoid.Health)
        -- Color gradient: green (high) -> yellow (medium) -> red (low)
        local healthRatio = humanoid.Health / humanoid.MaxHealth
        if healthRatio > 0.5 then
            healthLabel.TextColor3 = Color3.new(0, 1, 0)
        elseif healthRatio > 0.2 then
            healthLabel.TextColor3 = Color3.new(1, 1, 0)
        else
            healthLabel.TextColor3 = Color3.new(1, 0, 0)
        end
    end)

    -- Recreate ESP on respawn
    target.CharacterAdded:Connect(function()
        wait(1) -- Wait for character to fully load
        if espEnabled then
            createESP(target)
        end
    end)
end

-- Connect new players
Players.PlayerAdded:Connect(function(target)
    target.CharacterAdded:Connect(function()
        wait(1)
        if espEnabled then
            createESP(target)
        end
    end)
end)

-- Apply to all existing players
for _, target in ipairs(Players:GetPlayers()) do
    if target ~= player then
        createESP(target)
    end
end

-- Auto-reopen on death
player.CharacterAdded:Connect(function()
    wait(1)
    for _, target in ipairs(Players:GetPlayers()) do
        if target ~= player and target.Character then
            createESP(target)
        end
    end
end)

-- Instructions label
local instructions = Instance.new("TextLabel")
instructions.Size = UDim2.new(0, 200, 0, 30)
instructions.Position = UDim2.new(0, 10, 0, 70)
instructions.BackgroundTransparency = 1
instructions.Text = "Press F to open/close"
instructions.TextColor3 = Color3.new(1, 1, 1)
instructions.TextSize = 14
instructions.Visible = not isMobile()
instructions.Parent = screenGui

print("ESP Script Loaded!")
print("Press F to open/close GUI")
print("Mobile users: Use the green toggle button")
