ocal genv = getgenv()
local _5 = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/dkhub43221/loading-screen/refs/heads/main/dkhub", true))()
local _call73 = game:GetService("Players")
local _LocalPlayer74 = _call73.LocalPlayer
game:GetService("UserInputService")
game:GetService("TweenService")
game:GetService("RunService")
local _call82 = game:GetService("ReplicatedStorage")
local _call84 = game:GetService("Workspace")
game:GetService("ProximityPromptService")
game:GetService("VirtualUser")
local _ = _call84.CurrentCamera
game:GetService("HttpService")
local _call93 = _5:CreateWindow({
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
        Key = {
            [1] = "",
        },
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
    Name = "[\xC3\xB0\xC5\xB8\xC5\xBD\xC6\x92] Tha Bronx - V3.1 by q11_2 | discord.gg/ukZVmDFWG [free]",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = "GreenBlackThemeHub",
        FileName = "BigHub",
    },
    DisableRayfieldPrompts = false,
    LoadingSubtitle = "",
    Icon = 112029241653430,
    Theme = {
        "<25ms:repeating table structure>"
    },
})
local _call95 = _call93:CreateTab("Main", nil)
_call95:CreateSection("Game - Inf Money")
_call95:CreateParagraph({
    Title = "Instructions",
    Content = "Step 1: Buy kool-aid items\xC3\xB0\xC5\xB8\xC2\xA5\xC2\xA4\nStep 2: Make one ice-Fruitcupz\xC3\xB0\xC5\xB8\xC2\xA7\xC5\xA0\xC3\xB0\xC5\xB8\xC2\xA5\xC2\xA4\nStep 3: Click Get Max Money\xC3\xB0\xC5\xB8\xE2\x80\x99\xC2\xB8",
})
_call95:CreateButton({
    Name = "Buy koolaid items",
    Callback = function(_102, _102_2, _102_3, _102_4, _102_5)
        local _ = _call82.ExoticStock:FindFirstChild("Ice-Fruit Bag").Value
        local _ = _call82.ExoticStock:FindFirstChild("Ice-Fruit Cupz").Value
        local _ = _call82.ExoticStock:FindFirstChild("FijiWater").Value
        local _ = _call82.ExoticStock:FindFirstChild("FreshWater").Value
        _call82.ExoticShopRemote:InvokeServer("Ice-Fruit Bag")
        task.wait(1.25)
        _call82.ExoticShopRemote:InvokeServer("Ice-Fruit Cupz")
        task.wait(1.25)
        _call82.ExoticShopRemote:InvokeServer("FijiWater")
        task.wait(1.25)
        _call82.ExoticShopRemote:InvokeServer("FreshWater")
        task.wait(1.25)
        _LocalPlayer74.Backpack:FindFirstChild("Ice-Fruit Bag")
        _LocalPlayer74.Backpack:FindFirstChild("Ice-Fruit Cupz")
        _LocalPlayer74.Backpack:FindFirstChild("FijiWater")
        _LocalPlayer74.Backpack:FindFirstChild("FreshWater")
        _5:Notify({
            Image = 4483362458,
            Duration = 5,
            Title = "AutoBuy",
            Content = "Items purchased successfully!",
        })
    end,
})
_call95:CreateButton({
    Name = "Tp to Pot",
    Callback = function(_147, _147_2, _147_3, _147_4)
        local _Character150 = _LocalPlayer74.Character
        local _call152 = _Character150:WaitForChild("Humanoid")
        local hrp = _Character150:WaitForChild("HumanoidRootPart")
        _call152:ChangeState(0)
        hrp.CFrame = CFrame.new(-177, 398, -592)
        task.wait(0.5)
    end,
})
_call95:CreateButton({
    Name = "Get max dirty money",
    Callback = function(_636, _636_2, _636_3)
        local _Character637 = _LocalPlayer74.Character
        local _call639 = _Character637:WaitForChild("Humanoid")
        local _ = _Character637:WaitForChild("HumanoidRootPart").Position
        local _call646 = _call84:FindFirstChild("IceFruit Sell"):FindFirstChildOfClass("ProximityPrompt")
        _call646.HoldDuration = 0
        _call639:ChangeState(0)
        task.wait(0.5)
    end,
})
_call95:CreateSection("Game - Dupe")
local _callcloneref669 = cloneref(_call82)
local _LocalPlayer671 = cloneref(_call73).LocalPlayer
local _ = _LocalPlayer671.Character
_LocalPlayer671:WaitForChild("Backpack")
_LocalPlayer671.CharacterAdded:Connect(function(_678, _678_2, _678_3, _678_4, _678_5)
    local _ = _LocalPlayer671.Character
end)
task.spawn(function(_684, _684_2, _684_3, _684_4)
    task.wait(0.5)
end)
_call95:CreateButton({
    Name = "Dupe Tools",
    Callback = function(_687, _687_2, _687_3, _687_4, _687_5)
        local _Character679 = _LocalPlayer671.Character
        local _call689 = _Character679:FindFirstChildOfClass("Tool")
        local _ = _call689.Name
        _call689.Parent = _LocalPlayer671:WaitForChild("Backpack")
        task.wait(0.5)
        local _Name691 = _call689.Name
        local _ = _LocalPlayer671.GetNetworkPing
        local _call695 = Instance.new("BoolValue")
        _call695.Parent = _callcloneref669
        _call695.Name = "PingTest_33967"
        task.wait(0.1)
        _call695:Destroy()
        local _701, _701_2, _701_3 = math.clamp(((tick() - tick()) * 1000), 50, 300)
        local _702, _702_2, _702_3 = math.clamp(_701, 0, 300)
        local _705 = (0.25 + ((_702 / 300) * 0.03))
        local _call709 = _callcloneref669.MarketItems.ChildAdded:Connect(function(_710, _710_2, _710_3, _710_4, _710_5, _710_6)
            local _ = _710.Name == _Name691
        end)
        task.spawn(function(_715)
            _callcloneref669.ListWeaponRemote:FireServer(_Name691, 99999)
        end)
        task.wait(_705)
        local _ = _705 + 0.08896004936025562
        task.spawn(function(_722, _722_2, _722_3, _722_4)
            _callcloneref669.BackpackRemote:InvokeServer("Store", _Name691)
        end)
        task.wait(3)
        task.spawn(function()
            _callcloneref669.BackpackRemote:InvokeServer("Grab", _Name691)
        end)
        _call709:Disconnect()
    end,
})
_call95:CreateParagraph({
    Title = "Usage:",
    Content = "Hello everyone, thank you for using dkshub to do the gun dupe equip your tool you want dupe then press 'Dupe Tools' and there is a afk auto dupe below!",
})
_call95:CreateToggle({
    CurrentValue = false,
    Callback = function(_738, _738_2, _738_3, _738_4)
    end,
    Name = "Auto Dupe Tools",
    Flag = "AutoDupeGun",
})
_call95:CreateSection("Game - Teleports")
local teleportLocations = {
    ["Bank\xC3\xB0\xC5\xB8\xC2\x8F\xC2\xA6"] = Vector3.new(-202.7586, 283.6267, -1222.1841),
    ["Cash Wash\xC3\xB0\xC5\xB8\xC2\xA7\xC2\xBA"] = Vector3.new(-987.11, 253.72, -685.13),
    ["Penthouse\xC3\xB0\xC5\xB8\xC2\x8F\xC2\xA1"] = Vector3.new(-163, 397, -594),
    ["Apartment\xC3\xB0\xC5\xB8\xC2\x8F "] = Vector3.new(-613.78, 356.49, -689.02),
    ["Gunshop 1\xC3\xB0\xC5\xB8\xE2\x80\x9D\xC2\xAB"] = Vector3.new(92976.28, 122097.95, 17022.78),
    ["Gunshop 2\xC3\xB0\xC5\xB8\xE2\x80\x9D\xC2\xAB"] = Vector3.new(66192.45, 123615.71, 5744.73),
    ["Gunshop 3\xC3\xB0\xC5\xB8\xE2\x80\x9D\xC2\xAB"] = Vector3.new(72426.18, 128855.64, -1081.06),
    ["Dealership\xC3\xB0\xC5\xB8\xC5\xA1\xE2\x80\x94"] = Vector3.new(-385.97, 253.41, -1236.36),
    ["Backpack\xC3\xB0\xC5\xB8\xC5\xBD\xE2\x80\x99"] = Vector3.new(-670.86, 253.6, -682.25),
    ["Market\xC3\xB0\xC5\xB8\xE2\x80\xBA\xE2\x80\x99"] = Vector3.new(-388.34, 340.34, -562.64),
    ["Abandoned\xC3\xB0\xC5\xB8\xC2\x8F\xC5\xA1\xC3\xAF\xC2\xB8\xC2\x8F"] = Vector3.new(-733.03, 286.94, -779.16),
    ["Studio\xC3\xB0\xC5\xB8\xC5\xBD\xC2\xAC"] = Vector3.new(93428.23, 14484.71, 561.8),
    ["House 1\xC3\xB0\xC5\xB8\xC2\x8F "] = Vector3.new(-670, 256, -484),
    ["House 2\xC3\xB0\xC5\xB8\xC2\x8F "] = Vector3.new(-647, 256, -485),
    ["Hospital\xC3\xB0\xC5\xB8\xC2\x8F\xC2\xA5"] = Vector3.new(-1590.83, 254.27, 18.92),
    ["MarGreens\xC3\xB0\xC5\xB8\xC2\xA5\xE2\x80\x94"] = Vector3.new(-336.87, 254.45, -394.18),
    ["Dollar Central\xC3\xB0\xC5\xB8\xE2\x80\x99\xC2\xB8"] = Vector3.new(-393.72, 253.82, -1108.29),
}
local selectedLocation = Vector3.new(-202.7586, 283.6267, -1222.1841)

_call95:CreateDropdown({
    Name = "Select Location",
    CurrentOption = {
        [1] = "Bank\xC3\xB0\xC5\xB8\xC2\x8F\xC2\xA6",
    },
    Flag = "TeleportDropdown",
    MultipleOptions = false,
    Callback = function(_777, _777_2, _777_3, _777_4)
        local locationName = _777[1]
        if teleportLocations[locationName] then
            selectedLocation = teleportLocations[locationName]
        end
    end,
    Options = {
        [1] = "Bank\xC3\xB0\xC5\xB8\xC2\x8F\xC2\xA6",
        [2] = "Cash Wash\xC3\xB0\xC5\xB8\xC2\xA7\xC2\xBA",
        [3] = "Penthouse\xC3\xB0\xC5\xB8\xC2\x8F\xC2\xA1",
        [4] = "Apartment\xC3\xB0\xC5\xB8\xC2\x8F ",
        [5] = "Gunshop 1\xC3\xB0\xC5\xB8\xE2\x80\x9D\xC2\xAB",
        [6] = "Gunshop 2\xC3\xB0\xC5\xB8\xE2\x80\x9D\xC2\xAB",
        [7] = "Gunshop 3\xC3\xB0\xC5\xB8\xE2\x80\x9D\xC2\xAB",
        [8] = "Dealership\xC3\xB0\xC5\xB8\xC5\xA1\xE2\x80\x94",
        [9] = "Backpack\xC3\xB0\xC5\xB8\xC5\xBD\xE2\x80\x99",
        [10] = "Market\xC3\xB0\xC5\xB8\xE2\x80\xBA\xE2\x80\x99",
        [11] = "Abandoned\xC3\xB0\xC5\xB8\xC2\x8F\xC5\xA1\xC3\xAF\xC2\xB8\xC2\x8F",
        [12] = "Studio\xC3\xB0\xC5\xB8\xC5\xBD\xC2\xAC",
        [13] = "House 1\xC3\xB0\xC5\xB8\xC2\x8F ",
        [14] = "House 2\xC3\xB0\xC5\xB8\xC2\x8F ",
        [15] = "Hospital\xC3\xB0\xC5\xB8\xC2\x8F\xC2\xA5",
        [16] = "MarGreens\xC3\xB0\xC5\xB8\xC2\xA5\xE2\x80\x94",
        [17] = "Dollar Central\xC3\xB0\xC5\xB8\xE2\x80\x99\xC2\xB8",
    },
})
_call95:CreateButton({
    Name = "Teleport To Location",
    Callback = function(_797)
        local _Character803 = _LocalPlayer74.Character
        local _call805 = _Character803:WaitForChild("Humanoid")
        local hrp = _Character803:WaitForChild("HumanoidRootPart")
        _call805:ChangeState(0)
        hrp.CFrame = CFrame.new(selectedLocation.X, selectedLocation.Y, selectedLocation.Z)
        task.wait(0.5)
    end,
})
_call95:CreateSection("Enable - GUI,s")
local selectedGUIs = {}
_call95:CreateDropdown({
    Name = "Select GUIs",
    CurrentOption = {},
    Flag = "hiih",
    Options = {
        [1] = "Bronx Clothing",
        [2] = "Crafting",
        [3] = "Animations",
        [4] = "Bronx Market",
        [5] = "Bronx Tattoos",
        [6] = "Megaphone List",
    },
    Callback = function(_882, _882_2)
        selectedGUIs = _882
    end,
    MultipleOptions = true,
})
_call95:CreateToggle({
    CurrentValue = false,
    Callback = function(_885, _885_2, _885_3, _885_4, _885_5)
        for _886, _886_2 in ipairs(selectedGUIs) do
            local _ = _LocalPlayer74:WaitForChild("PlayerGui"):FindFirstChild(_886_2)
        end
    end,
    Name = "Open Selected GUI's",
    Flag = "DKhi",
})
_call95:CreateSection("Enable - Other")
_call95:CreateButton({
    Name = "Get Help - $2000",
    Callback = function()
        local _Character897 = _LocalPlayer74.Character
        local _call899 = _Character897:WaitForChild("Humanoid")
        local hrp = _Character897:WaitForChild("HumanoidRootPart")
        _call899:ChangeState(0)
        hrp.CFrame = CFrame.new(-1591, 254, 18)
        task.wait(0.5)
    end,
})
local _call933 = _call93:CreateTab("Autofarm", nil)
_call933:CreateSection("Farming - Utilities")
_call933:CreateToggle({
    CurrentValue = false,
    Name = "Enable Card Autofarm",
    Callback = function(_938)
        genv.AutoFakeCard = _938
        local _ = genv.AutoFakeCard
        _call82.ExoticShopRemote:InvokeServer("FakeCard")
        task.wait(0.25)
        local _call946 = _LocalPlayer74:WaitForChild("Backpack"):FindFirstChild("FakeCard")
        _call946.Parent = _LocalPlayer74.Character
        local _Character950 = _LocalPlayer74.Character
        local _call952 = _Character950:WaitForChild("Humanoid")
        local hrp = _Character950:WaitForChild("HumanoidRootPart")
        _call952:ChangeState(0)
        hrp.CFrame = CFrame.new(- 1017, 254, - 250)
        task.wait(0.5)
    end,
})
