--========================================================--
--  JALBIRD DARK-TECH UI (Custom GUI, No Rayfield)
--========================================================--

--// SERVICES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

--// DARK-TECH THEME
local Theme = {
    Background = Color3.fromRGB(15, 15, 15),
    Panel = Color3.fromRGB(25, 25, 25),
    Accent = Color3.fromRGB(0, 150, 255),
    DarkAccent = Color3.fromRGB(0, 100, 180),
    Text = Color3.fromRGB(220, 220, 220),
    Red = Color3.fromRGB(255, 70, 70)
}

--========================================================--
--           CUSTOM UI LIBRARY (MINIMAL • DARK)
--========================================================--

local UI = {}

function UI:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    ScreenGui.Name = "JalbirdDarkTech"

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 440, 0, 330)
    MainFrame.Position = UDim2.new(0.32, 0, 0.25, 0)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0

    local TitleBar = Instance.new("Frame", MainFrame)
    TitleBar.Size = UDim2.new(1, 0, 0, 38)
    TitleBar.BackgroundColor3 = Theme.Panel
    TitleBar.BorderSizePixel = 0

    local Title = Instance.new("TextLabel", TitleBar)
    Title.Size = UDim2.new(1, -10, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Text = "🔧  " .. title
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = Theme.Text
    Title.TextSize = 18
    Title.BackgroundTransparency = 1

    -- draggable
    local dragging, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    local TabHolder = Instance.new("Frame", MainFrame)
    TabHolder.Size = UDim2.new(0, 110, 1, -38)
    TabHolder.Position = UDim2.new(0, 0, 0, 38)
    TabHolder.BackgroundColor3 = Theme.Panel
    TabHolder.BorderSizePixel = 0

    local ContentFrame = Instance.new("Frame", MainFrame)
    ContentFrame.Size = UDim2.new(1, -110, 1, -38)
    ContentFrame.Position = UDim2.new(0, 110, 0, 38)
    ContentFrame.BackgroundColor3 = Theme.Background
    ContentFrame.BorderSizePixel = 0

    local tabs = {}

    function UI:CreateTab(name)
        local Button = Instance.new("TextButton", TabHolder)
        Button.Size = UDim2.new(1, 0, 0, 36)
        Button.BackgroundColor3 = Theme.Panel
        Button.Text = name
        Button.Font = Enum.Font.GothamSemibold
        Button.TextColor3 = Theme.Text
        Button.TextSize = 16
        Button.BorderSizePixel = 0

        local TabContent = Instance.new("Frame", ContentFrame)
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false

        tabs[name] = TabContent

        Button.MouseButton1Click:Connect(function()
            for _, tab in pairs(tabs) do tab.Visible = false end
            TabContent.Visible = true
        end)

        if #TabHolder:GetChildren() == 2 then
            TabContent.Visible = true
        end

        local elements = {}

        function elements:CreateToggle(text, callback)
            local Frame = Instance.new("Frame", TabContent)
            Frame.Size = UDim2.new(1, -20, 0, 32)
            Frame.Position = UDim2.new(0, 10, 0, #TabContent:GetChildren() * 36)
            Frame.BackgroundTransparency = 1

            local Label = Instance.new("TextLabel", Frame)
            Label.Size = UDim2.new(0.7, 0, 1, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Theme.Text
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 16

            local Button = Instance.new("TextButton", Frame)
            Button.Size = UDim2.new(0.25, 0, 0.7, 0)
            Button.Position = UDim2.new(0.72, 0, 0.15, 0)
            Button.BackgroundColor3 = Theme.DarkAccent
            Button.Text = "OFF"
            Button.Font = Enum.Font.GothamBold
            Button.TextColor3 = Theme.Text
            Button.TextSize = 14
            Button.BorderSizePixel = 0

            local state = false
            Button.MouseButton1Click:Connect(function()
                state = not state
                Button.BackgroundColor3 = state and Theme.Accent or Theme.DarkAccent
                Button.Text = state and "ON" or "OFF"
                callback(state)
            end)
        end

        function elements:CreateSlider(text, min, max, default, callback)
            local Frame = Instance.new("Frame", TabContent)
            Frame.Size = UDim2.new(1, -20, 0, 40)
            Frame.Position = UDim2.new(0, 10, 0, #TabContent:GetChildren() * 40)
            Frame.BackgroundTransparency = 1

            local Label = Instance.new("TextLabel", Frame)
            Label.Size = UDim2.new(1, 0, 0.4, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text .. ": " .. default
            Label.TextColor3 = Theme.Text
            Label.Font = Enum.Font.Gotham
            Label.TextSize = 15

            local SliderBack = Instance.new("Frame", Frame)
            SliderBack.Size = UDim2.new(1, 0, 0, 10)
            SliderBack.Position = UDim2.new(0, 0, 0.6, 0)
            SliderBack.BackgroundColor3 = Theme.Panel
            SliderBack.BorderSizePixel = 0

            local Slider = Instance.new("Frame", SliderBack)
            Slider.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            Slider.BackgroundColor3 = Theme.Accent
            Slider.BorderSizePixel = 0
            Slider.Active = true
            Slider.Draggable = true

            Slider:GetPropertyChangedSignal("Position"):Connect(function()
                local pct = math.clamp(Slider.Position.X.Scale, 0, 1)
                local val = math.floor(min + pct * (max - min))
                Label.Text = text .. ": " .. val
                callback(val)
            end)
        end

        return elements
    end

    return UI
end

--========================================================--
--                 YOUR ESP / AIMBOT LOGIC
--========================================================--

local ESPEnabled = false
local AimbotEnabled = false
local SilentAimEnabled = false
local FOV = 100

-- ESP FOLDER
local ESPFolder = Instance.new("Folder", game.CoreGui)
ESPFolder.Name = "JalbirdESP"

local ESPBoxes = {}

local function createESP(player)
    if player == LocalPlayer then return end

    local box = Instance.new("BoxHandleAdornment")
    box.Size = Vector3.new(4, 6, 4)
    box.Transparency = 0.6
    box.Color3 = Theme.Red
    box.Adornee = nil
    box.ZIndex = 5
    box.AlwaysOnTop = true
    box.Visible = false
    box.Parent = ESPFolder

    ESPBoxes[player] = box

    RunService.Heartbeat:Connect(function()
        if ESPEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            box.Visible = hum and hum.Health > 0
            box.Adornee = player.Character.HumanoidRootPart
        else
            box.Visible = false
        end
    end)
end

for _, p in ipairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(createESP)

--========================================================--
--                CREATE DARK-TECH GUI
--========================================================--

local window = UI:CreateWindow("Jalbird • Dark-Tech GUI")

local MainTab = window:CreateTab("Features")
local SettingsTab = window:CreateTab("Settings")

MainTab:CreateToggle("ESP", function(v)
    ESPEnabled = v
end)

MainTab:CreateToggle("Aimbot", function(v)
    AimbotEnabled = v
    if v then SilentAimEnabled = false end
end)

MainTab:CreateToggle("Silent Aim", function(v)
    SilentAimEnabled = v
    if v then AimbotEnabled = false end
end)

SettingsTab:CreateSlider("FOV", 50, 300, 100, function(v)
    FOV = v
end)

print(" JAILBIRD,rivals gui has Loaded Successfully!")

