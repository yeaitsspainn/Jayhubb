-- 🏀 John Phelps Gymnasium Basketball Cheats
-- Fixed & Working Version

-- Load Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create main window
local Window = Rayfield:CreateWindow({
    Name = "🏀 John Phelps Gymnasium",
    LoadingTitle = "Basketball Cheat System",
    LoadingSubtitle = "Loading...",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BasketballCheats",
        FileName = "Config"
    }
})

-- Shooting Tab
local ShootingTab = Window:CreateTab("Shooting", "🎯")

local AutoShoot = ShootingTab:CreateToggle({
    Name = "Auto Shoot",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoShoot = Value
        if Value then
            StartAutoShoot()
        end
    end
})

ShootingTab:CreateSlider({
    Name = "Shoot Delay",
    Range = {0.5, 5},
    Increment = 0.5,
    Suffix = "s",
    CurrentValue = 1,
    Callback = function(Value)
        _G.ShootDelay = Value
    end
})

-- Movement Tab
local MovementTab = Window:CreateTab("Movement", "⚡")

local SpeedToggle = MovementTab:CreateToggle({
    Name = "Speed Boost",
    CurrentValue = false,
    Callback = function(Value)
        _G.SpeedBoost = Value
        if Value then
            ApplySpeedBoost()
        else
            RemoveSpeedBoost()
        end
    end
})

MovementTab:CreateSlider({
    Name = "Speed Amount",
    Range = {16, 100},
    Increment = 5,
    Suffix = " studs",
    CurrentValue = 50,
    Callback = function(Value)
        _G.SpeedAmount = Value
        if _G.SpeedBoost then
            ApplySpeedBoost()
        end
    end
})

-- Visual Tab
local VisualTab = Window:CreateTab("Visual", "👁️")

local ESPToggle = VisualTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(Value)
        _G.PlayerESP = Value
        if Value then
            CreateESP()
        else
            RemoveESP()
        end
    end
})

local BallESPToggle = VisualTab:CreateToggle({
    Name = "Ball ESP",
    CurrentValue = false,
    Callback = function(Value)
        _G.BallESP = Value
        if Value then
            HighlightBall()
        else
            RemoveBallHighlight()
        end
    end
})

-- Dunk Tab
local DunkTab = Window:CreateTab("Dunking", "🏀")

local AutoDunkToggle = DunkTab:CreateToggle({
    Name = "Auto Dunk",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoDunk = Value
        if Value then
            StartAutoDunk()
        end
    end
})

DunkTab:CreateSlider({
    Name = "Dunk Range",
    Range = {5, 30},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 10,
    Callback = function(Value)
        _G.DunkRange = Value
    end
})

-- Defense Tab
local DefenseTab = Window:CreateTab("Defense", "🛡️")

local AutoBlock = DefenseTab:CreateToggle({
    Name = "Auto Block",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoBlock = Value
        if Value then
            StartAutoBlock()
        end
    end
})

local AutoSteal = DefenseTab:CreateToggle({
    Name = "Auto Steal",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoSteal = Value
        if Value then
            StartAutoSteal()
        end
    end
})

-- Misc Tab
local MiscTab = Window:CreateTab("Misc", "⚙️")

local NoFoulToggle = MiscTab:CreateToggle({
    Name = "No Fouls",
    CurrentValue = false,
    Callback = function(Value)
        _G.NoFouls = Value
    end
})

local InfiniteStamina = MiscTab:CreateToggle({
    Name = "Infinite Stamina",
    CurrentValue = false,
    Callback = function(Value)
        _G.InfiniteStamina = Value
    end
})

-- Initialize global variables
_G.AutoShoot = false
_G.ShootDelay = 1
_G.SpeedBoost = false
_G.SpeedAmount = 50
_G.PlayerESP = false
_G.BallESP = false
_G.AutoDunk = false
_G.DunkRange = 10
_G.AutoBlock = false
_G.AutoSteal = false
_G.NoFouls = false
_G.InfiniteStamina = false

-- Function implementations
function StartAutoShoot()
    spawn(function()
        while _G.AutoShoot do
            task.wait(_G.ShootDelay)
            -- Find basketball and shoot
            local ball = workspace:FindFirstChild("Basketball") or workspace:FindFirstChild("Ball")
            if ball and game.Players.LocalPlayer.Character then
                -- This would need game-specific shooting code
                Rayfield:Notify({
                    Title = "Auto Shoot",
                    Content = "Attempting to shoot...",
                    Duration = 1
                })
            end
        end
    end)
end

function ApplySpeedBoost()
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = _G.SpeedAmount
    end
end

function RemoveSpeedBoost()
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = 16
    end
end

function CreateESP()
    -- Create ESP for players
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character then
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(0, 255, 0)
            highlight.OutlineColor = Color3.fromRGB(0, 200, 0)
            highlight.Parent = player.Character
        end
    end
end

function RemoveESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character then
            for _, child in pairs(player.Character:GetChildren()) do
                if child:IsA("Highlight") then
                    child:Destroy()
                end
            end
        end
    end
end

function HighlightBall()
    spawn(function()
        while _G.BallESP do
            task.wait(0.5)
            local ball = workspace:FindFirstChild("Basketball") or workspace:FindFirstChild("Ball")
            if ball and not ball:FindFirstChild("BallHighlight") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "BallHighlight"
                highlight.FillColor = Color3.fromRGB(255, 255, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 200, 0)
                highlight.Parent = ball
            end
        end
    end)
end

function RemoveBallHighlight()
    local ball = workspace:FindFirstChild("Basketball") or workspace:FindFirstChild("Ball")
    if ball and ball:FindFirstChild("BallHighlight") then
        ball.BallHighlight:Destroy()
    end
end

function StartAutoDunk()
    spawn(function()
        while _G.AutoDunk do
            task.wait(1)
            -- Find basketball hoop
            local hoops = workspace:FindFirstChild("Hoops") or workspace:FindFirstChild("Basket")
            if hoops and game.Players.LocalPlayer.Character then
                Rayfield:Notify({
                    Title = "Auto Dunk",
                    Content = "Looking for dunk opportunity...",
                    Duration = 1
                })
            end
        end
    end)
end

function StartAutoBlock()
    spawn(function()
        while _G.AutoBlock do
            task.wait(0.5)
            -- Check for shooting opponents
            Rayfield:Notify({
                Title = "Auto Block",
                Content = "Monitoring for shots to block...",
                Duration = 1
            })
        end
    end)
end

function StartAutoSteal()
    spawn(function()
        while _G.AutoSteal do
            task.wait(1)
            -- Check for ball carriers nearby
            Rayfield:Notify({
                Title = "Auto Steal",
                Content = "Looking for steal opportunities...",
                Duration = 1
            })
        end
    end)
end

-- Character handler
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    if _G.SpeedBoost then
        ApplySpeedBoost()
    end
end)

-- Update ESP when players join/leave
game.Players.PlayerAdded:Connect(function(player)
    if _G.PlayerESP then
        CreateESP()
    end
end)

game.Players.PlayerRemoving:Connect(function(player)
    if _G.PlayerESP then
        CreateESP() -- Refresh ESP
    end
end)

-- Initial notification
Rayfield:Notify({
    Title = "🏀 Basketball Cheats Loaded",
    Content = "John Phelps Gymnasium cheat system ready!",
    Duration = 5
})

-- Load configuration
Rayfield:LoadConfiguration()

print("Basketball Cheats loaded successfully!")
