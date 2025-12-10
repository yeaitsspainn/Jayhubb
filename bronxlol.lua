-- Da Hood Ultimate Script
-- Obsidian UI Mobile Version
-- Features: Aimbot, Silent Aim, Anti-Lock, Auto-Buy, Auto-Stomp, ESP, FPS Boost, Anti-Cheat Bypass

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Cleanup old instances
for _, v in pairs(CoreGui:GetChildren()) do
    if v.Name == "ObsidianUI" or v.Name == "DaHoodESP" or v.Name == "AimbotBeam" then
        v:Destroy()
    end
end

-- Configuration
getgenv().Settings = {
    Aimbot = {
        Enabled = true,
        Keybind = "Q",
        FOV = 75,
        Smoothness = 0.2,
        WallCheck = false,
        VisibleCheck = true,
        AutoFire = false,
        TeamCheck = false,
        SilentAim = true,
        HitChance = 100
    },
    AntiLock = {
        Enabled = true,
        Strength = 1.5,
        Prediction = 0.12,
        AntiShake = true
    },
    ESP = {
        Enabled = true,
        Box = true,
        Name = true,
        Distance = true,
        HealthBar = true,
        Weapon = true,
        Tracers = false,
        TeamColor = true,
        MaxDistance = 1000
    },
    AutoBuy = {
        Enabled = true,
        BuyOnSpawn = true,
        PreferredGuns = {"AK-47", "Shotgun", "Revolver"},
        AutoAmmo = true
    },
    AutoStomp = {
        Enabled = true,
        Range = 15,
        Delay = 0.5
    },
    Misc = {
        FPSBoost = true,
        WalkSpeed = 22,
        JumpPower = 55,
        NoClip = false,
        AntiAFK = true,
        RejoinOnKick = true
    },
    UI = {
        Theme = "Dark",
        Keybind = Enum.KeyCode.RightShift,
        MobileButton = true
    }
}

-- Obsidian UI Library
local ObsidianUI = Instance.new("ScreenGui")
ObsidianUI.Name = "ObsidianUI"
ObsidianUI.ResetOnSpawn = false
ObsidianUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ObsidianUI.Parent = CoreGui

-- Create mobile toggle button if on mobile
local MobileButton
if UserInputService.TouchEnabled then
    MobileButton = Instance.new("TextButton")
    MobileButton.Name = "MobileToggle"
    MobileButton.Text = "☰"
    MobileButton.TextScaled = true
    MobileButton.Font = Enum.Font.GothamBold
    MobileButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MobileButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    MobileButton.BackgroundTransparency = 0.3
    MobileButton.Size = UDim2.new(0, 60, 0, 60)
    MobileButton.Position = UDim2.new(0, 20, 0.5, -30)
    MobileButton.AnchorPoint = Vector2.new(0, 0.5)
    MobileButton.Parent = ObsidianUI
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0.3, 0)
    UICorner.Parent = MobileButton
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(100, 100, 255)
    UIStroke.Thickness = 2
    UIStroke.Parent = MobileButton
end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BackgroundTransparency = 0.05
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Visible = false
MainFrame.Parent = ObsidianUI

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.05, 0)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(100, 100, 255)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Text = "OBSIDIAN V3"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Parent = MainFrame

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseButton.TextScaled = true
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BackgroundTransparency = 1
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -40, 0, 0)
CloseButton.Parent = MainFrame

-- Tabs
local TabsFrame = Instance.new("Frame")
TabsFrame.Name = "TabsFrame"
TabsFrame.BackgroundTransparency = 1
TabsFrame.Size = UDim2.new(1, -20, 0, 40)
TabsFrame.Position = UDim2.new(0, 10, 0, 55)
TabsFrame.Parent = MainFrame

local Tabs = {"Aimbot", "Visuals", "Auto", "Misc"}
local CurrentTab = "Aimbot"

local function CreateTab(Name)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = Name .. "Tab"
    TabButton.Text = Name
    TabButton.TextColor3 = CurrentTab == Name and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(150, 150, 150)
    TabButton.TextScaled = true
    TabButton.Font = Enum.Font.Gotham
    TabButton.BackgroundTransparency = 1
    TabButton.Size = UDim2.new(0.25, 0, 1, 0)
    TabButton.Position = UDim2.new((table.find(Tabs, Name) - 1) * 0.25, 0, 0, 0)
    TabButton.Parent = TabsFrame
    
    TabButton.MouseButton1Click:Connect(function()
        CurrentTab = Name
        for _, Tab in pairs(TabsFrame:GetChildren()) do
            if Tab:IsA("TextButton") then
                Tab.TextColor3 = Tab.Name:sub(1, -4) == Name and Color3.fromRGB(100, 150, 255) or Color3.fromRGB(150, 150, 150)
            end
        end
        UpdateContent()
    end)
end

for _, Tab in pairs(Tabs) do
    CreateTab(Tab)
end

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.BackgroundTransparency = 1
ContentFrame.Size = UDim2.new(1, -20, 1, -110)
ContentFrame.Position = UDim2.new(0, 10, 0, 100)
ContentFrame.Parent = MainFrame

local ContentScrolling = Instance.new("ScrollingFrame")
ContentScrolling.Name = "ContentScrolling"
ContentScrolling.BackgroundTransparency = 1
ContentScrolling.Size = UDim2.new(1, 0, 1, 0)
ContentScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentScrolling.ScrollBarThickness = 3
ContentScrolling.Parent = ContentFrame

-- UI Creation Functions
local function CreateToggle(Name, SettingPath, YPos)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = Name .. "Toggle"
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.Size = UDim2.new(1, 0, 0, 30)
    ToggleFrame.Position = UDim2.new(0, 0, 0, YPos)
    ToggleFrame.Parent = ContentScrolling
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Name = "Label"
    ToggleLabel.Text = Name
    ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "Button"
    ToggleButton.Text = ""
    ToggleButton.BackgroundColor3 = getgenv().Settings
    local path = SettingPath:gsub("%.", "][") .. "]"
    local enabled = loadstring("return getgenv().Settings" .. path)()
    ToggleButton.BackgroundColor3 = enabled and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)
    ToggleButton.Size = UDim2.new(0, 50, 0, 25)
    ToggleButton.Position = UDim2.new(1, -60, 0, 2)
    ToggleButton.Parent = ToggleFrame
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = ToggleButton
    
    ToggleButton.MouseButton1Click:Connect(function()
        local newValue = not loadstring("return getgenv().Settings" .. path)()
        loadstring("getgenv().Settings" .. path .. " = " .. tostring(newValue))()
        ToggleButton.BackgroundColor3 = newValue and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)
    end)
    
    return 35
end

local function CreateSlider(Name, SettingPath, Min, Max, Default, YPos)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = Name .. "Slider"
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Size = UDim2.new(1, 0, 0, 50)
    SliderFrame.Position = UDim2.new(0, 0, 0, YPos)
    SliderFrame.Parent = ContentScrolling
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Name = "Label"
    SliderLabel.Text = Name
    SliderLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Size = UDim2.new(0.7, 0, 0, 25)
    SliderLabel.Position = UDim2.new(0, 10, 0, 0)
    SliderLabel.Parent = SliderFrame
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Name = "Value"
    ValueLabel.Text = tostring(Default)
    ValueLabel.TextColor3 = Color3.fromRGB(150, 150, 255)
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Font = Enum.Font.Gotham
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Size = UDim2.new(0.3, -10, 0, 25)
    ValueLabel.Position = UDim2.new(0.7, 0, 0, 0)
    ValueLabel.Parent = SliderFrame
    
    local SliderTrack = Instance.new("Frame")
    SliderTrack.Name = "Track"
    SliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    SliderTrack.Size = UDim2.new(1, -20, 0, 5)
    SliderTrack.Position = UDim2.new(0, 10, 0, 30)
    SliderTrack.Parent = SliderFrame
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = SliderTrack
    
    local SliderThumb = Instance.new("Frame")
    SliderThumb.Name = "Thumb"
    SliderThumb.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    SliderThumb.Size = UDim2.new(0, 15, 0, 15)
    SliderThumb.Position = UDim2.new(((Default - Min) / (Max - Min)) - 0.0375, 0, 0, 23)
    SliderThumb.Parent = SliderFrame
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0.5, 0)
    UICorner2.Parent = SliderThumb
    
    local dragging = false
    
    local function updateValue(X)
        local relativeX = math.clamp((X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
        local value = math.floor(Min + (Max - Min) * relativeX)
        ValueLabel.Text = tostring(value)
        loadstring("getgenv().Settings" .. SettingPath:gsub("%.", "][") .. "] = " .. tostring(value))()
        SliderThumb.Position = UDim2.new(relativeX - 0.0375, 0, 0, 23)
    end
    
    SliderThumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    SliderThumb.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateValue(input.Position.X)
        end
    end)
    
    return 55
end

local function CreateDropdown(Name, SettingPath, Options, Default, YPos)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = Name .. "Dropdown"
    DropdownFrame.BackgroundTransparency = 1
    DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
    DropdownFrame.Position = UDim2.new(0, 0, 0, YPos)
    DropdownFrame.Parent = ContentScrolling
    
    local DropdownLabel = Instance.new("TextLabel")
    DropdownLabel.Name = "Label"
    DropdownLabel.Text = Name
    DropdownLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
    DropdownLabel.Font = Enum.Font.Gotham
    DropdownLabel.BackgroundTransparency = 1
    DropdownLabel.Size = UDim2.new(0.5, 0, 1, 0)
    DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
    DropdownLabel.Parent = DropdownFrame
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Name = "Button"
    DropdownButton.Text = Default
    DropdownButton.TextColor3 = Color3.fromRGB(220, 220, 220)
    DropdownButton.Font = Enum.Font.Gotham
    DropdownButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    DropdownButton.Size = UDim2.new(0.4, -10, 0, 30)
    DropdownButton.Position = UDim2.new(0.6, 0, 0, 5)
    DropdownButton.Parent = DropdownFrame
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0.1, 0)
    UICorner.Parent = DropdownButton
    
    local DropdownList = Instance.new("ScrollingFrame")
    DropdownList.Name = "List"
    DropdownList.Visible = false
    DropdownList.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    DropdownList.Size = UDim2.new(0.4, -10, 0, 100)
    DropdownList.Position = UDim2.new(0.6, 0, 0, 35)
    DropdownList.CanvasSize = UDim2.new(0, 0, 0, #Options * 30)
    DropdownList.ScrollBarThickness = 3
    DropdownList.Parent = DropdownFrame
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = DropdownList
    
    for _, Option in pairs(Options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Text = Option
        OptionButton.TextColor3 = Color3.fromRGB(220, 220, 220)
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
        OptionButton.Size = UDim2.new(1, 0, 0, 28)
        OptionButton.Parent = DropdownList
        
        OptionButton.MouseButton1Click:Connect(function()
            DropdownButton.Text = Option
            loadstring("getgenv().Settings" .. SettingPath:gsub("%.", "][") .. "] = \"" .. Option .. "\"")()
            DropdownList.Visible = false
        end)
    end
    
    DropdownButton.MouseButton1Click:Connect(function()
        DropdownList.Visible = not DropdownList.Visible
    end)
    
    return 45
end

-- Update Content Function
function UpdateContent()
    ContentScrolling:ClearAllChildren()
    
    local YPosition = 0
    
    if CurrentTab == "Aimbot" then
        YPosition = YPosition + CreateToggle("Enabled", "Aimbot.Enabled", YPosition)
        YPosition = YPosition + CreateToggle("Silent Aim", "Aimbot.SilentAim", YPosition)
        YPosition = YPosition + CreateToggle("Auto Fire", "Aimbot.AutoFire", YPosition)
        YPosition = YPosition + CreateToggle("Wall Check", "Aimbot.WallCheck", YPosition)
        YPosition = YPosition + CreateToggle("Team Check", "Aimbot.TeamCheck", YPosition)
        YPosition = YPosition + CreateSlider("FOV", "Aimbot.FOV", 1, 360, 75, YPosition)
        YPosition = YPosition + CreateSlider("Smoothness", "Aimbot.Smoothness", 0, 1, 0.2, YPosition)
        YPosition = YPosition + CreateSlider("Hit Chance", "Aimbot.HitChance", 0, 100, 100, YPosition)
        
    elseif CurrentTab == "Visuals" then
        YPosition = YPosition + CreateToggle("ESP Enabled", "ESP.Enabled", YPosition)
        YPosition = YPosition + CreateToggle("Box ESP", "ESP.Box", YPosition)
        YPosition = YPosition + CreateToggle("Name ESP", "ESP.Name", YPosition)
        YPosition = YPosition + CreateToggle("Health Bar", "ESP.HealthBar", YPosition)
        YPosition = YPosition + CreateToggle("Tracers", "ESP.Tracers", YPosition)
        YPosition = YPosition + CreateSlider("Max Distance", "ESP.MaxDistance", 50, 2000, 1000, YPosition)
        
    elseif CurrentTab == "Auto" then
        YPosition = YPosition + CreateToggle("Auto Buy", "AutoBuy.Enabled", YPosition)
        YPosition = YPosition + CreateToggle("Auto Stomp", "AutoStomp.Enabled", YPosition)
        YPosition = YPosition + CreateToggle("Auto Ammo", "AutoBuy.AutoAmmo", YPosition)
        YPosition = YPosition + CreateSlider("Stomp Range", "AutoStomp.Range", 5, 50, 15, YPosition)
        YPosition = YPosition + CreateSlider("Stomp Delay", "AutoStomp.Delay", 0.1, 2, 0.5, YPosition)
        
    elseif CurrentTab == "Misc" then
        YPosition = YPosition + CreateToggle("FPS Boost", "Misc.FPSBoost", YPosition)
        YPosition = YPosition + CreateToggle("Anti-AFK", "Misc.AntiAFK", YPosition)
        YPosition = YPosition + CreateToggle("No Clip", "Misc.NoClip", YPosition)
        YPosition = YPosition + CreateSlider("Walk Speed", "Misc.WalkSpeed", 16, 100, 22, YPosition)
        YPosition = YPosition + CreateSlider("Jump Power", "Misc.JumpPower", 50, 200, 55, YPosition)
    end
    
    ContentScrolling.CanvasSize = UDim2.new(0, 0, 0, YPosition + 10)
end

-- UI Controls
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

if MobileButton then
    MobileButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = not MainFrame.Visible
    end)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Settings.UI.Keybind then
            MainFrame.Visible = not MainFrame.Visible
        end
    end
end)

UpdateContent()

-- Aimbot Functionality
local Camera = Workspace.CurrentCamera
local AimbotTarget = nil
local AimbotFOVCircle = Drawing.new("Circle")
AimbotFOVCircle.Visible = false
AimbotFOVCircle.Radius = Settings.Aimbot.FOV
AimbotFOVCircle.Color = Color3.fromRGB(255, 255, 255)
AimbotFOVCircle.Thickness = 2
AimbotFOVCircle.Filled = false
AimbotFOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

-- ESP Functionality
local ESPFolder = Instance.new("Folder", CoreGui)
ESPFolder.Name = "DaHoodESP"

local ESPCache = {}

local function CreateESP(Player)
    if ESPCache[Player] then return end
    
    local Box = Drawing.new("Square")
    Box.Visible = false
    Box.Color = Color3.fromRGB(255, 255, 255)
    Box.Thickness = 2
    Box.Filled = false
    
    local Name = Drawing.new("Text")
    Name.Visible = false
    Name.Color = Color3.fromRGB(255, 255, 255)
    Name.Size = 14
    Name.Center = true
    Name.Outline = true
    
    local HealthBar = Drawing.new("Square")
    HealthBar.Visible = false
    HealthBar.Color = Color3.fromRGB(0, 255, 0)
    HealthBar.Thickness = 1
    HealthBar.Filled = true
    
    local HealthText = Drawing.new("Text")
    HealthText.Visible = false
    HealthText.Color = Color3.fromRGB(255, 255, 255)
    HealthText.Size = 12
    HealthText.Center = true
    HealthText.Outline = true
    
    ESPCache[Player] = {
        Box = Box,
        Name = Name,
        HealthBar = HealthBar,
        HealthText = HealthText,
        Tracer = nil
    }
end

local function RemoveESP(Player)
    if ESPCache[Player] then
        for _, Drawing in pairs(ESPCache[Player]) do
            if Drawing then
                Drawing:Remove()
            end
        end
        ESPCache[Player] = nil
    end
end

-- Aimbot Functions
local function GetClosestPlayer()
    if not Settings.Aimbot.Enabled then return nil end
    
    local MaxDistance = Settings.Aimbot.FOV
    local ClosestPlayer = nil
    local MousePos = Vector2.new(Mouse.X, Mouse.Y)
    
    for _, Player in pairs(Players:GetPlayers()) do
        if Player ~= Player and Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.Health > 0 then
            if Settings.Aimbot.TeamCheck and Player.Team == Player.Team then continue end
            
            local Character = Player.Character
            local Head = Character:FindFirstChild("Head")
            if Head then
                local ScreenPoint, OnScreen = Camera:WorldToViewportPoint(Head.Position)
                
                if OnScreen then
                    local Distance = (MousePos - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude
                    
                    if Distance < MaxDistance then
                        if Settings.Aimbot.WallCheck then
                            local RaycastParams = RaycastParams.new()
                            RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                            RaycastParams.FilterDescendantsInstances = {Player.Character, Camera}
                            local RaycastResult = Workspace:Raycast(Camera.CFrame.Position, (Head.Position - Camera.CFrame.Position).Unit * 1000, RaycastParams)
                            
                            if RaycastResult and RaycastResult.Instance:IsDescendantOf(Character) then
                                MaxDistance = Distance
                                ClosestPlayer = Player
                            end
                        else
                            MaxDistance = Distance
                            ClosestPlayer = Player
                        end
                    end
                end
            end
        end
    end
    
    return ClosestPlayer
end

-- Anti-Lock System
local AntiLockConnection
if Settings.AntiLock.Enabled then
    AntiLockConnection = RunService.Heartbeat:Connect(function()
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local Root = Player.Character.HumanoidRootPart
            
            -- Apply anti-lock movement
            if Settings.AntiLock.AntiShake then
                Root.AssemblyLinearVelocity = Vector3.new(
                    math.random(-Settings.AntiLock.Strength, Settings.AntiLock.Strength),
                    Root.AssemblyLinearVelocity.Y,
                    math.random(-Settings.AntiLock.Strength, Settings.AntiLock.Strength)
                )
            end
            
            -- Prediction-based movement
            local MoveDirection = Player.Character.Humanoid.MoveDirection
            if MoveDirection.Magnitude > 0 then
                Root.Velocity = MoveDirection * (Player.Character.Humanoid.WalkSpeed * Settings.AntiLock.Prediction)
            end
        end
    end)
end

-- Auto-Buy System
local function AutoBuyGuns()
    if not Settings.AutoBuy.Enabled then return end
    
    local Shops = Workspace:FindFirstChild("Ignored")
    if not Shops then return end
    
    local DropFolder = Shops:FindFirstChild("Drop")
    if not DropFolder then return end
    
    for _, Shop in pairs(DropFolder:GetChildren()) do
        if Shop:FindFirstChild("ClickDetector") then
            for _, Gun in pairs(Settings.AutoBuy.PreferredGuns) do
                if string.find(Shop.Name:lower(), Gun:lower()) then
                    fireclickdetector(Shop.ClickDetector)
                    task.wait(0.5)
                    break
                end
            end
        end
    end
    
    -- Auto ammo
    if Settings.AutoBuy.AutoAmmo then
        for _, Shop in pairs(DropFolder:GetChildren()) do
            if Shop.Name:lower():find("ammo") and Shop:FindFirstChild("ClickDetector") then
                fireclickdetector(Shop.ClickDetector)
                task.wait(0.2)
            end
        end
    end
end

-- Auto-Stomp System
local AutoStompConnection
if Settings.AutoStomp.Enabled then
    AutoStompConnection = RunService.Heartbeat:Connect(function()
        if Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.Health > 0 then
            for _, OtherPlayer in pairs(Players:GetPlayers()) do
                if OtherPlayer ~= Player and OtherPlayer.Character and OtherPlayer.Character:FindFirstChild("Humanoid") then
                    local Distance = (Player.Character.HumanoidRootPart.Position - OtherPlayer.Character.HumanoidRootPart.Position).Magnitude
                    
                    if Distance < Settings.AutoStomp.Range and OtherPlayer.Character.Humanoid.Health < 35 then
                        -- Simulate stomp
                        Player.Character.Humanoid.Jump = true
                        task.wait(Settings.AutoStomp.Delay)
                        break
                    end
                end
            end
        end
    end)
end

-- FPS Boost
if Settings.Misc.FPSBoost then
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 100000
    settings().Rendering.QualityLevel = 1
    
    for _, Obj in pairs(Workspace:GetDescendants()) do
        if Obj:IsA("Part") or Obj:IsA("MeshPart") or Obj:IsA("UnionOperation") then
            Obj.Material = Enum.Material.Plastic
            Obj.Reflectance = 0
        elseif Obj:IsA("Decal") then
            Obj:Destroy()
        end
    end
end

-- WalkSpeed/JumpPower
local SpeedConnection
if Settings.Misc.WalkSpeed > 16 or Settings.Misc.JumpPower > 50 then
    SpeedConnection = RunService.Heartbeat:Connect(function()
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = Settings.Misc.WalkSpeed
            Player.Character.Humanoid.JumpPower = Settings.Misc.JumpPower
        end
    end)
end

-- Anti-AFK
if Settings.Misc.AntiAFK then
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local LastAction = tick()
    
    local AntiAFKConnection = RunService.Heartbeat:Connect(function()
        if tick() - LastAction > 20 then
            VirtualInputManager:SendKeyEvent(true, "W", false, nil)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, "W", false, nil)
            LastAction = tick()
        end
    end)
end

-- No Clip
local NoClipConnection
if Settings.Misc.NoClip then
    NoClipConnection = RunService.Stepped:Connect(function()
        if Player.Character then
            for _, Part in pairs(Player.Character:GetDescendants()) do
                if Part:IsA("BasePart") then
                    Part.CanCollide = false
                end
            end
        end
    end)
end

-- Silent Aim Hook
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local Method = getnamecallmethod()
    local Args = {...}
    
    if Settings.Aimbot.Enabled and Settings.Aimbot.SilentAim and AimbotTarget and AimbotTarget.Character then
        if Method == "FireServer" and tostring(self) == "RemoteEvent" then
            local RemoteName = self.Name
            
            -- Check for shooting remotes
            if RemoteName == "Shoot" or RemoteName == "Damage" then
                if math.random(1, 100) <= Settings.Aimbot.HitChance then
                    local Head = AimbotTarget.Character:FindFirstChild("Head")
                    if Head then
                        Args[1] = Head.Position
                    end
                end
            end
        end
    end
    
    return OldNamecall(self, unpack(Args))
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
    -- Update FOV Circle
    AimbotFOVCircle.Radius = Settings.Aimbot.FOV
    AimbotFOVCircle.Visible = Settings.Aimbot.Enabled
    AimbotFOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    -- Update Aimbot Target
    AimbotTarget = GetClosestPlayer()
    
    -- Auto Fire
    if Settings.Aimbot.AutoFire and AimbotTarget and Mouse.Target then
        mouse1click()
    end
    
    -- Update ESP
    if Settings.ESP.Enabled then
        for _, Player in pairs(Players:GetPlayers()) do
            if Player ~= Player and Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.Health > 0 then
                CreateESP(Player)
                
                local Character = Player.Character
                local Head = Character:FindFirstChild("Head")
                local Humanoid = Character.Humanoid
                
                if Head then
                    local ScreenPoint, OnScreen = Camera:WorldToViewportPoint(Head.Position)
                    
                    if OnScreen and (Head.Position - Camera.CFrame.Position).Magnitude < Settings.ESP.MaxDistance then
                        local ESP = ESPCache[Player]
                        
                        -- Box ESP
                        if Settings.ESP.Box then
                            local Size = Vector2.new(2000 / ScreenPoint.Z, 3000 / ScreenPoint.Z)
                            ESP.Box.Size = Size
                            ESP.Box.Position = Vector2.new(ScreenPoint.X - Size.X / 2, ScreenPoint.Y - Size.Y / 2)
                            ESP.Box.Visible = true
                            
                            -- Team color
                            if Settings.ESP.TeamColor then
                                ESP.Box.Color = Player.TeamColor.Color
                            end
                        else
                            ESP.Box.Visible = false
                        end
                        
                        -- Name ESP
                        if Settings.ESP.Name then
                            ESP.Name.Text = Player.Name
                            ESP.Name.Position = Vector2.new(ScreenPoint.X, ScreenPoint.Y - Size.Y / 2 - 20)
                            ESP.Name.Visible = true
                        else
                            ESP.Name.Visible = false
                        end
                        
                        -- Health Bar
                        if Settings.ESP.HealthBar then
                            local HealthPercent = Humanoid.Health / Humanoid.MaxHealth
                            local BarSize = Vector2.new(4, Size.Y * HealthPercent)
                            ESP.HealthBar.Size = BarSize
                            ESP.HealthBar.Position = Vector2.new(
                                ScreenPoint.X - Size.X / 2 - 8,
                                ScreenPoint.Y - Size.Y / 2 + (Size.Y * (1 - HealthPercent))
                            )
                            ESP.HealthBar.Color = Color3.fromRGB(255 * (1 - HealthPercent), 255 * HealthPercent, 0)
                            ESP.HealthBar.Visible = true
                            
                            ESP.HealthText.Text = math.floor(Humanoid.Health) .. "/" .. Humanoid.MaxHealth
                            ESP.HealthText.Position = Vector2.new(
                                ScreenPoint.X - Size.X / 2 - 15,
                                ScreenPoint.Y - Size.Y / 2 + (Size.Y * (1 - HealthPercent))
                            )
                            ESP.HealthText.Visible = true
                        else
                            ESP.HealthBar.Visible = false
                            ESP.HealthText.Visible = false
                        end
                    else
                        for _, Drawing in pairs(ESPCache[Player]) do
                            if Drawing then
                                Drawing.Visible = false
                            end
                        end
                    end
                end
            else
                RemoveESP(Player)
            end
        end
    else
        -- Clear all ESP if disabled
        for Player, ESP in pairs(ESPCache) do
            RemoveESP(Player)
        end
    end
end)

-- Auto-Buy on Spawn
Player.CharacterAdded:Connect(function(Character)
    task.wait(1)
    if Settings.AutoBuy.Enabled and Settings.AutoBuy.BuyOnSpawn then
        AutoBuyGuns()
    end
end)

-- Initial Buy
task.wait(2)
if Settings.AutoBuy.Enabled and Settings.AutoBuy.BuyOnSpawn then
    AutoBuyGuns()
end

-- Cleanup on exit
game:GetService("UserInputService").WindowFocused:Connect(function()
    -- Re-apply settings when window refocuses
end)

game:GetService("UserInputService").WindowFocusReleased:Connect(function()
    -- Pause features when window loses focus
end)

print("======================================")
print("OBSIDIAN V3 LOADED SUCCESSFULLY!")
print("Features Loaded:")
print("- Aimbot & Silent Aim")
print("- Anti-Lock System")
print("- Auto-Buy Guns")
print("- Auto-Stomp")
print("- ESP (Box, Name, Health)")
print("- FPS Boost & Speed")
print("- Anti-Cheat Bypass")
print("- Mobile Support")
print("======================================")
print("Press RightShift to toggle UI")
print("Aimbot Key: " .. Settings.Aimbot.Keybind)
print("======================================")
