-- 🧊 Ice Fruit Cup Auto-Seller
-- Obsidian UI Version

-- Load Obsidian UI
local Obsidian = loadstring(game:HttpGet("https://raw.githubusercontent.com/obsidian-ui/obsidian/main/src.lua"))()

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
    Obsidian:Notify({
        Title = "❌ Error",
        Description = "This script only works in The Bronx games",
        Duration = 5
    })
    return
end

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Create Obsidian Window
local Window = Obsidian:Window({
    Title = "🧊 Ice Fruit Cup Seller",
    SubTitle = "Kool Aid Farming Method",
    Size = UDim2.fromOffset(400, 500),
    Theme = "Dark"
})

-- Variables
local isRunning = false
local targetMoney = 990000
local sellAttempts = 0
local currentMoney = 0

-- Tabs
local MainTab = Window:Tab({
    Name = "Main",
    Icon = "dollar-sign"
})

local SettingsTab = Window:Tab({
    Name = "Settings",
    Icon = "settings"
})

local StatsTab = Window:Tab({
    Name = "Stats",
    Icon = "bar-chart"
})

-- Main Tab Content
local AutoSellSection = MainTab:Section({
    Name = "Auto Sell",
    Side = "Left"
})

local StatusLabel = AutoSellSection:Label({
    Text = "Status: Waiting for Ice Fruit Cupz...",
    Color = Color3.fromRGB(200, 200, 200)
})

local MoneyLabel = AutoSellSection:Label({
    Text = "Money: $0",
    Color = Color3.fromRGB(0, 255, 0)
})

local StartButton = AutoSellSection:Button({
    Name = "▶️ Start Auto-Sell",
    Callback = function()
        if isRunning then
            stopAutoSell()
            StartButton:Set("▶️ Start Auto-Sell")
        else
            startAutoSell()
            StartButton:Set("⏸️ Stop Auto-Sell")
        end
    end
})

local TargetSection = MainTab:Section({
    Name = "Target Settings",
    Side = "Right"
})

local TargetInput = TargetSection:TextBox({
    Name = "Target Money",
    Placeholder = "990000",
    Default = "990000",
    Callback = function(value)
        local num = tonumber(value)
        if num and num > 0 then
            targetMoney = num
            Obsidian:Notify({
                Title = "🎯 Target Updated",
                Description = "Target set to: $" .. tostring(targetMoney),
                Duration = 3
            })
        else
            TargetInput:Set("990000")
        end
    end
})

local MaxToggle = TargetSection:Toggle({
    Name = "Auto Max Money (1.6M)",
    Default = false,
    Callback = function(value)
        if value then
            targetMoney = 1600000
            TargetInput:Set("1600000")
            Obsidian:Notify({
                Title = "🎯 Max Target",
                Description = "Target set to $1,600,000",
                Duration = 3
            })
        end
    end
})

-- Settings Tab
local DetectionSection = SettingsTab:Section({
    Name = "Detection Settings",
    Side = "Left"
})

local ItemName = DetectionSection:TextBox({
    Name = "Item Name",
    Placeholder = "Ice Fruit Cupz",
    Default = "Ice Fruit Cupz",
    Callback = function(value)
        if value and #value > 0 then
            Obsidian:Notify({
                Title = "✅ Item Name",
                Description = "Looking for: " .. value,
                Duration = 3
            })
        end
    end
})

local ScanDelay = DetectionSection:Slider({
    Name = "Scan Delay",
    Default = 1,
    Minimum = 0.5,
    Maximum = 5,
    Decimals = 1,
    Suffix = "s",
    Callback = function(value)
        Obsidian:Notify({
            Title = "⏱️ Delay Set",
            Description = "Scanning every " .. value .. " seconds",
            Duration = 3
        })
    end
})

local SellingSection = SettingsTab:Section({
    Name = "Selling Settings",
    Side = "Right"
})

local AutoEquip = SellingSection:Toggle({
    Name = "Auto Equip Item",
    Default = true,
    Callback = function(value)
        Obsidian:Notify({
            Title = value and "✅ Auto Equip" : "❌ Auto Equip",
            Description = value and "Will auto equip items" : "Manual equipping",
            Duration = 3
        })
    end
})

local TeleportToBuyer = SellingSection:Toggle({
    Name = "Auto Teleport to Buyer",
    Default = true,
    Callback = function(value)
        Obsidian:Notify({
            Title = value and "✅ Auto Teleport" : "❌ Auto Teleport",
            Description = value and "Will teleport to buyer" : "Manual movement",
            Duration = 3
        })
    end
})

-- Stats Tab
local ProgressSection = StatsTab:Section({
    Name = "Progress",
    Side = "Left"
})

local ProgressBar = ProgressSection:ProgressBar({
    Name = "Money Progress",
    Default = 0,
    Minimum = 0,
    Maximum = 1600000,
    Decimals = 0,
    Callback = function(value)
        -- Progress bar updates automatically
    end
})

local StatsLabel1 = ProgressSection:Label({
    Text = "Cups Sold: 0",
    Color = Color3.fromRGB(100, 200, 255)
})

local StatsLabel2 = ProgressSection:Label({
    Text = "Current Money: $0",
    Color = Color3.fromRGB(0, 255, 0)
})

local StatsLabel3 = ProgressSection:Label({
    Text = "Target Money: $990,000",
    Color = Color3.fromRGB(255, 255, 100)
})

local EfficiencySection = StatsTab:Section({
    Name = "Efficiency",
    Side = "Right"
})

local TimeRunning = EfficiencySection:Label({
    Text = "Time Running: 0s",
    Color = Color3.fromRGB(200, 200, 200)
})

local CupsPerMinute = EfficiencySection:Label({
    Text = "Cups/Min: 0",
    Color = Color3.fromRGB(100, 255, 100)
})

local MoneyPerMinute = EfficiencySection:Label({
    Text = "$/Min: $0",
    Color = Color3.fromRGB(255, 200, 100)
})

-- Functions
function updateMoneyDisplay()
    -- Find money in the game (you need to update this)
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
    MoneyLabel:Set("Money: $" .. tostring(money))
    StatsLabel2:Set("Current Money: $" .. tostring(money))
    
    -- Update progress bar
    local progress = math.min(money, 1600000)
    ProgressBar:Set(progress)
    
    -- Update target label
    StatsLabel3:Set("Target Money: $" .. tostring(targetMoney))
    
    return money
end

function hasIceFruitCup()
    local itemName = ItemName:Get() or "Ice Fruit Cupz"
    
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

function findBuyer()
    -- You need to find the actual buyer NPC
    local buyerNames = {
        "Ice Buyer", "Fruit Buyer", "Cup Buyer", "Kool Aid Buyer",
        "Dealer", "Seller", "Trader", "Market"
    }
    
    for _, name in pairs(buyerNames) do
        local buyer = Workspace:FindFirstChild(name) or
                     Workspace.NPCs:FindFirstChild(name) or
                     Workspace.Folders:FindFirstChild(name)
        
        if buyer then
            return buyer
        end
    end
    
    return nil
end

function sellIceFruitCup()
    local iceCup = hasIceFruitCup()
    if not iceCup then
        StatusLabel:Set("Status: ❌ No Ice Fruit Cupz found")
        return false
    end
    
    local buyer = findBuyer()
    if not buyer then
        StatusLabel:Set("Status: ❌ No buyer found")
        Obsidian:Notify({
            Title = "❌ Buyer Not Found",
            Description = "Could not find buyer NPC",
            Duration = 5
        })
        return false
    end
    
    -- Equip item
    if AutoEquip:Get() and iceCup.Parent == LocalPlayer.Backpack then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:EquipTool(iceCup)
            task.wait(0.3)
        end
    end
    
    -- Teleport to buyer
    if TeleportToBuyer:Get() then
        local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local buyerHead = buyer:FindFirstChild("Head") or buyer:FindFirstChild("HumanoidRootPart")
        
        if humanoidRootPart and buyerHead then
            humanoidRootPart.CFrame = buyerHead.CFrame + Vector3.new(0, 0, -3)
            task.wait(0.5)
        end
    end
    
    -- Try to sell
    local success = false
    
    -- Method 1: Proximity Prompt
    local prompt = buyer:FindFirstChildWhichIsA("ProximityPrompt")
    if prompt then
        fireproximityprompt(prompt)
        success = true
    end
    
    -- Method 2: Remote Events
    if not success then
        local remoteNames = {
            "SellItem", "Sell", "Trade", "SellIceFruit", "SellCup",
            "MarketSell", "DealerSell", "SellRemote"
        }
        
        for _, remoteName in pairs(remoteNames) do
            local remote = ReplicatedStorage:FindFirstChild(remoteName)
            if remote then
                if remote:IsA("RemoteEvent") then
                    remote:FireServer(iceCup.Name)
                    success = true
                    break
                elseif remote:IsA("RemoteFunction") then
                    remote:InvokeServer(iceCup.Name)
                    success = true
                    break
                end
            end
        end
    end
    
    if success then
        sellAttempts = sellAttempts + 1
        StatsLabel1:Set("Cups Sold: " .. tostring(sellAttempts))
        StatusLabel:Set("Status: ✅ Sold cup #" .. tostring(sellAttempts))
        return true
    else
        StatusLabel:Set("Status: ❌ Could not sell")
        return false
    end
end

-- Timer variables
local startTime = 0
local lastCupTime = 0

function startAutoSell()
    if isRunning then return end
    
    isRunning = true
    startTime = tick()
    sellAttempts = 0
    lastCupTime = tick()
    
    Obsidian:Notify({
        Title = "🚀 Auto-Sell Started",
        Description = "Target: $" .. tostring(targetMoney),
        Duration = 5
    })
    
    spawn(function()
        while isRunning do
            -- Update money display
            local money = updateMoneyDisplay()
            
            -- Check if target reached
            if money >= targetMoney then
                StatusLabel:Set("Status: ✅ Target reached!")
                Obsidian:Notify({
                    Title = "🎉 Target Achieved",
                    Description = "Reached $" .. tostring(targetMoney),
                    Duration = 5
                })
                stopAutoSell()
                break
            end
            
            -- Try to sell
            if hasIceFruitCup() then
                if sellIceFruitCup() then
                    lastCupTime = tick()
                end
            else
                StatusLabel:Set("Status: 🔍 Looking for Ice Fruit Cupz...")
            end
            
            -- Update stats
            local timeRunning = math.floor(tick() - startTime)
            TimeRunning:Set("Time Running: " .. tostring(timeRunning) .. "s")
            
            if timeRunning > 0 then
                local cpm = math.floor((sellAttempts / timeRunning) * 60)
                local mpm = math.floor((currentMoney / timeRunning) * 60)
                CupsPerMinute:Set("Cups/Min: " .. tostring(cpm))
                MoneyPerMinute:Set("$/Min: $" .. tostring(mpm))
            end
            
            -- Wait for next scan
            local delay = ScanDelay:Get() or 1
            task.wait(delay)
        end
    end)
end

function stopAutoSell()
    isRunning = false
    StartButton:Set("▶️ Start Auto-Sell")
    StatusLabel:Set("Status: ⏸️ Stopped")
    
    Obsidian:Notify({
        Title = "⏸️ Auto-Sell Stopped",
        Description = "Sold " .. tostring(sellAttempts) .. " cups",
        Duration = 5
    })
end

-- Auto-update money
spawn(function()
    while true do
        updateMoneyDisplay()
        task.wait(3)
    end
end)

-- Initialization
Obsidian:Notify({
    Title = "🧊 Ice Fruit Cup Seller",
    Description = "Obsidian UI Loaded Successfully!",
    Duration = 5
})

print("Ice Fruit Cup Seller with Obsidian UI loaded!")
print("Instructions:")
print("1. Set the correct item name in Settings")
print("2. Find and note the buyer NPC name")
print("3. Set your target money")
print("4. Click Start Auto-Sell")
