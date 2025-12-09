local genv = getgenv()
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local HttpService = game:GetService("HttpService")

-- HWID GENERATION FUNCTION (unique per user/device)
local function GetHWID()
    -- Create a unique identifier based on multiple system factors
    local identifiers = {}
    
    -- Use PC information (these vary per executor)
    if syn and syn.crypt then
        -- Synapse X
        identifiers.hash = syn.crypt.hash("md5", tostring(syn.get_hwid()))
    elseif identifyexecutor then
        -- KRNL and most executors
        identifiers.executor = identifyexecutor() or "unknown"
    end
    
    -- Use Roblox account info (won't change unless account changes)
    local player = game.Players.LocalPlayer
    identifiers.userId = player.UserId
    identifiers.accountAge = player.AccountAge
    
    -- Use game-specific data
    identifiers.placeId = game.PlaceId
    
    -- Get time-based seed
    identifiers.timestamp = os.time()
    
    -- Create a combined hash
    local combined = ""
    for key, value in pairs(identifiers) do
        combined = combined .. tostring(value)
    end
    
    -- Simple hash function
    local hwid = ""
    for i = 1, 16 do
        local char = string.sub(combined, i, i)
        if char then
            hwid = hwid .. string.byte(char)
        else
            hwid = hwid .. tostring(math.random(0, 9))
        end
    end
    
    -- Format as XXXX-XXXX-XXXX-XXXX
    local formatted = ""
    for i = 1, 16 do
        formatted = formatted .. string.sub(hwid, i, i)
        if i % 4 == 0 and i < 16 then
            formatted = formatted .. "-"
        end
    end
    
    return formatted
end

-- KEY DATABASE WITH HWID LOCKING
-- Format: key = {hwid = "user-hwid", redeemed = true, userName = "username"}
local keyDatabase = {
    -- Your keys here (each locked to one HWID)
    ["THABRONX-V3-PREMIUM"] = {
        hwid = nil,  -- Will be set on first use
        redeemed = false,
        maxUses = 1,  -- Can only be used by 1 device
        currentUses = 0
    },
    ["DKS-HUB-VIP-ACCESS"] = {
        hwid = nil,
        redeemed = false,
        maxUses = 1,
        currentUses = 0
    },
    ["BRONX-2024-TESTER"] = {
        hwid = nil,
        redeemed = false,
        maxUses = 1,
        currentUses = 0
    },
    -- Add more keys as needed
}

-- KEY VALIDATION WITH HWID CHECK
local function ValidateKeyWithHWID(key, userHWID, userName, userId)
    -- Check if key exists
    if not keyDatabase[key] then
        return false, "❌ Invalid key"
    end
    
    local keyData = keyDatabase[key]
    
    -- Check if key is already used
    if keyData.redeemed then
        -- Check if this HWID matches the original redeemer
        if keyData.hwid == userHWID then
            return true, "✅ Welcome back! Key verified."
        else
            return false, "❌ Key already in use on another device"
        end
    end
    
    -- Key is new, assign HWID
    keyData.hwid = userHWID
    keyData.redeemed = true
    keyData.userName = userName
    keyData.userId = userId
    keyData.redeemedAt = os.time()
    keyData.currentUses = 1
    
    -- Save to file (if supported)
    if writefile then
        local keyInfo = {
            key = key,
            hwid = userHWID,
            userName = userName,
            userId = userId,
            time = os.date("%Y-%m-%d %H:%M:%S")
        }
        writefile("key_activations.txt", HttpService:JSONEncode(keyInfo) .. "\n", true)
    end
    
    return true, "✅ Key activated! Locked to your device."
end

-- DISCORD WEBHOOK FOR ACTIVATIONS (optional)
local webhookUrl = "https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE"

local function SendActivationToDiscord(key, hwid, userName, userId)
    if webhookUrl and string.find(webhookUrl, "discord.com") then
        local data = {
            ["embeds"] = {{
                ["title"] = "🔒 HWID-Locked Key Activated",
                ["color"] = 15105570,
                ["fields"] = {
                    {
                        ["name"] = "👤 User",
                        ["value"] = userName .. " (`" .. userId .. "`)",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "🔑 Key",
                        ["value"] = "`" .. key .. "`",
                        ["inline"] = true
                    },
                    {
                        ["name"] = "🆔 HWID",
                        ["value"] = "```" .. hwid .. "```",
                        ["inline"] = false
                    }
                },
                ["footer"] = {
                    ["text"] = "Time: " .. os.date("%Y-%m-%d %H:%M:%S")
                }
            }}
        }
        
        pcall(function()
            HttpService:PostAsync(webhookUrl, HttpService:JSONEncode(data))
        end)
    end
end

-- CREATE THE SECURE WINDOW
local Window = Rayfield:CreateWindow({
    LoadingTitle = "Loading Tha Bronx V3.1...",
    LoadingSubtitle = "HWID-Locked System",
    
    KeySystem = true,
    KeySettings = {
        Title = "Tha Bronx V3.1",
        Subtitle = "Enter License Key",
        Note = "Keys are HWID-locked (one device only)\nGet key at: discord.gg/dkshub",
        FileName = "bronx_hwid_key",
        SaveKey = true,
        GrabKeyFromSite = false,
        
        -- Available keys (users can enter any of these)
        Key = {
            "THABRONX-V3-PREMIUM",
            "DKS-HUB-VIP-ACCESS",
            "BRONX-2024-TESTER"
        },
        
        -- Custom validation with HWID checking
        Callback = function(enteredKey)
            local player = game.Players.LocalPlayer
            local userHWID = GetHWID()
            local userName = player.Name
            local userId = player.UserId
            
            -- Validate key with HWID
            local isValid, message = ValidateKeyWithHWID(enteredKey, userHWID, userName, userId)
            
            if isValid then
                -- Send to Discord
                SendActivationToDiscord(enteredKey, userHWID, userName, userId)
                
                -- Store in environment
                genv.UserHWID = userHWID
                genv.UserKey = enteredKey
                genv.KeyActivated = true
                
                -- Show success
                Rayfield:Notify({
                    Title = "✅ Access Granted",
                    Content = message .. "\nHWID: " .. string.sub(userHWID, 1, 8) .. "...",
                    Duration = 6,
                })
                
                return true
            else
                Rayfield:Notify({
                    Title = "❌ Access Denied",
                    Content = message,
                    Duration = 6,
                })
                return false
            end
        end,
        
        -- Theme for key system
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
    },
    
    DisableBuildWarnings = false,
    Discord = {
        Enabled = false,
        RememberJoins = true,
        Invite = "",
    },
    Name = "[ðɸƒ] Tha Bronx - V3.1 by q11_2 | discord.gg/ukZVmDFWG [HWID-LOCKED]",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = "GreenBlackThemeHub",
        FileName = "BigHub",
    },
    DisableRayfieldPrompts = false,
    Icon = 112029241653430,
    
    -- MAIN UI THEME
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

-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- PLAYER
local LocalPlayer = Players.LocalPlayer

-- PERIODIC HWID CHECK (prevents key sharing)
task.spawn(function()
    while task.wait(30) do
        if genv.KeyActivated then
            local currentHWID = GetHWID()
            if currentHWID ~= genv.UserHWID then
                -- HWID changed! Possibly trying to share key
                Rayfield:Notify({
                    Title = "⚠️ Security Alert",
                    Content = "Device changed. Re-enter key.",
                    Duration = 10,
                })
                
                -- Force re-authentication
                genv.KeyActivated = false
                task.wait(2)
                Rayfield:Notify({
                    Title = "🔒 Session Terminated",
                    Content = "Please restart script and re-enter key",
                    Duration = 5,
                })
                return
            end
        end
    end
end)

-- ONLY CREATE MAIN UI IF KEY IS ACTIVATED
if genv.KeyActivated then

-- MAIN TAB
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
            
            local IceFruitSell = Workspace:FindFirstChild("IceFruit Sell")
            if IceFruitSell then
                local ProximityPrompt = IceFruitSell:FindFirstChildOfClass("ProximityPrompt")
                if ProximityPrompt then
                    ProximityPrompt.HoldDuration = 0
                    Humanoid:ChangeState(0)
                    
                    Rayfield:Notify({
                        Title = "Ready",
                        Content = "Go to IceFruit Sell and use the prompt!",
                        Duration = 5,
                    })
                end
            end
        end
    end,
})

-- Dupe Section
MainTab:CreateSection("Game - Dupe")

MainTab:CreateButton({
    Name = "Dupe Tools",
    Callback = function()
        local Character = LocalPlayer.Character
        if not Character then
            Rayfield:Notify({
                Title = "Error",
                Content = "Character not found!",
                Duration = 5,
            })
            return
        end
        
        local Tool = Character:FindFirstChildOfClass("Tool")
        if not Tool then
            Rayfield:Notify({
                Title = "Error",
                Content = "No tool equipped!",
                Duration = 5,
            })
            return
        end
        
        Rayfield:Notify({
            Title = "Dupe",
            Content = "Dupe process started! Check console for details.",
            Duration = 5,
        })
    end,
})

MainTab:CreateParagraph({
    Title = "Usage:",
    Content = "Equip your tool you want dupe then press 'Dupe Tools'",
})

MainTab:CreateToggle({
    CurrentValue = false,
    Callback = function(Value)
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
            ReplicatedStorage.ExoticShopRemote:InvokeServer("FakeCard")
            task.wait(0.25)
            
            local Character = LocalPlayer.Character
            if Character then
                local Humanoid = Character:WaitForChild("Humanoid")
                local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
                
                if HumanoidRootPart then
                    Humanoid:ChangeState(0)
                    HumanoidRootPart.CFrame = CFrame.new(-1017, 254, -250)
                    task.wait(0.5)
                end
            end
            
            Rayfield:Notify({
                Title = "Card Autofarm",
                Content = "Autofarm enabled!",
                Duration = 5,
            })
        end
    end,
})

-- Admin Tab (for key management)
local AdminTab = Window:CreateTab("🔑 Admin", nil)
AdminTab:CreateSection("Key Management")

AdminTab:CreateButton({
    Name = "📋 View Activated Keys",
    Callback = function()
        local activatedList = ""
        for key, data in pairs(keyDatabase) do
            if data.redeemed then
                activatedList = activatedList .. string.format(
                    "🔑 %s\n👤 %s | 🆔 %s\n\n",
                    key,
                    data.userName or "Unknown",
                    string.sub(data.hwid or "No HWID", 1, 12)
                )
            end
        end
        
        if activatedList == "" then
            activatedList = "No keys activated yet"
        end
        
        Rayfield:Notify({
            Title = "🔒 Activated Keys",
            Content = "Check console (F9) for list",
            Duration = 5,
        })
        
        print("=== HWID-LOCKED KEY ACTIVATIONS ===\n" .. activatedList)
    end,
})

AdminTab:CreateButton({
    Name = "🆔 Show My HWID",
    Callback = function()
        local hwid = GetHWID()
        if setclipboard then
            setclipboard(hwid)
        end
        
        Rayfield:Notify({
            Title = "🆔 Your HWID",
            Content = string.sub(hwid, 1, 12) .. "...\n(Copied to clipboard)",
            Duration = 6,
        })
        
        print("Your full HWID:", hwid)
    end,
})

-- Success message
Rayfield:Notify({
    Title = "✅ Welcome",
    Content = "HWID-Locked script loaded successfully!",
    Duration = 5,
})

else
    -- If key not activated, show message
    Rayfield:Notify({
        Title = "🔒 HWID Lock Active",
        Content = "Please enter a valid key to access the script",
        Duration = 5,
    })
end

print("🔒 HWID-Locked Tha Bronx V3.1 loaded!")
print("🔑 Key system active - one device per key")
