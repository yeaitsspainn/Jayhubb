--[[
    Universal Aimbot Module by Exunys
    Compatible with Delta, Xeno, Solara
]]

-- Services
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- Variables
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- Check if Drawing is supported
local DrawingSupported = pcall(function()
    local test = Drawing.new("Circle")
    test.Visible = false
    test:Remove()
end)

-- Environment
getgenv().ExunysAimbot = {
    Settings = {
        Enabled = true,
        TeamCheck = false,
        AliveCheck = true,
        WallCheck = false,
        Sensitivity = 0.1,
        FOV = 100,
        LockPart = "Head",
        TriggerKey = "MouseButton2",
        Toggle = false
    },
    ServiceConnections = {},
    Running = false,
    Locked = nil
}

local Aim = getgenv().ExunysAimbot

-- Create FOV Circle if supported
if DrawingSupported then
    Aim.FOVCircle = Drawing.new("Circle")
    Aim.FOVCircle.Visible = false
    Aim.FOVCircle.Radius = Aim.Settings.FOV
    Aim.FOVCircle.Color = Color3.fromRGB(255, 255, 255)
    Aim.FOVCircle.Thickness = 2
    Aim.FOVCircle.Filled = false
end

-- Core Functions
function Aim:GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = Aim.Settings.FOV

    for _, player in pairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if Aim.Settings.TeamCheck and player.Team == LocalPlayer.Team then continue end
        
        local character = player.Character
        if not character then continue end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then continue end
        
        local targetPart = character:FindFirstChild(Aim.Settings.LockPart)
        if not targetPart then continue end

        if Aim.Settings.WallCheck then
            local origin = Camera.CFrame.Position
            local target = targetPart.Position
            local direction = (target - origin).Unit * (origin - target).Magnitude
            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
            raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, character}
            
            local raycastResult = Workspace:Raycast(origin, direction, raycastParams)
            if raycastResult then continue end
        end

        local screenPoint, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
        if onScreen then
            local mousePos = Vector2.new(Mouse.X, Mouse.Y)
            local targetPos = Vector2.new(screenPoint.X, screenPoint.Y)
            local distance = (mousePos - targetPos).Magnitude

            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = player
            end
        end
    end

    return closestPlayer
end

function Aim:AimAtPlayer()
    if not Aim.Running or not Aim.Settings.Enabled then return end
    
    local targetPlayer = Aim:GetClosestPlayer()
    if not targetPlayer then
        Aim.Locked = nil
        return
    end

    local character = targetPlayer.Character
    if not character then return end

    local targetPart = character:FindFirstChild(Aim.Settings.LockPart)
    if not targetPart then return end

    Aim.Locked = targetPlayer
    
    if Aim.Settings.Sensitivity > 0 then
        local tweenInfo = TweenInfo.new(Aim.Settings.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        local tween = TweenService:Create(Camera, tweenInfo, {CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)})
        tween:Play()
    else
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
    end
end

function Aim:ToggleAimbot()
    Aim.Running = not Aim.Running
    if not Aim.Running then
        Aim.Locked = nil
    end
    print("Aimbot: " .. (Aim.Running and "ON" or "OFF"))
end

-- Input Handling
function Aim:SetupInput()
    Aim.ServiceConnections.InputBegan = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode[ Aim.Settings.TriggerKey] then
                if Aim.Settings.Toggle then
                    Aim:ToggleAimbot()
                else
                    Aim.Running = true
                end
            end
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
            if Aim.Settings.Toggle then
                Aim:ToggleAimbot()
            else
                Aim.Running = true
            end
        end
    end)

    Aim.ServiceConnections.InputEnded = UserInputService.InputEnded:Connect(function(input)
        if not Aim.Settings.Toggle then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode[Aim.Settings.TriggerKey] then
                    Aim.Running = false
                    Aim.Locked = nil
                end
            elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                Aim.Running = false
                Aim.Locked = nil
            end
        end
    end)
end

-- Main Loop
function Aim:Start()
    Aim:SetupInput()
    
    Aim.ServiceConnections.RenderStepped = RunService.RenderStepped:Connect(function()
        -- Update FOV Circle
        if DrawingSupported then
            Aim.FOVCircle.Visible = Aim.Settings.Enabled
            Aim.FOVCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
            Aim.FOVCircle.Radius = Aim.Settings.FOV
            Aim.FOVCircle.Color = Aim.Locked and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
        end
        
        -- Run aimbot
        Aim:AimAtPlayer()
    end)
    
    print("Exunys Aimbot Loaded Successfully!")
    print("Trigger Key: " .. Aim.Settings.TriggerKey)
    print("Toggle Mode: " .. tostring(Aim.Settings.Toggle))
end

-- UI Functions
function Aim:CreateSimpleUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AimbotUI"
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 200, 0, 150)
    mainFrame.Position = UDim2.new(0, 10, 0, 10)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    title.Text = "Exunys Aimbot"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = title
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0.8, 0, 0, 30)
    toggleBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    toggleBtn.Text = "Toggle Aimbot: OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 12
    toggleBtn.Parent = mainFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = toggleBtn
    
    toggleBtn.MouseButton1Click:Connect(function()
        Aim:ToggleAimbot()
        toggleBtn.Text = "Toggle Aimbot: " .. (Aim.Running and "ON" or "OFF")
        toggleBtn.BackgroundColor3 = Aim.Running and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(100, 0, 0)
    end)
    
    Aim.UI = screenGui
end

-- Public Methods
function Aim:Exit()
    for _, connection in pairs(Aim.ServiceConnections) do
        connection:Disconnect()
    end
    
    if DrawingSupported and Aim.FOVCircle then
        Aim.FOVCircle:Remove()
    end
    
    if Aim.UI then
        Aim.UI:Destroy()
    end
    
    getgenv().ExunysAimbot = nil
    print("Aimbot unloaded successfully!")
end

-- Auto Start
Aim:CreateSimpleUI()
Aim:Start()

return Aim


end
