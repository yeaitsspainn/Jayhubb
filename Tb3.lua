-- 🧊 Ice Fruit Cup Auto-Seller
-- Self-Contained UI Version

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Game check
local GameId = game.PlaceId
local validGames = {
    18642421777, -- The Bronx
    16472538603, -- The Bronx
    13643807539  -- South Bronx
}

local isValidGame = false
for _, id in pairs(validGames) do
    if GameId == id then
        isValidGame = true
        break
    end
end

if not isValidGame then
    LocalPlayer:Kick("❌ This script only works in The Bronx games")
    return
end

-- Create UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IceFruitSellerUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Main Container
local MainContainer = Instance.new("Frame")
MainContainer.Size = UDim2.new(0, 400, 0, 500)
MainContainer.Position = UDim2.new(0.5, -200, 0.5, -250)
MainContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainContainer.BackgroundTransparency = 0.1
MainContainer.BorderSizePixel = 0
MainContainer.Parent = ScreenGui

-- Corner rounding
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainContainer

-- Drop shadow
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 150, 255)
UIStroke.Thickness = 2
UIStroke.Transparency = 0.5
UIStroke.Parent = MainContainer

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
Header.BorderSizePixel = 0
Header.Parent = MainContainer

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Text = "🧊 ICE FRUIT CUP SELLER"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Text = "Kool Aid Farming Method"
Subtitle.Size = UDim2.new(1, 0, 0, 20)
Subtitle.Position = UDim2.new(0, 0, 1, -20)
Subtitle.BackgroundTransparency = 1
Subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 14
Subtitle.Parent = Header

-- Tabs Container
local TabsContainer = Instance.new("Frame")
TabsContainer.Size = UDim2.new(1, -20, 0, 40)
TabsContainer.Position = UDim2.new(0, 10, 0, 70)
TabsContainer.BackgroundTransparency = 1
TabsContainer.Parent = MainContainer

-- Tab Buttons
local Tabs = {}
local currentTab = "main"

local function createTabButton(name, text, xPos)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.3, 0, 1, 0)
    button.Position = UDim2.new(xPos, 0, 0, 0)
    button.Text = text
    button.TextColor3 = Color3.fromRGB(200, 200, 200)
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    button.AutoButtonColor = false
    button.Parent = TabsContainer
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        -- Update all buttons
        for _, tab in pairs(Tabs) do
            if tab.name == name then
                tab.button.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
                tab.button.TextColor3 = Color3.new(1, 1, 1)
                tab.content.Visible = true
                currentTab = name
            else
                tab.button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                tab.button.TextColor3 = Color3.fromRGB(200, 200, 200)
                tab.content.Visible = false
            end
        end
    end)
    
    return button
end

-- Create tabs
local mainTabButton = createTabButton("main", "🏠 Main", 0)
local settingsTabButton = createTabButton("settings", "⚙️ Settings", 0.33)
local statsTabButton = createTabButton("stats", "📊 Stats", 0.66)

-- Content Area
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, -20, 1, -140)
ContentContainer.Position = UDim2.new(0, 10, 0, 120)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainContainer

-- Main Tab Content
local MainContent = Instance.new("Frame")
MainContent.Size = UDim2.new(1, 0, 1, 0)
MainContent.BackgroundTransparency = 1
MainContent.Visible = true
MainContent.Parent = ContentContainer

-- Status Display
local StatusFrame = Instance.new("Frame")
StatusFrame.Size = UDim2.new(1, 0, 0, 40)
StatusFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
StatusFrame.Parent = MainContent

local StatusCorner = Instance.new("UICorner")
StatusCorner.CornerRadius = UDim.new(0, 8)
StatusCorner.Parent = StatusFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Text = "🔄 Status: Waiting..."
StatusLabel.Size = UDim2.new(1, -20, 1, 0)
StatusLabel.Position = UDim2.new(0, 10, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 14
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = StatusFrame

-- Money Display
local MoneyFrame = Instance.new("Frame")
MoneyFrame.Size = UDim2.new(1, 0, 0, 50)
MoneyFrame.Position = UDim2.new(0, 0, 0, 50)
MoneyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MoneyFrame.Parent = MainContent

local MoneyCorner = Instance.new("UICorner")
MoneyCorner.CornerRadius = UDim.new(0, 8)
MoneyCorner.Parent = MoneyFrame

local MoneyLabel = Instance.new("TextLabel")
MoneyLabel.Text = "💰 Money: $0"
MoneyLabel.Size = UDim2.new(1, -20, 1, 0)
MoneyLabel.Position = UDim2.new(0, 10, 0, 0)
MoneyLabel.BackgroundTransparency = 1
MoneyLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
MoneyLabel.Font = Enum.Font.GothamBold
MoneyLabel.TextSize = 18
MoneyLabel.TextXAlignment = Enum.TextXAlignment.Left
MoneyLabel.Parent = MoneyFrame

-- Progress Bar
local ProgressContainer = Instance.new("Frame")
ProgressContainer.Size = UDim2.new(1, 0, 0, 30)
ProgressContainer.Position = UDim2.new(0, 0, 0, 110)
ProgressContainer.BackgroundTransparency = 1
ProgressContainer.Parent = MainContent

local ProgressText = Instance.new("TextLabel")
ProgressText.Text = "Progress to target:"
ProgressText.Size = UDim2.new(1, 0, 0, 15)
ProgressText.BackgroundTransparency = 1
ProgressText.TextColor3 = Color3.fromRGB(200, 200, 200)
ProgressText.Font = Enum.Font.Gotham
ProgressText.TextSize = 12
ProgressText.TextXAlignment = Enum.TextXAlignment.Left
ProgressText.Parent = ProgressContainer

local ProgressBarBack = Instance.new("Frame")
ProgressBarBack.Size = UDim2.new(1, 0, 0, 10)
ProgressBarBack.Position = UDim2.new(0, 0, 0, 20)
ProgressBarBack.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
ProgressBarBack.Parent = ProgressContainer

local ProgressBarCorner = Instance.new("UICorner")
ProgressBarCorner.CornerRadius = UDim.new(1, 0)
ProgressBarCorner.Parent = ProgressBarBack

local ProgressBarFill = Instance.new("Frame")
ProgressBarFill.Size = UDim2.new(0, 0, 1, 0)
ProgressBarFill.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
ProgressBarFill.Parent = ProgressBarBack

local ProgressBarFillCorner = Instance.new("UICorner")
ProgressBarFillCorner.CornerRadius = UDim.new(1, 0)
ProgressBarFillCorner.Parent = ProgressBarFill

-- Target Input
local TargetFrame = Instance.new("Frame")
TargetFrame.Size = UDim2.new(1, 0, 0, 60)
TargetFrame.Position = UDim2.new(0, 0, 0, 150)
TargetFrame.BackgroundTransparency = 1
TargetFrame.Parent = MainContent

local TargetLabel = Instance.new("TextLabel")
TargetLabel.Text = "🎯 Target Money:"
TargetLabel.Size = UDim2.new(0.5, 0, 0, 20)
TargetLabel.BackgroundTransparency = 1
TargetLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
TargetLabel.Font = Enum.Font.Gotham
TargetLabel.TextSize = 14
TargetLabel.TextXAlignment = Enum.TextXAlignment.Left
TargetLabel.Parent = TargetFrame

local TargetInput = Instance.new("TextBox")
TargetInput.Size = UDim2.new(0.5, 0, 0, 30)
TargetInput.Position = UDim2.new(0.5, 0, 0, 0)
TargetInput.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
TargetInput.TextColor3 = Color3.new(1, 1, 1)
TargetInput.Font = Enum.Font.Gotham
TargetInput.TextSize = 14
TargetInput.Text = "990000"
TargetInput.PlaceholderText = "Enter amount"
TargetInput.Parent = TargetFrame

local TargetInputCorner = Instance.new("UICorner")
TargetInputCorner.CornerRadius = UDim.new(0, 6)
TargetInputCorner.Parent = TargetInput

-- Action Buttons
local ButtonContainer = Instance.new("Frame")
ButtonContainer.Size = UDim2.new(1, 0, 0, 100)
ButtonContainer.Position = UDim2.new(0, 0, 1, -100)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Parent = MainContent

local StartButton = Instance.new("TextButton")
StartButton.Size = UDim2.new(1, 0, 0, 40)
StartButton.Text = "🚀 START AUTO-SELL"
StartButton.TextColor3 = Color3.new(1, 1, 1)
StartButton.TextSize = 16
StartButton.Font = Enum.Font.GothamBold
StartButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
StartButton.Parent = ButtonContainer

local StartButtonCorner = Instance.new("UICorner")
StartButtonCorner.CornerRadius = UDim.new(0, 8)
StartButtonCorner.Parent = StartButton

local StopButton = Instance.new("TextButton")
StopButton.Size = UDim2.new(1, 0, 0, 40)
StopButton.Position = UDim2.new(0, 0, 0, 50)
StopButton.Text = "⏸️ STOP"
StopButton.TextColor3 = Color3.new(1, 1, 1)
StopButton.TextSize = 16
StopButton.Font = Enum.Font.GothamBold
StopButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
StopButton.Visible = false
StopButton.Parent = ButtonContainer

local StopButtonCorner = Instance.new("UICorner")
StopButtonCorner.CornerRadius = UDim.new(0, 8)
StopButtonCorner.Parent = StopButton

-- Settings Tab Content
local SettingsContent = Instance.new("Frame")
SettingsContent.Size = UDim2.new(1, 0, 1, 0)
SettingsContent.BackgroundTransparency = 1
SettingsContent.Visible = false
SettingsContent.Parent = ContentContainer

-- Item Name Setting
local ItemNameFrame = Instance.new("Frame")
ItemNameFrame.Size = UDim2.new(1, 0, 0, 60)
ItemNameFrame.BackgroundTransparency = 1
ItemNameFrame.Parent = SettingsContent

local ItemNameLabel = Instance.new("TextLabel")
ItemNameLabel.Text = "Item Name to Detect:"
ItemNameLabel.Size = UDim2.new(1, 0, 0, 20)
ItemNameLabel.BackgroundTransparency = 1
ItemNameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ItemNameLabel.Font = Enum.Font.Gotham
ItemNameLabel.TextSize = 14
ItemNameLabel.TextXAlignment = Enum.TextXAlignment.Left
ItemNameLabel.Parent = ItemNameFrame

local ItemNameInput = Instance.new("TextBox")
ItemNameInput.Size = UDim2.new(1, 0, 0, 30)
ItemNameInput.Position = UDim2.new(0, 0, 0, 25)
ItemNameInput.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
ItemNameInput.TextColor3 = Color3.new(1, 1, 1)
ItemNameInput.Font = Enum.Font.Gotham
ItemNameInput.TextSize = 14
ItemNameInput.Text = "Ice Fruit Cupz"
ItemNameInput.Parent = ItemNameFrame

local ItemNameCorner = Instance.new("UICorner")
ItemNameCorner.CornerRadius = UDim.new(0, 6)
ItemNameCorner.Parent = ItemNameInput

-- Buyer Name Setting
local BuyerNameFrame = Instance.new("Frame")
BuyerNameFrame.Size = UDim2.new(1, 0, 0, 60)
BuyerNameFrame.Position = UDim2.new(0, 0, 0, 70)
BuyerNameFrame.BackgroundTransparency = 1
BuyerNameFrame.Parent = SettingsContent

local BuyerNameLabel = Instance.new("TextLabel")
BuyerNameLabel.Text = "Buyer NPC Name:"
BuyerNameLabel.Size = UDim2.new(1, 0, 0, 20)
BuyerNameLabel.BackgroundTransparency = 1
BuyerNameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
BuyerNameLabel.Font = Enum.Font.Gotham
BuyerNameLabel.TextSize = 14
BuyerNameLabel.TextXAlignment = Enum.TextXAlignment.Left
BuyerNameLabel.Parent = BuyerNameFrame

local BuyerNameInput = Instance.new("TextBox")
BuyerNameInput.Size = UDim2.new(1, 0, 0, 30)
BuyerNameInput.Position = UDim2.new(0, 0, 0, 25)
BuyerNameInput.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
BuyerNameInput.TextColor3 = Color3.new(1, 1, 1)
BuyerNameInput.Font = Enum.Font.Gotham
BuyerNameInput.TextSize = 14
BuyerNameInput.Text = "Ice Buyer"
BuyerNameInput.PlaceholderText = "Enter buyer NPC name"
BuyerNameInput.Parent = BuyerNameFrame

local BuyerNameCorner = Instance.new("UICorner")
BuyerNameCorner.CornerRadius = UDim.new(0, 6)
BuyerNameCorner.Parent = BuyerNameInput

-- Scan Delay Setting
local DelayFrame = Instance.new("Frame")
DelayFrame.Size = UDim2.new(1, 0, 0, 60)
DelayFrame.Position = UDim2.new(0, 0, 0, 140)
DelayFrame.BackgroundTransparency = 1
DelayFrame.Parent = SettingsContent

local DelayLabel = Instance.new("TextLabel")
DelayLabel.Text = "Scan Delay (seconds):"
DelayLabel.Size = UDim2.new(1, 0, 0, 20)
DelayLabel.BackgroundTransparency = 1
DelayLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
DelayLabel.Font = Enum.Font.Gotham
DelayLabel.TextSize = 14
DelayLabel.TextXAlignment = Enum.TextXAlignment.Left
DelayLabel.Parent = DelayFrame

local DelayValue = Instance.new("TextLabel")
DelayValue.Text = "1.0"
DelayValue.Size = UDim2.new(0.2, 0, 0, 20)
DelayValue.Position = UDim2.new(0.8, 0, 0, 0)
DelayValue.BackgroundTransparency = 1
DelayValue.TextColor3 = Color3.fromRGB(0, 200, 255)
DelayValue.Font = Enum.Font.GothamBold
DelayValue.TextSize = 14
DelayValue.TextXAlignment = Enum.TextXAlignment.Right
DelayValue.Parent = DelayFrame

local DelaySlider = Instance.new("TextButton")
DelaySlider.Size = UDim2.new(1, 0, 0, 10)
DelaySlider.Position = UDim2.new(0, 0, 0, 25)
DelaySlider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
DelaySlider.Text = ""
DelaySlider.AutoButtonColor = false
DelaySlider.Parent = DelayFrame

local DelaySliderCorner = Instance.new("UICorner")
DelaySliderCorner.CornerRadius = UDim.new(1, 0)
DelaySliderCorner.Parent = DelaySlider

local DelaySliderFill = Instance.new("Frame")
DelaySliderFill.Size = UDim2.new(0.2, 0, 1, 0) -- 1.0 seconds default (0.2 of range)
DelaySliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
DelaySliderFill.Parent = DelaySlider

local DelaySliderFillCorner = Instance.new("UICorner")
DelaySliderFillCorner.CornerRadius = UDim.new(1, 0)
DelaySliderFillCorner.Parent = DelaySliderFill

-- Stats Tab Content
local StatsContent = Instance.new("Frame")
StatsContent.Size = UDim2.new(1, 0, 1, 0)
StatsContent.BackgroundTransparency = 1
StatsContent.Visible = false
StatsContent.Parent = ContentContainer

local StatsGrid = Instance.new("UIGridLayout")
StatsGrid.CellPadding = UDim2.new(0, 10, 0, 10)
StatsGrid.CellSize = UDim2.new(0.5, -5, 0, 60)
StatsGrid.Parent = StatsContent

-- Stats Labels
local statsLabels = {
    {name = "Cups Sold", value = "0", color = Color3.fromRGB(100, 200, 255)},
    {name = "Time Running", value = "0s", color = Color3.fromRGB(200, 200, 200)},
    {name = "Cups/Min", value = "0", color = Color3.fromRGB(100, 255, 100)},
    {name = "$/Min", value = "$0", color = Color3.fromRGB(255, 200, 100)},
    {name = "Success Rate", value = "0%", color = Color3.fromRGB(255, 150, 100)},
    {name = "Target", value = "$990,000", color = Color3.fromRGB(255, 255, 100)}
}

local statFrames = {}
for i, stat in ipairs(statsLabels) do
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.Parent = StatsContent
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 8)
    frameCorner.Parent = frame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Text = stat.name
    nameLabel.Size = UDim2.new(1, -10, 0, 20)
    nameLabel.Position = UDim2.new(0, 10, 0, 5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.TextSize = 12
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = frame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Text = stat.value
    valueLabel.Size = UDim2.new(1, -10, 0, 30)
    valueLabel.Position = UDim2.new(0, 10, 0, 25)
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextColor3 = stat.color
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 18
    valueLabel.TextXAlignment = Enum.TextXAlignment.Left
    valueLabel.Parent = frame
    
    statFrames[stat.name] = valueLabel
end

-- Store tabs
Tabs = {
    {name = "main", button = mainTabButton, content = MainContent},
    {name = "settings", button = settingsTabButton, content = SettingsContent},
    {name = "stats", button = statsTabButton, content = StatsContent}
}

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Parent = MainContainer

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseButton

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -70, 0, 5)
MinimizeButton.Text = "─"
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.TextSize = 18
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 180)
MinimizeButton.Parent = MainContainer

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(1, 0)
MinimizeCorner.Parent = MinimizeButton

-- Variables
local isRunning = false
local targetMoney = 990000
local sellAttempts = 0
local successfulSells = 0
local startTime = 0
local currentMoney = 0
local scanDelay = 1.0

-- Update stats function
function updateStat(name, value)
    if statFrames[name] then
        statFrames[name].Text = value
    end
end

-- Update money display
function updateMoneyDisplay()
    -- Find money (YOU NEED TO UPDATE THIS)
    local money = 0
    
    -- Common money locations
    if LocalPlayer:FindFirstChild("leaderstats") then
        local stats = LocalPlayer.leaderstats
        if stats:FindFirstChild("Money") then
            money = stats.Money.Value or 0
        elseif stats:FindFirstChild("Cash") then
            money = stats.Cash.Value or 0
        end
    end
    
    currentMoney = money
    MoneyLabel.Text = "💰 Money: $" .. tostring(money)
    
    -- Update progress bar
    local progress = math.min(money / targetMoney, 1)
    ProgressBarFill.Size = UDim2.new(progress, 0, 1, 0)
    
    -- Update stats
    updateStat("$/Min", "$" .. tostring(math.floor((money / math.max(1, tick() - startTime)) * 60)))
    
    return money
end

-- Check for Ice Fruit Cupz
function hasIceFruitCup()
    local itemName = ItemNameInput.Text
    
    -- Check backpack
    if LocalPlayer.Backpack then
        for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
            if item:IsA("Tool") and item.Name:lower():find(itemName:lower()) then
                return item
            end
        end
    end
    
    -- Check character
    if LocalPlayer.Character then
        for _, item in pairs(LocalPlayer.Character:GetChildren()) do
            if item:IsA("Tool") and item.Name:lower():find(itemName:lower()) then
                return item
            end
        end
    end
    
    return nil
end

-- Find buyer
function findBuyer()
    local buyerName = BuyerNameInput.Text
    
    -- Search in common locations
    local locations = {Workspace, Workspace.NPCs, Workspace.Folders, ReplicatedStorage}
    
    for _, location in pairs(locations) do
        if location then
            local buyer = location:FindFirstChild(buyerName)
            if buyer then
                return buyer
            end
        end
    end
    
    -- Try partial match
    for _, location in pairs(locations) do
        if location then
            for _, child in pairs(location:GetChildren()) do
                if child.Name:lower():find(buyerName:lower()) then
                    return child
                end
            end
        end
    end
    
    return nil
end

-- Sell function
function sellIceFruitCup()
    local iceCup = hasIceFruitCup()
    if not iceCup then
        StatusLabel.Text = "❌ No Ice Fruit Cupz found"
        return false
    end
    
    local buyer = findBuyer()
    if not buyer then
        StatusLabel.Text = "❌ Buyer not found: " .. BuyerNameInput.Text
        return false
    end
    
    StatusLabel.Text = "🔄 Selling..."
    
    -- Equip item
    if iceCup.Parent == LocalPlayer.Backpack then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:EquipTool(iceCup)
            task.wait(0.3)
        end
    end
    
    -- Try proximity prompt
    local prompt = buyer:FindFirstChildWhichIsA("ProximityPrompt")
    if prompt then
        fireproximityprompt(prompt)
        sellAttempts = sellAttempts + 1
        successfulSells = successfulSells + 1
        updateStat("Cups Sold", tostring(sellAttempts))
        StatusLabel.Text = "✅ Sold cup #" .. tostring(sellAttempts)
        return true
    end
    
    -- Try remote events
    local remoteNames = {"SellItem", "Sell", "Trade", "SellIceFruit", "SellCup"}
    
    for _, remoteName in pairs(remoteNames) do
        local remote = ReplicatedStorage:FindFirstChild(remoteName)
        if remote then
            if remote:IsA("RemoteEvent") then
                remote:FireServer(iceCup.Name)
                sellAttempts = sellAttempts + 1
                successfulSells = successfulSells + 1
                updateStat("Cups Sold", tostring(sellAttempts))
                StatusLabel.Text = "✅ Sold cup #" .. tostring(sellAttempts)
                return true
            elseif remote:IsA("RemoteFunction") then
                remote:InvokeServer(iceCup.Name)
                sellAttempts = sellAttempts + 1
                successfulSells = successfulSells + 1
                updateStat("Cups Sold", tostring(sellAttempts))
                StatusLabel.Text = "✅ Sold cup #" .. tostring(sellAttempts)
                return true
            end
        end
    end
    
    sellAttempts = sellAttempts + 1
    updateStat("Cups Sold", tostring(sellAttempts))
    StatusLabel.Text = "❌ Could not sell (check buyer name)"
    return false
end

-- Start auto-sell
function startAutoSell()
    if isRunning then return end
    
    isRunning = true
    startTime = tick()
    sellAttempts = 0
    successfulSells = 0
    
    StartButton.Visible = false
    StopButton.Visible = true
    
    StatusLabel.Text = "🚀 Auto-sell started!"
    
    spawn(function()
        while isRunning do
            -- Update money
            local money = updateMoneyDisplay()
            
            -- Check target
            if money >= targetMoney then
                StatusLabel.Text = "🎉 Target reached! $" .. tostring(targetMoney)
                stopAutoSell()
                break
            end
            
            -- Try to sell
            if hasIceFruitCup() then
                sellIceFruitCup()
            else
                StatusLabel.Text = "🔍 Looking for Ice Fruit Cupz..."
            end
            
            -- Update stats
            local timeRunning = math.floor(tick() - startTime)
            updateStat("Time Running", tostring(timeRunning) .. "s")
            
            if timeRunning > 0 then
                local cpm = math.floor((sellAttempts / timeRunning) * 60)
                local successRate = sellAttempts > 0 and math.floor((successfulSells / sellAttempts) * 100) or 0
                
                updateStat("Cups/Min", tostring(cpm))
                updateStat("Success Rate", tostring(successRate) .. "%")
            end
            
            updateStat("Target", "$" .. tostring(targetMoney))
            
            -- Wait
            task.wait(scanDelay)
        end
    end)
end

-- Stop auto-sell
function stopAutoSell()
    isRunning = false
    StartButton.Visible = true
    StopButton.Visible = false
    StatusLabel.Text = "⏸️ Auto-sell stopped"
end

-- Button events
StartButton.MouseButton1Click:Connect(startAutoSell)
StopButton.MouseButton1Click:Connect(stopAutoSell)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    MainContainer.Visible = not MainContainer.Visible
end)

-- Target input
TargetInput.FocusLost:Connect(function()
    local newTarget = tonumber(TargetInput.Text)
    if newTarget and newTarget > 0 then
        targetMoney = newTarget
        updateStat("Target", "$" .. tostring(targetMoney))
    else
        TargetInput.Text = "990000"
        targetMoney = 990000
    end
end)

-- Delay slider
local draggingDelay = false
DelaySlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingDelay = true
    end
end)

DelaySlider.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingDelay = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if draggingDelay and input.UserInputType == Enum.UserInputType.MouseMovement then
        local relativeX = (input.Position.X - DelaySlider.AbsolutePosition.X) / DelaySlider.AbsoluteSize.X
        relativeX = math.clamp(relativeX, 0, 1)
        
        -- Map 0-1 to 0.5-5 seconds
        scanDelay = 0.5 + (relativeX * 4.5)
        DelaySliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        DelayValue.Text = string.format("%.1f", scanDelay)
    end
end)

-- Make draggable
local dragging
local dragStart
local startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainContainer.Position
    end
end)

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        -- Keep reference
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainContainer.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Auto-update money
spawn(function()
    while ScreenGui.Parent do
        updateMoneyDisplay()
        task.wait(2)
    end
end)

-- Initial setup
updateStat("Target", "$" .. tostring(targetMoney))

-- Notification
game.StarterGui:SetCore("SendNotification", {
    Title = "🧊 Ice Fruit Cup Seller",
    Text = "UI Loaded! Set buyer name in Settings tab",
    Duration = 5
})

print("✅ Ice Fruit Cup Seller loaded!")
print("📝 Instructions:")
print("1. Go to Settings tab")
print("2. Set the buyer NPC name")
print("3. Adjust target money if needed")
print("4. Click START AUTO-SELL")
print("5. Make Ice Fruit Cupz and let it auto-sell!")
