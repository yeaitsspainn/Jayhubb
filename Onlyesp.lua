-- Jalbird ESP & Aim with GUI Controls
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Jalbird ESP & Aim",
    LoadingTitle = "Loading Jalbird script",
    LoadingSubtitle = "by Haxzo",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "JalbirdConfig",
        FileName = "Settings"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Jalbird Key System",
        Subtitle = "Key System",
        Note = "No key required",
        FileName = "KeyFile",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = ""
    }
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

-- Settings (all disabled by default)
local ESPEnabled = false
local AimbotEnabled = false
local SilentAimEnabled = false
local FOV = 100
local FOVCircleVisible = false

-- ESP System (disabled until toggled)
local ESPFolder = Instance.new("Folder", game.CoreGui)
ESPFolder.Name = "JalbirdESP"

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Color = Color3.new(1, 1, 0)
FOVCircle.Thickness = 1
FOVCircle.Filled = false
FOVCircle.Radius = FOV
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

-- ESP Toggle
local ESPToggle = Window:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(value)
        ESPEnabled = value
        if value then
            enableESP()
        else
            disableESP()
        end
    end
})

-- Aimbot Toggle
local AimbotToggle = Window:CreateToggle({
    Name = "Aimbot (Mobile)",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(value)
        AimbotEnabled = value
        if value then
            SilentAimEnabled = false
            SilentAimToggle.Set(false)
        end
    end
})

-- Silent Aim Toggle
local SilentAimToggle = Window:CreateToggle({
    Name = "Silent Aim (PC)",
    CurrentValue = false,
    Flag = "SilentAimToggle",
    Callback = function(value)
        SilentAimEnabled = value
        if value then
            AimbotEnabled = false
            AimbotToggle.Set(false)
        end
    end
})

-- FOV Circle Toggle
local FOVCircleToggle = Window:CreateToggle({
    Name = "Show FOV Circle",
    CurrentValue = false,
    Flag = "FOVCircleToggle",
    Callback = function(value)
        FOVCircleVisible = value
        FOVCircle.Visible = value
    end
})

-- FOV Slider
local FOVSlider = Window:CreateSlider({
    Name = "FOV Size",
    Range = {10, 300},
    Increment = 10,
    Suffix = "units",
    CurrentValue = 100,
    Flag = "FOVSlider",
    Callback = function(value)
        FOV = value
        FOVCircle.Radius = value
    end
})

-- ESP Functions
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
            espBox.Color3 = Color3.new(1, 0, 0)
            espBox.Transparency = 0.5
            espBox.Visible = true
        else
            espBox.Visible = false
            espBox.Adornee = nil
        end
    end
    
    RunService.RenderStepped:Connect(update)
end

local function enableESP()
    for player, espBox in pairs(ESPBoxes) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            espBox.Visible = true
        end
    end
end

local function disableESP()
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

Players.PlayerRemoving:Connect(function(player)
    if ESPBoxes[player] then
        ESPBoxes[player]:Destroy()
        ESPBoxes[player] = nil
    end
end)

-- Aimbot Functions
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local function getClosestEnemyToCursor()
    local closestPlayer = nil
    local shortestDistance = FOV
    local mouseLocation = UserInputService:GetMouseLocation()

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
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
    return closestPlayer
end

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

-- Silent Aim Hook (PC)
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

-- Aimbot for Mobile
RunService.RenderStepped:Connect(function()
    -- Update FOV Circle position
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    -- Aimbot logic
    if AimbotEnabled and isMobile then
        local target = getClosestEnemyToCenter()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = target.Character.HumanoidRootPart
            local newCFrame = CFrame.new(Camera.CFrame.Position, hrp.Position)
            Camera.CFrame = newCFrame
        end
    end
end)

-- Clean up when GUI closes
Window:Destroyed(function()
    -- Disable everything
    ESPEnabled = false
    AimbotEnabled = false
    SilentAimEnabled = false
    FOVCircleVisible = false
    
    -- Clean up ESP
    disableESP()
    ESPFolder:Destroy()
    
    -- Clean up FOV Circle
    FOVCircle:Remove()
    
    print("Jalbird GUI closed - All features disabled")
end)

print("Jalbird ESP & Aim loaded successfully!")
print("Use the GUI toggles to enable features")
print("ESP: Toggle player boxes")
print("Aimbot: Mobile camera assist") 
print("Silent Aim: PC hitbox adjustment")
print("FOV Circle: Shows aim radius")
