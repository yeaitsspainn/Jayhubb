--========================================================--
--  JALBIRD DARK-TECH UI (Working Version)
--========================================================--

--// SERVICES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

--// THEME
local Theme = {
    Background = Color3.fromRGB(15, 15, 15),
    Panel = Color3.fromRGB(25, 25, 25),
    Accent = Color3.fromRGB(0, 150, 255),
    DarkAccent = Color3.fromRGB(0, 100, 180),
    Text = Color3.fromRGB(220, 220, 220),
    Red = Color3.fromRGB(255, 70, 70)
}

--========================================================--
-- WORKING CUSTOM UI LIBRARY
--========================================================--

local UI = {}

function UI:CreateWindow(title)
    -- ScreenGui FIX
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.Name = "JalbirdDarkTech"

    -- MAIN FRAME
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 450, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0

    -- TITLE BAR
    local TitleBar = Instance.new("Frame", MainFrame)
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Theme.Panel
    TitleBar.BorderSizePixel = 0

    local Title = Instance.new("TextLabel", TitleBar)
    Title.Size = UDim2.new(1, -10, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.Text = "⚙️  " .. title
    Title.Font = Enum.Font.GothamBold
    Title.TextColor3 = Theme.Text
    Title.TextSize = 18
    Title.BackgroundTransparency = 1
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- FULLY WORKING DRAGGING FIX
    local dragging = false
    local dragStart, startPos

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
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)


    -- TAB HOLDER
    local TabHolder = Instance.new("Frame", MainFrame)
    TabHolder.Size = UDim2.new(0, 120, 1, -40)
    TabHolder.Position = UDim2.new(0, 0, 0, 40)
    TabHolder.BackgroundColor3 = Theme.Panel
    TabHolder.BorderSizePixel = 0

    -- CONTENT AREA
    local Content = Instance.new("Frame", MainFrame)
    Content.Size = UDim2.new(1, -120, 1, -40)
    Content.Position = UDim2.new(0, 120, 0, 40)
    Content.BackgroundColor3 = Theme.Background
    Content.BorderSizePixel = 0

    local Tabs = {}

    function UI:CreateTab(tabName)
        local TabBtn = Instance.new("TextButton", TabHolder)
        TabBtn.Size = UDim2.new(1, 0, 0, 38)
        TabBtn.BackgroundColor3 = Theme.Panel
        TabBtn.BorderSizePixel = 0
        TabBtn.Text = tabName
        TabBtn.Font = Enum.Font.GothamSemibold
        TabBtn.TextColor3 = Theme.Text
        TabBtn.TextSize = 15

        local TabFrame = Instance.new("Frame", Content)
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.Visible = false
        TabFrame.BackgroundTransparency = 1

        Tabs[tabName] = TabFrame

        -- Switch tabs
        TabBtn.MouseButton1Click:Connect(function()
            for _, tab in pairs(Tabs) do tab.Visible = false end
            TabFrame.Visible = true
        end)

        if #Content:GetChildren() == 1 then
            TabFrame.Visible = true
        end

        local function yOffset()
            return (#TabFrame:GetChildren() * 40)
        end

        local tabAPI = {}

        function tabAPI:CreateToggle(text, callback)
            local frame = Instance.new("Frame", TabFrame)
            frame.Size = UDim2.new(1, -20, 0, 35)
            frame.Position = UDim2.new(0, 10, 0, yOffset())
            frame.BackgroundTransparency = 1

            local label = Instance.new("TextLabel", frame)
            label.Size = UDim2.new(0.7, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.Font = Enum.Font.Gotham
            label.TextSize = 15
            label.TextColor3 = Theme.Text

            local btn = Instance.new("TextButton", frame)
            btn.Size = UDim2.new(0.25, 0, 0.7, 0)
            btn.Position = UDim2.new(0.73, 0, 0.15, 0)
            btn.BackgroundColor3 = Theme.DarkAccent
            btn.BorderSizePixel = 0
            btn.Text = "OFF"
            btn.TextColor3 = Theme.Text
            btn.TextSize = 13

            local state = false

            btn.MouseButton1Click:Connect(function()
                state = not state
                btn.BackgroundColor3 = state and Theme.Accent or Theme.DarkAccent
                btn.Text = state and "ON" or "OFF"
                callback(state)
            end)
        end

        function tabAPI:CreateSlider(text, min, max, default, callback)
            local frame = Instance.new("Frame", TabFrame)
            frame.Size = UDim2.new(1, -20, 0, 55)
            frame.Position = UDim2.new(0, 10, 0, yOffset())
            frame.BackgroundTransparency = 1

            local label = Instance.new("TextLabel", frame)
            label.Size = UDim2.new(1, 0, 0, 22)
            label.BackgroundTransparency = 1
            label.Text = text .. ": " .. default
            label.Font = Enum.Font.Gotham
            label.TextColor3 = Theme.Text
            label.TextSize = 15

            local bar = Instance.new("Frame", frame)
            bar.Size = UDim2.new(1, 0, 0, 10)
            bar.Position = UDim2.new(0, 0, 0.6, 0)
            bar.BackgroundColor3 = Theme.Panel
            bar.BorderSizePixel = 0

            local drag = Instance.new("Frame", bar)
            drag.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            drag.BackgroundColor3 = Theme.Accent
            drag.BorderSizePixel = 0

            local mouseDown = false

            bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    mouseDown = true
                end
            end)

            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    mouseDown = false
                end
            end)

            UIS.InputChanged:Connect(function(input)
                if mouseDown and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local pct = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                    drag.Size = UDim2.new(pct, 0, 1, 0)
                    local val = math.floor(min + pct * (max - min))
                    label.Text = text .. ": " .. val
                    callback(val)
                end
            end)
        end

        return tabAPI
    end

    return UI
end

--========================================================--
--   NOW GUI WILL ALWAYS LOAD — CREATE THE REAL UI
--========================================================--

local window = UI:CreateWindow("Jalbird Dark-Tech")

local Main = window:CreateTab("Main")
local Settings = window:CreateTab("Settings")

_G.ESP = false
_G.Aim = false
_G.Silent = false
_G.FOV = 100

Main:CreateToggle("ESP", function(v)
    _G.ESP = v
end)

Main:CreateToggle("Aimbot", function(v)
    _G.Aim = v
end)

Main:CreateToggle("Silent Aim", function(v)
    _G.Silent = v
end)

Settings:CreateSlider("FOV", 50, 300, 100, function(v)
    _G.FOV = v
end)

print("Jalbird Dark-Tech GUI Loaded ✔")
