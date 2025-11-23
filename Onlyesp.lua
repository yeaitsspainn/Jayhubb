-- Obfuscated variable names and structure
local _G = getgenv()
local HttpService = game:GetService("HttpService")
local RandomId = HttpService:GenerateGUID(false)

-- Delayed execution to avoid pattern detection
task.wait(math.random(1, 3))

-- Load Rayfield with error handling
local success, RayfieldLib = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success then
    return
end

-- Create window with generic name
local MainWindow = RayfieldLib:CreateWindow({
    Name = "Jailbird all in one",
    LoadingTitle = "Loading Tools...",
    LoadingSubtitle = "Please wait",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "GameConfig",
        FileName = "UserSettings"
    },
    KeySystem = false
})

-- Services with delayed loading
local GameServices = {
    Players = game:GetService("Players"),
    RunService = game:GetService("RunService"),
    UserInputService = game:GetService("UserInputService"),
    Workspace = game:GetService("Workspace")
}

local LocalPlayer = GameServices.Players.LocalPlayer
local CurrentCamera = GameServices.Workspace.CurrentCamera

-- ESP System with reduced visibility
local VisualAssistFolder = Instance.new("Folder")
VisualAssistFolder.Name = "VisualHelpers_" .. RandomId
VisualAssistFolder.Parent = game.CoreGui

local function CreateVisualMarker(targetPlayer)
    if targetPlayer == LocalPlayer then return end
    
    local visualBox = Instance.new("BoxHandleAdornment")
    visualBox.Name = "Marker_" .. targetPlayer.Name
    visualBox.Adornee = nil
    visualBox.AlwaysOnTop = false  -- Less obvious
    visualBox.ZIndex = 1  -- Lower priority
    visualBox.Size = Vector3.new(3.5, 5.5, 3.5)
    visualBox.Transparency = 0.7  -- More transparent
    visualBox.Color3 = Color3.fromRGB(150, 50, 50)  -- Less bright red
    visualBox.Parent = VisualAssistFolder

    local updateConnection
    updateConnection = GameServices.RunService.Heartbeat:Connect(function()
        if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                visualBox.Adornee = targetPlayer.Character.HumanoidRootPart
                visualBox.Visible = true
            else
                visualBox.Visible = false
                visualBox.Adornee = nil
            end
        else
            visualBox.Visible = false
            visualBox.Adornee = nil
        end
    end)

    -- Clean up when player leaves
    targetPlayer.AncestryChanged:Connect(function()
        if not targetPlayer.Parent then
            updateConnection:Disconnect()
            visualBox:Destroy()
        end
    end)
end

-- Initialize visual markers with delay
task.spawn(function()
    task.wait(2)
    for _, player in pairs(GameServices.Players:GetPlayers()) do
        CreateVisualMarker(player)
    end
end)

GameServices.Players.PlayerAdded:Connect(function(player)
    task.wait(1)
    CreateVisualMarker(player)
end)

-- Aim assistance system
local AimSettings = {
    VisualAssist = false,
    CameraAssist = false,
    IsMobileDevice = GameServices.UserInputService.TouchEnabled
}

local VisualAssistToggle = MainWindow:CreateToggle({
    Name = "Visual Assistance",
    CurrentValue = false,
    Flag = "VisualAssistFlag",
    Callback = function(value)
        AimSettings.VisualAssist = value
        VisualAssistFolder.Enabled = value
    end
})

local CameraAssistToggle = MainWindow:CreateToggle({
    Name = "Camera Assistance",
    CurrentValue = false,
    Flag = "CameraAssistFlag",
    Callback = function(value)
        AimSettings.CameraAssist = value
        if value then
            AimSettings.VisualAssist = false
            VisualAssistToggle.Set(false)
        end
    end
})

-- Target acquisition with randomness
local function FindOptimalTarget()
    local bestTarget = nil
    local closestDistance = 50  -- Limited range
    
    for _, potentialTarget in pairs(GameServices.Players:GetPlayers()) do
        if potentialTarget ~= LocalPlayer and potentialTarget.Character then
            local rootPart = potentialTarget.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = potentialTarget.Character:FindFirstChildOfClass("Humanoid")
            
            if rootPart and humanoid and humanoid.Health > 0 then
                local screenPos, onScreen = CurrentCamera:WorldToViewportPoint(rootPart.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - 
                                   Vector2.new(CurrentCamera.ViewportSize.X/2, CurrentCamera.ViewportSize.Y/2)).Magnitude
                    
                    if distance < closestDistance then
                        closestDistance = distance
                        bestTarget = potentialTarget
                    end
                end
            end
        end
    end
    
    return bestTarget
end

-- Subtle camera adjustment
local LastCameraUpdate = tick()
GameServices.RunService.Heartbeat:Connect(function()
    if not AimSettings.CameraAssist then return end
    
    local currentTime = tick()
    if currentTime - LastCameraUpdate < 0.1 then return end  -- Limit updates
    LastCameraUpdate = currentTime
    
    local target = FindOptimalTarget()
    if target and target.Character then
        local targetPart = target.Character:FindFirstChild("HumanoidRootPart")
        if targetPart then
            -- Subtle, slow camera movement
            local currentCF = CurrentCamera.CFrame
            local targetPosition = targetPart.Position + Vector3.new(
                math.random(-0.5, 0.5),  -- Add randomness
                math.random(0, 1),
                math.random(-0.5, 0.5)
            )
            
            local newCF = currentCF:Lerp(
                CFrame.lookAt(currentCF.Position, targetPosition),
                0.1  -- Very slow interpolation
            )
            CurrentCamera.CFrame = newCF
        end
    end
end)

-- Clean up on script termination
game:GetService("ScriptContext").DescendantRemoving:Connect(function(descendant)
    if descendant == script then
        VisualAssistFolder:Destroy()
    end
end)

print("Game tools loaded successfully")
