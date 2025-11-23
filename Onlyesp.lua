local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Jalbird ESP & Aim",
    LoadingTitle = "Loading Jalbird",
    LoadingSubtitle = "by ChatGPT",
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

-- ESP for enemies only
local ESPFolder = Instance.new("Folder", game.CoreGui)
ESPFolder.Name = "JalbirdESP"

local function createESP(player)
    if player == LocalPlayer then return end
    local espBox = Instance.new("BoxHandleAdornment")
    espBox.Adornee = nil
    espBox.AlwaysOnTop = true
    espBox.ZIndex = 10
    espBox.Size = Vector3.new(4, 6, 4)
    espBox.Transparency = 0.5
    espBox.Color3 = Color3.new(1, 0, 0)
    espBox.Parent = ESPFolder

    local function update()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            espBox.Adornee = player.Character.HumanoidRootPart
            espBox.Size = Vector3.new(4, player.Character.HumanoidRootPart.Size.Y * 2, 4)
            espBox.Color3 = Color3.new(1, 0, 0)
            espBox.Transparency = 0.5
        else
            espBox.Adornee = nil
        end
    end

    RunService.RenderStepped:Connect(update)
end

for _, player in pairs(Players:GetPlayers()) do
    createESP(player)
end

Players.PlayerAdded:Connect(function(player)
    createESP(player)
end)

-- Silent Aim for PC, Aimbot for Mobile
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local SilentAimEnabled = false
local AimbotEnabled = false

local SilentAimToggle = Window:CreateToggle({
    Name = "Silent Aim (PC)",
    CurrentValue = false,
    Flag = "SilentAimToggle",
    Callback = function(value)
        SilentAimEnabled = value
        if value then
            AimbotEnabled = false
            Window:FindToggle("Aimbot (Mobile)").Set(false)
        end
    end
})

local AimbotToggle = Window:CreateToggle({
    Name = "Aimbot (Mobile)",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(value)
        AimbotEnabled = value
        if value then
            SilentAimEnabled = false
            Window:FindToggle("Silent Aim (PC)").Set(false)
        end
    end
})

-- Utility function to get closest enemy to cursor (for PC)
local function getClosestEnemyToCursor()
    local closestPlayer = nil
    local shortestDistance = math.huge
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

-- Utility function to get closest enemy to center of screen (for Mobile)
local function getClosestEnemyToCenter()
    local closestPlayer = nil
    local shortestDistance = math.huge
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
    if AimbotEnabled and isMobile then
        local target = getClosestEnemyToCenter()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = target.Character.HumanoidRootPart
            local direction = (hrp.Position - Camera.CFrame.Position).Unit
            local newCFrame = CFrame.new(Camera.CFrame.Position, hrp.Position)
            Camera.CFrame = newCFrame
        end
    end
end)
