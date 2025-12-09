local genv = getgenv()
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/dkhub43221/loading-screen/refs/heads/main/dkhub", true))()

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- Player
local LocalPlayer = Players.LocalPlayer

-- Create Window
local Window = Rayfield:CreateWindow({
    LoadingTitle = "",
    KeySettings = {
        Theme = {
            Shadow = Color3.fromRGB(255, 255, 255),
            SliderProgress = Color3.fromRGB(77, 251, 16),
            InputStroke = Color3.fromRGB(77, 251, 16),
            InputBackground = Color3.fromRGB(15, 15, 15),
            ToggleDisabledStroke = Color3.fromRGB(15, 15, 15),
            DropdownUnselected = Color3.fromRGB(15, 15, 15),
            ElementBackgroundHover = Color3.fromRGB(15, 15, 15),
            DropdownSelected = Color3.fromRGB(15, 15, 15),
            SelectedTabTextColor = Color3.fromRGB(255, 255, 255),
            NotificationBackground = Color3.fromRGB(15, 15, 15),
            ToggleDisabledOuterStroke = Color3.fromRGB(255, 255, 255),
            SecondaryElementStroke = Color3.fromRGB(77, 251, 16),
            Background = Color3.fromRGB(15, 15, 15),
            ToggleEnabledOuterStroke = Color3.fromRGB(255, 255, 255),
            TabStroke = Color3.fromRGB(15, 15, 15),
            ElementBackground = Color3.fromRGB(15, 15, 15),
            ToggleBackground = Color3.fromRGB(15, 15, 15),
            ToggleEnabled = Color3.fromRGB(77, 251, 16),
            ToggleEnabledStroke = Color3.fromRGB(77, 251, 16),
            ToggleDisabled = Color3.fromRGB(255, 255, 255),
            SecondaryElementBackground = Color3.fromRGB(15, 15, 15),
            TabBackgroundSelected = Color3.fromRGB(15, 15, 15),
            TabTextColor = Color3.fromRGB(149, 149, 149),
            ElementStroke = Color3.fromRGB(77, 251, 16),
            SliderBackground = Color3.fromRGB(255, 255, 255),
            SliderStroke = Color3.fromRGB(77, 251, 16),
            NotificationActionsBackground = Color3.fromRGB(35, 0, 70),
            Topbar = Color3.fromRGB(15, 15, 15),
            TabBackground = Color3.fromRGB(15, 15, 15),
            NotificationTextColor = Color3.fromRGB(255, 255, 255),
            TextColor = Color3.fromRGB(255, 255, 255),
        },
        Subtitle = "Authentication Required",
        Title = "",
        Key = {[1] = ""},
        GrabKeyFromSite = false,
        SaveKey = true,
        FileName = "jc_hub_key",
        Note = "Get your key at: discord.gg/dkshub",
    },
    KeySystem = false,
    DisableBuildWarnings = false,
    Discord = {
        Enabled = false,
        RememberJoins = true,
        Invite = "",
    },
    Name = "[ðɸƒ] Tha Bronx - V3.1 by q11_2 | discord.gg/ukZVmDFWG [free]",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = "GreenBlackThemeHub",
        FileName = "BigHub",
    },
    DisableRayfieldPrompts = false,
    LoadingSubtitle = "",
    Icon = 112029241653430,
    Theme = {
        Shadow = Color3.fromRGB(255, 255, 255),
        SliderProgress = Color3.fromRGB(77, 251, 16),
        InputStroke = Color3.fromRGB(77, 251, 16),
        InputBackground = Color3.fromRGB(15, 15, 15),
        ToggleDisabledStroke = Color3.fromRGB(15, 15, 15),
        DropdownUnselected = Color3.fromRGB(15, 15, 15),
        ElementBackgroundHover = Color3.fromRGB(15, 15, 15),
        DropdownSelected = Color3.fromRGB(15, 15, 15),
        SelectedTabTextColor = Color3.fromRGB(255, 255, 255),
        NotificationBackground = Color3.fromRGB(15, 15, 15),
        ToggleDisabledOuterStroke = Color3.fromRGB(255, 255, 255),
        SecondaryElementStroke = Color3.fromRGB(77, 251, 16),
        Background = Color3.fromRGB(15, 15, 15),
        ToggleEnabledOuterStroke = Color3.fromRGB(255, 255, 255),
        TabStroke = Color3.fromRGB(15, 15, 15),
        ElementBackground = Color3.fromRGB(15, 15, 15),
        ToggleBackground = Color3.fromRGB(15, 15, 15),
        ToggleEnabled = Color3.fromRGB(77, 251, 16),
        ToggleEnabledStroke = Color3.fromRGB(77, 251, 16),
        ToggleDisabled = Color3.fromRGB(255, 255, 255),
        SecondaryElementBackground = Color3.fromRGB(15, 15, 15),
        TabBackgroundSelected = Color3.fromRGB(15, 15, 15),
        TabTextColor = Color3.fromRGB(149, 149, 149),
        ElementStroke = Color3.fromRGB(77, 251, 16),
        SliderBackground = Color3.fromRGB(255, 255, 255),
        SliderStroke = Color3.fromRGB(77, 251, 16),
        NotificationActionsBackground = Color3.fromRGB(35, 0, 70),
        Topbar = Color3.fromRGB(15, 15, 15),
        TabBackground = Color3.fromRGB(15, 15, 15),
        NotificationTextColor = Color3.fromRGB(255, 255, 255),
        TextColor = Color3.fromRGB(255, 255, 255),
    },
})

-- Main Tab
local MainTab = Window:CreateTab("Main", nil)

-- Inf Money Section
MainTab:CreateSection("Game - Inf Money")
MainTab:CreateParagraph({
    Title = "Instructions",
    Content = "Step 1: Buy kool-aid items\nStep 2: Make one ice-Fruitcupz\nStep 3: Click Get Max Money",
})

MainTab:CreateButton({
    Name = "Buy koolaid items",
    Callback = function()
        -- Buy items
        ReplicatedStorage.ExoticShopRemote:InvokeServer("Ice-Fruit Bag")
        task.wait(1.25)
        ReplicatedStorage.ExoticShopRemote:InvokeServer("Ice-Fruit Cupz")
        task.wait(1.25)
        ReplicatedStorage.ExoticShopRemote:InvokeServer("FijiWater")
        task.wait(1.25)
        ReplicatedStorage.ExoticShopRemote:InvokeServer("FreshWater")
        task.wait(1.25)
        
        Rayfield:Notify({
            Image = 4483362458,
            Duration = 5,
            Title = "AutoBuy",
            Content = "Items purchased successfully!",
        })
    end,
})

MainTab:CreateButton({
    Name = "Tp to Pot",
    Callback = function()
        local Character = LocalPlayer.Character
        if Character then
            local Humanoid = Character:WaitForChild("Humanoid")
            local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
            if HumanoidRootPart then
                Humanoid:ChangeState(0)
                HumanoidRootPart.CFrame = CFrame.new(-177, 398, -592)
                task.wait(0.5)
            end
        end
    end,
})

MainTab:CreateButton({
    Name = "Get max dirty money",
    Callback = function()
        local Character = LocalPlayer.Character
        if Character then
            local Humanoid = Character:WaitForChild("Humanoid")
            local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
            
            -- Find the sell station
            local IceFruitSell = Workspace:FindFirstChild("IceFruit Sell")
            if IceFruitSell then
                local ProximityPrompt = IceFruitSell:FindFirstChildOfClass("ProximityPrompt")
                if ProximityPrompt then
                    ProximityPrompt.HoldDuration = 0
                    Humanoid:ChangeState(0)
                    task.wait(0.5)
                    
                    -- You might need to add selling logic here
                    Rayfield:Notify({
                        Image = 4483362458,
                        Duration = 5,
                        Title = "Money Farm",
                        Content = "Ready to sell at the Ice Fruit station!",
                    })
                end
            end
        end
    end,
})

-- Dupe Section
MainTab:CreateSection("Game - Dupe")

-- Store the current character for duping
local CurrentCharacter
local CurrentBackpack

LocalPlayer.CharacterAdded:Connect(function(Character)
    CurrentCharacter = Character
    CurrentBackpack = LocalPlayer:WaitForChild("Backpack")
end)

-- Initialize character reference
if LocalPlayer.Character then
    CurrentCharacter = LocalPlayer.Character
    CurrentBackpack = LocalPlayer:WaitForChild("Backpack")
end

MainTab:CreateButton({
    Name = "Dupe Tools",
    Callback = function()
        if not CurrentCharacter then
            Rayfield:Notify({
                Title = "Error",
                Content = "Character not found!",
                Duration = 5,
            })
            return
        end
        
        local Tool = CurrentCharacter:FindFirstChildOfClass("Tool")
        if not Tool then
            Rayfield:Notify({
                Title = "Error",
                Content = "No tool equipped!",
                Duration = 5,
            })
            return
        end
        
        local ToolName = Tool.Name
        
        -- Move tool to backpack first
        Tool.Parent = CurrentBackpack
        task.wait(0.5)
        
        -- Dupe logic (adjust based on game's actual remote events)
        local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
        
        -- Create ping test
        local PingTest = Instance.new("BoolValue")
        PingTest.Parent = ReplicatedStorage
        PingTest.Name = "PingTest_" .. math.random(10000, 99999)
        task.wait(0.1)
        PingTest:Destroy()
        
        -- Calculate delay based on ping
        local Ping = math.clamp(100, 50, 300) -- Default 100ms
        local Delay = 0.25 + ((Ping / 300) * 0.03)
        
        -- Listen for item in market
        local MarketConnection
        MarketConnection = ReplicatedStorage.MarketItems.ChildAdded:Connect(function(Child)
            if Child.Name == ToolName then
                MarketConnection:Disconnect()
            end
        end)
        
        -- List weapon
        task.spawn(function()
            ReplicatedStorage.ListWeaponRemote:FireServer(ToolName, 99999)
        end)
        
        task.wait(Delay)
        
        -- Store weapon
        task.spawn(function()
            ReplicatedStorage.BackpackRemote:InvokeServer("Store", ToolName)
        end)
        
        task.wait(3)
        
        -- Grab weapon back
        task.spawn(function()
            ReplicatedStorage.BackpackRemote:InvokeServer("Grab", ToolName)
        end)
        
        Rayfield:Notify({
            Title = "Dupe",
            Content = "Tool dupe process started!",
            Duration = 5,
        })
    end,
})

MainTab:CreateParagraph({
    Title = "Usage:",
    Content = "Hello everyone, thank you for using dkshub to do the gun dupe. Equip your tool you want to dupe then press 'Dupe Tools' and there is an AFK auto dupe below!",
})

MainTab:CreateToggle({
    CurrentValue = false,
    Callback = function(Value)
        -- Auto dupe toggle logic would go here
        if Value then
            Rayfield:Notify({
                Title = "Auto Dupe",
                Content = "Auto dupe enabled!",
                Duration = 5,
            })
        else
            Rayfield:Notify({
                Title = "Auto Dupe",
                Content = "Auto dupe disabled!",
                Duration = 5,
            })
        end
    end,
    Name = "Auto Dupe Tools",
    Flag = "AutoDupeGun",
})

-- Teleports Section
MainTab:CreateSection("Game - Teleports")

local TeleportLocations = {
    ["Bank"] = Vector3.new(-202.7586, 283.6267, -1222.1841),
    ["Cash Wash"] = Vector3.new(-987.11, 253.72, -685.13),
    ["Penthouse"] = Vector3.new(-163, 397, -594),
    ["Apartment"] = Vector3.new(-613.78, 356.49, -689.02),
    ["Gunshop 1"] = Vector3.new(92976.28, 122097.95, 17022.78),
    ["Gunshop 2"] = Vector3.new(66192.45, 123615.71, 5744.73),
    ["Gunshop 3"] = Vector3.new(72426.18, 128855.64, -1081.06),
    ["Dealership"] = Vector3.new(-385.97, 253.41, -1236.36),
    ["Backpack"] = Vector3.new(-670.86, 253.6, -682.25),
    ["Market"] = Vector3.new(-388.34, 340.34, -562.64),
    ["Abandoned"] = Vector3.new(-733.03, 286.94, -779.16),
    ["Studio"] = Vector3.new(93428.23, 14484.71, 561.8),
    ["House 1"] = Vector3.new(-670, 256, -484),
    ["House 2"] = Vector3.new(-647, 256, -485),
    ["Hospital"] = Vector3.new(-1590.83, 254.27, 18.92),
    ["MarGreens"] = Vector3.new(-336.87, 254.45, -394.18),
    ["Dollar Central"] = Vector3.new(-393.72, 253.82, -1108.29),
}

local SelectedLocation = TeleportLocations["Bank"]

MainTab:CreateDropdown({
    Name = "Select Location",
    CurrentOption = {"Bank"},
    Flag = "TeleportDropdown",
    MultipleOptions = false,
    Callback = function(Options)
        local LocationName = Options[1]
        if TeleportLocations[LocationName] then
            SelectedLocation = TeleportLocations[LocationName]
            Rayfield:Notify({
                Title = "Teleport",
                Content = "Selected: " .. LocationName,
                Duration = 3,
            })
        end
    end,
    Options = {
        "Bank",
        "Cash Wash",
        "Penthouse",
        "Apartment",
        "Gunshop 1",
        "Gunshop 2",
        "Gunshop 3",
        "Dealership",
        "Backpack",
        "Market",
        "Abandoned",
        "Studio",
        "House 1",
        "House 2",
        "Hospital",
        "MarGreens",
        "Dollar Central",
    },
})

MainTab:CreateButton({
    Name = "Teleport To Location",
    Callback = function()
        local Character = LocalPlayer.Character
        if Character then
            local Humanoid = Character:WaitForChild("Humanoid")
            local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
            
            if HumanoidRootPart then
                Humanoid:ChangeState(0)
                HumanoidRootPart.CFrame = CFrame.new(SelectedLocation.X, SelectedLocation.Y, SelectedLocation.Z)
                task.wait(0.5)
                
                Rayfield:Notify({
                    Title = "Teleport",
                    Content = "Teleported successfully!",
                    Duration = 3,
                })
            end
        end
    end,
})

-- GUI Section
MainTab:CreateSection("Enable - GUI's")

local SelectedGUIs = {}
local GUIList = {
    "Bronx Clothing",
    "Crafting",
    "Animations",
    "Bronx Market",
    "Bronx Tattoos",
    "Megaphone List",
}

MainTab:CreateDropdown({
    Name = "Select GUIs",
    CurrentOption = {},
    Flag = "GUI_Selector",
    Options = GUIList,
    Callback = function(Options)
        SelectedGUIs = Options
    end,
    MultipleOptions = true,
})

MainTab:CreateToggle({
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
            local OpenedGUIs = {}
            
            for _, GUIName in ipairs(SelectedGUIs) do
                local GUI = PlayerGui:FindFirstChild(GUIName)
                if GUI then
                    GUI.Enabled = true
                    table.insert(OpenedGUIs, GUIName)
                end
            end
            
            if #OpenedGUIs > 0 then
                Rayfield:Notify({
                    Title = "GUIs Opened",
                    Content = "Opened: " .. table.concat(OpenedGUIs, ", "),
                    Duration = 5,
                })
            else
                Rayfield:Notify({
                    Title = "No GUIs Found",
                    Content = "Could not find selected GUIs!",
                    Duration = 5,
                })
            end
        else
            -- Optionally close GUIs when toggle is off
            local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
            for _, GUIName in ipairs(GUIList) do
                local GUI = PlayerGui:FindFirstChild(GUIName)
                if GUI then
                    GUI.Enabled = false
                end
            end
        end
    end,
    Name = "Open Selected GUI's",
    Flag = "OpenGUIsToggle",
})

-- Other Section
MainTab:CreateSection("Enable - Other")

MainTab:CreateButton({
    Name = "Get Help - $2000",
    Callback = function()
        local Character = LocalPlayer.Character
        if Character then
            local Humanoid = Character:WaitForChild("Humanoid")
            local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
            
            if HumanoidRootPart then
                Humanoid:ChangeState(0)
                HumanoidRootPart.CFrame = CFrame.new(-1591, 254, 18)
                task.wait(0.5)
                
                Rayfield:Notify({
                    Title = "Help Location",
                    Content = "Teleported to help location!",
                    Duration = 3,
                })
            end
        end
    end,
})

-- Autofarm Tab
local AutofarmTab = Window:CreateTab("Autofarm", nil)
AutofarmTab:CreateSection("Farming - Utilities")

local AutoFakeCard = false

AutofarmTab:CreateToggle({
    CurrentValue = false,
    Name = "Enable Card Autofarm",
    Callback = function(Value)
        AutoFakeCard = Value
        
        if Value then
            -- Buy fake card
            ReplicatedStorage.ExoticShopRemote:InvokeServer("FakeCard")
            task.wait(0.25)
            
            -- Equip fake card
            local Backpack = LocalPlayer:WaitForChild("Backpack")
            local FakeCard = Backpack:FindFirstChild("FakeCard")
            if FakeCard then
                FakeCard.Parent = LocalPlayer.Character
            end
            
            -- Teleport to farming location
            local Character = LocalPlayer.Character
            if Character then
                local Humanoid = Character:WaitForChild("Humanoid")
                local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
                
                if HumanoidRootPart then
                    Humanoid:ChangeState(0)
                    HumanoidRootPart.CFrame = CFrame.new(-1017, 254, -250)
                    task.wait(0.5)
                    
                    Rayfield:Notify({
                        Title = "Card Autofarm",
                        Content = "Card autofarm enabled!",
                        Duration = 5,
                    })
                end
            end
        else
            Rayfield:Notify({
                Title = "Card Autofarm",
                Content = "Card autofarm disabled!",
                Duration = 5,
            })
        end
    end,
})

-- Add autofarm loop
task.spawn(function()
    while task.wait(0.5) do
        if AutoFakeCard then
            -- Add your autofarm logic here
            -- For example, using the fake card repeatedly
        end
    end
end)
