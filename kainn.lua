-- John Phelps Gymnasium Basketball Cheats
-- Game: https://www.roblox.com/games/125385477067602/John-Phelps-Gymnasium-St-Frances

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "🏀 John Phelps Gymnasium",
    LoadingTitle = "Basketball Cheat System",
    LoadingSubtitle = "by Cyber Nexus",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BasketballCheats",
        FileName = "Configuration"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
})

-- Shooting Tab
local ShootingTab = Window:CreateTab("Shooting", "⚡")

local AutoShootSection = ShootingTab:CreateSection("Auto Shooting")

local AutoShootToggle = ShootingTab:CreateToggle({
    Name = "🔄 Auto Shoot",
    CurrentValue = false,
    Flag = "AutoShoot",
    Callback = function(Value)
        getgenv().AutoShoot = Value
        if Value then
            StartAutoShoot()
        else
            StopAutoShoot()
        end
    end,
})

local ShootDelaySlider = ShootingTab:CreateSlider({
    Name = "⏱️ Shoot Delay",
    Range = {0.1, 5},
    Increment = 0.1,
    Suffix = " seconds",
    CurrentValue = 1,
    Flag = "ShootDelay",
    Callback = function(Value)
        getgenv().ShootDelay = Value
    end,
})

local AutoSwipeToggle = ShootingTab:CreateToggle({
    Name = "🎯 Perfect Swipe",
    CurrentValue = false,
    Flag = "AutoSwipe",
    Callback = function(Value)
        getgenv().AutoSwipe = Value
    end,
})

-- Accuracy Tab
local AccuracyTab = Window:CreateTab("Accuracy", "🎯")

local AccuracySection = AccuracyTab:CreateSection("Shot Accuracy")

local PerfectAccuracyToggle = AccuracyTab:CreateToggle({
    Name = "💯 Perfect Accuracy",
    CurrentValue = false,
    Flag = "PerfectAccuracy",
    Callback = function(Value)
        getgenv().PerfectAccuracy = Value
    end,
})

local AlwaysGreenToggle = AccuracyTab:CreateToggle({
    Name = "🟢 Always Green Release",
    CurrentValue = false,
    Flag = "AlwaysGreen",
    Callback = function(Value)
        getgenv().AlwaysGreen = Value
    end,
})

local NoMissToggle = AccuracyTab:CreateToggle({
    Name = "❌ No Miss Shots",
    CurrentValue = false,
    Flag = "NoMiss",
    Callback = function(Value)
        getgenv().NoMiss = Value
    end,
})

-- Movement Tab
local MovementTab = Window:CreateTab("Movement", "🏃")

local SpeedSection = MovementTab:CreateSection("Movement Speed")

local SpeedToggle = MovementTab:CreateToggle({
    Name = "⚡ Speed Boost",
    CurrentValue = false,
    Flag = "SpeedBoost",
    Callback = function(Value)
        getgenv().SpeedBoost = Value
        if Value then
            ApplySpeedBoost()
        else
            RemoveSpeedBoost()
        end
    end,
})

local SpeedSlider = MovementTab:CreateSlider({
    Name = "📊 Speed Multiplier",
    Range = {1, 5},
    Increment = 0.5,
    Suffix = "x",
    CurrentValue = 2,
    Flag = "SpeedMultiplier",
    Callback = function(Value)
        getgenv().SpeedMultiplier = Value
        if getgenv().SpeedBoost then
            ApplySpeedBoost()
        end
    end,
})

local InfiniteStaminaToggle = MovementTab:CreateToggle({
    Name = "💪 Infinite Stamina",
    CurrentValue = false,
    Flag = "InfiniteStamina",
    Callback = function(Value)
        getgenv().InfiniteStamina = Value
    end,
})

-- Dunking Tab
local DunkTab = Window:CreateTab("Dunking", "🏀")

local DunkSection = DunkTab:CreateSection("Dunk Features")

local AutoDunkToggle = DunkTab:CreateToggle({
    Name = "🤖 Auto Dunk",
    CurrentValue = false,
    Flag = "AutoDunk",
    Callback = function(Value)
        getgenv().AutoDunk = Value
        if Value then
            StartAutoDunk()
        else
            StopAutoDunk()
        end
    end,
})

local DunkDistanceSlider = DunkTab:CreateSlider({
    Name = "📏 Dunk Distance",
    Range = {5, 50},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 10,
    Flag = "DunkDistance",
    Callback = function(Value)
        getgenv().DunkDistance = Value
    end,
})

local TeleportDunkToggle = DunkTab:CreateToggle({
    Name = "🌀 Teleport Dunk",
    CurrentValue = false,
    Flag = "TeleportDunk",
    Callback = function(Value)
        getgenv().TeleportDunk = Value
    end,
})

-- Defense Tab
local DefenseTab = Window:CreateTab("Defense", "🛡️")

local BlockSection = DefenseTab:CreateSection("Blocking Features")

local AutoBlockToggle = DefenseTab:CreateToggle({
    Name = "✋ Auto Block",
    CurrentValue = false,
    Flag = "AutoBlock",
    Callback = function(Value)
        getgenv().AutoBlock = Value
        if Value then
            StartAutoBlock()
        else
            StopAutoBlock()
        end
    end,
})

local StealSection = DefenseTab:CreateSection("Stealing")

local AutoStealToggle = DefenseTab:CreateToggle({
    Name = "🖐️ Auto Steal",
    CurrentValue = false,
    Flag = "AutoSteal",
    Callback = function(Value)
        getgenv().AutoSteal = Value
        if Value then
            StartAutoSteal()
        else
            StopAutoSteal()
        end
    end,
})

local StealRangeSlider = DefenseTab:CreateSlider({
    Name = "🎯 Steal Range",
    Range = {5, 30},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 10,
    Flag = "StealRange",
    Callback = function(Value)
        getgenv().StealRange = Value
    end,
})

-- Visual Tab
local VisualTab = Window:CreateTab("Visual", "👁️")

local CourtSection = VisualTab:CreateSection("Court Visuals")

local FullCourtToggle = VisualTab:CreateToggle({
    Name = "👀 See Full Court",
    CurrentValue = false,
    Flag = "FullCourt",
    Callback = function(Value)
        getgenv().FullCourt = Value
        if Value then
            game.Lighting.FogEnd = 10000
        else
            game.Lighting.FogEnd = 1000
        end
    end,
})

local BallESP = VisualTab:CreateToggle({
    Name = "🏀 Ball ESP",
    CurrentValue = false,
    Flag = "BallESP",
    Callback = function(Value)
        getgenv().BallESP = Value
        if Value then
            CreateBallESP()
        else
            RemoveBallESP()
        end
    end,
})

local PlayerESP = VisualTab:CreateToggle({
    Name = "👤 Player ESP",
    CurrentValue = false,
    Flag = "PlayerESP",
    Callback = function(Value)
        getgenv().PlayerESP = Value
        if Value then
            CreatePlayerESP()
        else
            RemovePlayerESP()
        end
    end,
})

-- Misc Tab
local MiscTab = Window:CreateTab("Miscellaneous", "⚙️")

local GameSection = MiscTab:CreateSection("Game Features")

local AutoRebound = MiscTab:CreateToggle({
    Name = "📈 Auto Rebound",
    CurrentValue = false,
    Flag = "AutoRebound",
    Callback = function(Value)
        getgenv().AutoRebound = Value
        if Value then
            StartAutoRebound()
        else
            StopAutoRebound()
        end
    end,
})

local InstantPass = MiscTab:CreateToggle({
    Name = "💨 Instant Pass",
    CurrentValue = false,
    Flag = "InstantPass",
    Callback = function(Value)
        getgenv().InstantPass = Value
    end,
})

local NoFoulToggle = MiscTab:CreateToggle({
    Name = "🚫 No Fouls",
    CurrentValue = false,
    Flag = "NoFouls",
    Callback = function(Value)
        getgenv().NoFouls = Value
    end,
})

-- Initialize global variables
getgenv().AutoShoot = false
getgenv().ShootDelay = 1
getgenv().AutoSwipe = false
getgenv().PerfectAccuracy = false
getgenv().AlwaysGreen = false
getgenv().NoMiss = false
getgenv().SpeedBoost = false
getgenv().SpeedMultiplier = 2
getgenv().InfiniteStamina = false
getgenv().AutoDunk = false
getgenv().DunkDistance = 10
getgenv().TeleportDunk = false
getgenv().AutoBlock = false
getgenv().AutoSteal = false
getgenv().StealRange = 10
getgenv().FullCourt = false
getgenv().BallESP = false
getgenv().PlayerESP = false
getgenv().AutoRebound = false
getgenv().InstantPass = false
getgenv().NoFouls = false

-- Function stubs (you'll need to implement these based on the game)
function StartAutoShoot()
    Rayfield:Notify({
        Title = "Auto Shoot Started",
        Content = "Will automatically shoot when in range",
        Duration = 3,
    })
end

function StopAutoShoot()
    Rayfield:Notify({
        Title = "Auto Shoot Stopped",
        Content = "Auto shooting disabled",
        Duration = 3,
    })
end

function ApplySpeedBoost()
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = 16 * getgenv().SpeedMultiplier
    end
end

function RemoveSpeedBoost()
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = 16
    end
end

function StartAutoDunk()
    Rayfield:Notify({
        Title = "Auto Dunk Started",
        Content = "Will automatically dunk when near basket",
        Duration = 3,
    })
end

function StopAutoDunk()
    Rayfield:Notify({
        Title = "Auto Dunk Stopped",
        Content = "Auto dunking disabled",
        Duration = 3,
    })
end

function StartAutoBlock()
    Rayfield:Notify({
        Title = "Auto Block Started",
        Content = "Will automatically block shots",
        Duration = 3,
    })
end

function StopAutoBlock()
    Rayfield:Notify({
        Title = "Auto Block Stopped",
        Content = "Auto blocking disabled",
        Duration = 3,
    })
end

function StartAutoSteal()
    Rayfield:Notify({
        Title = "Auto Steal Started",
        Content = "Will automatically steal when close",
        Duration = 3,
    })
end

function StopAutoSteal()
    Rayfield:Notify({
        Title = "Auto Steal Stopped",
        Content = "Auto stealing disabled",
        Duration = 3,
    })
end

function CreateBallESP()
    Rayfield:Notify({
        Title = "Ball ESP Enabled",
        Content = "Basketball will be highlighted",
        Duration = 3,
    })
end

function RemoveBallESP()
    Rayfield:Notify({
        Title = "Ball ESP Disabled",
        Content = "Basketball highlight removed",
        Duration = 3,
    })
end

function CreatePlayerESP()
    Rayfield:Notify({
        Title = "Player ESP Enabled",
        Content = "Players will be highlighted",
        Duration = 3,
    })
end

function RemovePlayerESP()
    Rayfield:Notify({
        Title = "Player ESP Disabled",
        Content = "Player highlight removed",
        Duration = 3,
    })
end

function StartAutoRebound()
    Rayfield:Notify({
        Title = "Auto Rebound Started",
        Content = "Will automatically go for rebounds",
        Duration = 3,
    })
end

function StopAutoRebound()
    Rayfield:Notify({
        Title = "Auto Rebound Stopped",
        Content = "Auto rebounding disabled",
        Duration = 3,
    })
end

-- Character handler
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    
    if getgenv().SpeedBoost then
        ApplySpeedBoost()
    end
end)

-- Notify ready
Rayfield:Notify({
    Title = "🏀 Basketball Cheats Loaded",
    Content = "John Phelps Gymnasium cheat system ready!",
    Duration = 5,
})

Rayfield:LoadConfiguration()
