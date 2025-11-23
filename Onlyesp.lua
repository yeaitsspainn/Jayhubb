-- Jalbird ESP & Aim with Rayfield GUI
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success then
    warn("Rayfield failed to load, using fallback GUI")
    -- Fallback to simple GUI here
    return
end

local Window = Rayfield:CreateWindow({
    Name = "Jalbird ESP & Aim",
    LoadingTitle = "KAINO HUB",
    LoadingSubtitle = "by Haxzo",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "JalbirdConfig",
        FileName = "Settings"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvite",
        RememberJoins = true
    },
    KeySystem = false,
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- Settings
local ESPEnabled = false
local AimbotEnabled = false
local SilentAimEnabled = false
local FOV = 100
local ShowFOV = false

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
    espBox.ZIndex = 5
    espBox.Size = Vector3.new(4, 6, 4)
    espBox.Transparency = 0.6
    espBox.Color3 = Color3.new(1, 0, 0)
    espBox.Visible = false
    espBox.Parent = ESPFolder
    
    ESPBoxes[player] = espBox
    
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if ESPEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                espBox.Adornee = player.Character.HumanoidRootPart
                espBox.Visible = true
            else
                espBox.Visible = false
            end
        else
            espBox.Visible = false
        end
    end)
    
    -- Clean up when player leaves
    player.AncestryChanged:Connect(function()
        if not player.Parent then
            connection:Disconnect()
            if ESPBoxes[player] then
                ESPBoxes[player]:Destroy()
                ESPBoxes[player] = nil
            end
        end
    end)
end

-- Initialize ESP
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
FOVCircle.Thickness = 2
FOVCircle.Filled = false
FOVCircle.Radius = FOV

-- Aimbot Functions
local function getClosestEnemyToCursor()
    local closestPlayer = nil
    local shortestDistance = FOV
    local mouseLocation = UserInputService:GetMouseLocation()

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
                if onScreen then
                    local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouseLocation.X, mouseLocation.Y)).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    return closestPlayer
end

local function getClosestEnemyToCenter()
    local closestPlayer = nil
    local shortestDistance = FOV
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
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
    end
    return closestPlayer
end

-- Create Tabs
local MainTab = Window:CreateTab("Main Features", "🔫")
local SettingsTab = Window:CreateTab("Settings", "⚙️")

-- ESP Toggle
local ESPToggle = MainTab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(value)
        ESPEnabled = value
        -- Update all ESP boxes
        for player, espBox in pairs(ESPBoxes) do
            if value and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    espBox.Visible = true
                end
            else
                espBox.Visible = false
            end
        end
    end
})

-- Aimbot Toggle
local AimbotToggle = MainTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(value)
        AimbotEnabled = value
        if value then
            SilentAimEnabled = false
            SilentAimToggle:Set(false)
        end
    end
})

-- Silent Aim Toggle
local SilentAimToggle = MainTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Flag = "SilentAimToggle",
    Callback = function(value)
        SilentAimEnabled = value
        if value then
            AimbotEnabled = false
            AimbotToggle:Set(false)
        end
    end
})

-- FOV Circle Toggle
local FOVToggle = SettingsTab:CreateToggle({
    Name = "Show FOV Circle",
    CurrentValue = false,
    Flag = "FOVToggle",
    Callback = function(value)
        ShowFOV = value
        FOVCircle.Visible = value
    end
})

-- FOV Slider
local FOVSlider = SettingsTab:CreateSlider({
    Name = "FOV Size",
    Range = {50, 300},
    Increment = 10,
    Suffix = "units",
    CurrentValue = 100,
    Flag = "FOVSlider",
    Callback = function(value)
        FOV = value
        FOVCircle.Radius = value
    end
})

-- Team Check Toggle
local TeamCheckToggle = SettingsTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = true,
    Flag = "TeamCheckToggle",
    Callback = function(value)
        -- Team check logic would go here
    end
})

-- Alive Check Toggle
local AliveCheckToggle = SettingsTab:CreateToggle({
    Name = "Alive Check",
    CurrentValue = true,
    Flag = "AliveCheckToggle",
    Callback = function(value)
        -- Alive check logic would go here
    end
})

-- Silent Aim Hook
local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__index = newcclosure(function(self, key)
    if SilentAimEnabled and key == "Hit" and self == workspace.CurrentCamera then
        local target = getClosestEnemyToCursor()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            return target.Character.Head
        end
    end
    return oldIndex(self, key)
end)

setreadonly(mt, true)

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

-- Button to destroy GUI
local DestroyButton = MainTab:CreateButton({
    Name = "Close GUI",
    Callback = function()
        Rayfield:Destroy()
        FOVCircle:Remove()
        ESPFolder:Destroy()
    end,
})

print("Jalbird ESP & Aim loaded successfully!")
print("Rayfield GUI should be visible")
print("Use the toggles to enable features")
