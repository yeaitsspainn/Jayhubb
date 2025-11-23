-- Roblox ESP Script with Player Names and Health Color (Auto-Reopen on Death)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local espColor = Color3.new(1, 0, 0) -- Red for highlight

local function createESP(target)
    if not target.Character then return end

    -- Highlight
    local highlight = Instance.new("Highlight")
    highlight.FillColor = espColor
    highlight.OutlineColor = espColor
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

    -- Update loop for health
    RunService.RenderStepped:Connect(function()
        if target.Character and target.Character:FindFirstChild("Humanoid") then
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
        end
    end)

    -- Recreate ESP on respawn
    target.CharacterAdded:Connect(function()
        createESP(target)
    end)
end

-- Connect new players
Players.PlayerAdded:Connect(function(target)
    target.CharacterAdded:Connect(function()
        createESP(target)
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
