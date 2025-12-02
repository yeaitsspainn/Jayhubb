--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local S, E = pcall(function()
    if _G.Stepped then
        _G.Stepped:Disconnect()
    end
    if _G.InputBegan then
        _G.InputBegan:Disconnect()
    end
    if _G.TouchTap then
        _G.TouchTap:Disconnect()
    end
    if _G.TouchGui then
        _G.TouchGui:Destroy()
    end
end)

if S then
    game.StarterGui:SetCore("SendNotification", {
        Title = "Silent Aim",
        Text = "Silent Aim was reset, Mode: Normal Aimbot",
        Duration = 3
    })

    _G.Stepped = nil
    _G.InputBegan = nil
    _G.TouchTap = nil
    _G.TouchGui = nil
end

local Player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Playground = (game.PlaceId == 4923146720)
local IsInFooting = false

-- Create mobile button for shooting
local function CreateMobileButton()
    if _G.TouchGui then
        _G.TouchGui:Destroy()
    end
    
    local TouchGui = Instance.new("ScreenGui")
    TouchGui.Name = "MobileShootGui"
    TouchGui.DisplayOrder = 10
    TouchGui.ResetOnSpawn = false
    TouchGui.Parent = Player.PlayerGui
    
    local ShootButton = Instance.new("TextButton")
    ShootButton.Name = "ShootButton"
    ShootButton.Text = "SHOOT (X)"
    ShootButton.TextScaled = true
    ShootButton.Font = Enum.Font.GothamBold
    ShootButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ShootButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    ShootButton.BackgroundTransparency = 0.3
    ShootButton.Size = UDim2.new(0, 120, 0, 120)
    ShootButton.Position = UDim2.new(1, -140, 1, -140)
    ShootButton.AnchorPoint = Vector2.new(0.5, 0.5)
    ShootButton.Parent = TouchGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0.3, 0)
    UICorner.Parent = ShootButton
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Thickness = 3
    UIStroke.Parent = ShootButton
    
    -- Make button draggable
    local Dragging = false
    local DragInput, DragStart, StartPos
    
    local function Update(input)
        local Delta = input.Position - DragStart
        ShootButton.Position = UDim2.new(
            StartPos.X.Scale, 
            StartPos.X.Offset + Delta.X,
            StartPos.Y.Scale, 
            StartPos.Y.Offset + Delta.Y
        )
    end
    
    ShootButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = input.Position
            StartPos = ShootButton.Position
            
            -- Visual feedback when pressing
            ShootButton.BackgroundTransparency = 0.1
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                    ShootButton.BackgroundTransparency = 0.3
                end
            end)
        end
    end)
    
    ShootButton.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) and Dragging then
            DragInput = input
        end
    end)
    
    ShootButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            ShootButton.BackgroundTransparency = 0.3
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            Update(input)
        end
    end)
    
    _G.TouchGui = TouchGui
    _G.ShootButton = ShootButton
end

-- Initialize mobile UI
CreateMobileButton()

local HL = Instance.new("Highlight")
HL.Enabled = false
if Player.Character then
    HL.Adornee = Player.Character
end
HL.FillColor = Color3.fromRGB(25, 255, 25)
HL.OutlineColor = Color3.fromRGB(0, 255, 0)
HL.Parent = game:GetService("CoreGui")

-- Character added event
Player.CharacterAdded:Connect(function(character)
    HL.Adornee = character
    task.wait(1)
end)

local Goals = {} do
    for _, Obj in next, game:GetDescendants() do
        if Obj.Name == "Goal" and Obj:IsA("BasePart") then
            table.insert(Goals, Obj)
        elseif Obj.Name == "Part" and Obj:IsA("BasePart") and Obj.Size == Vector3.new(5, 1, 5) then
            table.insert(Goals, Obj)
        end
    end
end

local Shuffled, Selected do
    for _, Garbage in next, getgc(true) do
        if type(Garbage) == "function" and getinfo(Garbage)["name"] == "selected1" then
            Selected = Garbage
        elseif type(Garbage) == "table" and rawget(Garbage, "1") and rawget(Garbage, "1") ~= true then
            Shuffled = Garbage
        end
    end
end

local Clicker do
    if Playground == false then
        Clicker = getupvalue(Selected, 3)
    else
        Clicker = getupvalue(Selected, 5)
    end
end

local GetClock = function()
    local OldClock = getupvalue(Selected, 3)
    local NewClock = OldClock + 1
    
    setupvalue(Selected, 3, NewClock)
    
    return NewClock
end

local GetKeyFromKeyTable = function()
    local Keys = getupvalue(Selected, 4)
    
    if Playground == true then
        return "Shotta_"
    elseif type(Keys[1]) == "string" then
        return Keys[1]
    end
    
    return "Shotta"
end

local RemoveKeyFromKeyTable = function()
    local StartTime = tick()
    
    repeat task.wait() until Player.Character == nil or Player.Character:FindFirstChild("Basketball") == nil or tick() - StartTime > 1.5
    
    if Player.Character == nil or tick() - StartTime > 1.5 then
        return print("Didnt remove key")
    end
    
    local Keys = getupvalue(Selected, 4)
    
    if type(Keys) == "table" then
        print("Removed key")
        table.remove(Keys, 1)
        setupvalue(Selected, 4, Keys)
    end
end

local GetRandomizedTable = function(TorsoPosition, ShootPosition)
    local UnrandomizedArgs = {
        X1 = TorsoPosition.X,
        Y1 = TorsoPosition.Y,
        Z1 = TorsoPosition.Z,
        X2 = ShootPosition.X,
        Y2 = ShootPosition.Y,
        Z2 = ShootPosition.Z
    }
    
    local RandomizedArgs = {
        UnrandomizedArgs[Shuffled["1"]],
        UnrandomizedArgs[Shuffled["2"]],
        UnrandomizedArgs[Shuffled["3"]],
        UnrandomizedArgs[Shuffled["4"]],
        UnrandomizedArgs[Shuffled["5"]],
        UnrandomizedArgs[Shuffled["6"]],
    }
    
    return RandomizedArgs
end

local GetGoal = function()
    if not Player.Character or not Player.Character:FindFirstChild("Torso") then
        return nil
    end
    
    local Distance, Goal = 9e9
    
    for _, Obj in next, Goals do
        local Magnitude = (Player.Character.Torso.Position - Obj.Position).Magnitude
        
        if Distance > Magnitude then
            Distance = Magnitude
            Goal = Obj
        end
    end
    
    return Goal
end

local GetDistance = function()
    local Goal = GetGoal()
    if not Player.Character or not Player.Character:FindFirstChild("Torso") or not Goal then
        return 0
    end
    
    local TorsoPosition = Player.Character.Torso.Position
    
    return (TorsoPosition - Goal.Position).Magnitude
end

local GetDirection = function(Position)
    if not Player.Character or not Player.Character:FindFirstChild("Torso") then
        return Vector3.new(0, 1, 0)
    end
    
    return (Position - Player.Character.Torso.Position).Unit
end

local GetMoveDirection = function()
    if not Player.Character or not Player.Character:FindFirstChild("Humanoid") then
        return Vector3.new(0, 0, 0)
    end
    
    local Direction = Player.Character.Humanoid.MoveDirection * 1.8
    
    if UIS:IsKeyDown(Enum.KeyCode.S) == true and UIS:IsKeyDown(Enum.KeyCode.W) == true then
        Direction = Player.Character.Humanoid.MoveDirection * 0.5
    elseif UIS:IsKeyDown(Enum.KeyCode.S) == true and UIS:IsKeyDown(Enum.KeyCode.W) == false then
        Direction = Player.Character.Humanoid.MoveDirection * 0.8
    elseif UIS:IsKeyDown(Enum.KeyCode.S) == false and UIS:IsKeyDown(Enum.KeyCode.W) == true then
        Direction = Player.Character.Humanoid.MoveDirection * 1.2
    end
        
    return Direction
end

local GetBasketball = function()
    if not Player.Character then
        return nil
    end
    
    return Player.Character:FindFirstChildOfClass("Folder")
end

local InFootingCheck = function()
    if not Player.Character or not Player.Character:FindFirstChild("Humanoid") then
        IsInFooting = false
        return
    end
    
    local Distance = GetDistance()
    local Basketball = GetBasketball()
    
    local Power do 
        if Basketball ~= nil then
            Power = Basketball.PowerValue.Value
        else
            IsInFooting = false
            return
        end
    end
    
    if Player.Character.Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
        if Power == 75 or Power == 100 then
            Distance = Distance - 1
        else
            Distance = Distance - 3
        end
    end
    
    if Power == 75 then
        if Distance > 57 and Distance < 61 then
            IsInFooting = true
        else
            IsInFooting = false
        end
    elseif Power == 80 then
        if Distance > 57 and Distance < 64 then
            IsInFooting = true
        else
            IsInFooting = false
        end
    elseif Power == 85 then
        if Distance > 57 and Distance < 70 then
            IsInFooting = true
        else
            IsInFooting = false
        end
    elseif Power == 90 then
        if Distance > 57 and Distance < 74 then
            IsInFooting = true
        else
            IsInFooting = false
        end
    elseif Power == 95 then
        if Distance > 57 and Distance < 82 then
            IsInFooting = true
        else
            IsInFooting = false
        end
    elseif Power == 100 then
        if Distance > 57 and Distance < 87 then
            IsInFooting = true
        else
            IsInFooting = false
        end
    elseif Power < 75 then
        IsInFooting = false
    end
end

local GetArc = function()
    local Distance = GetDistance()
    local Basketball = GetBasketball()
    
    local Arc = nil
    
    local Power do
        if Basketball ~= nil then
            Power = Basketball.PowerValue.Value
        else
            return
        end
    end
    
    if Power == 75 then
        if Distance > 57 and Distance < 59 then
            Arc = 55
        elseif Distance > 59 and Distance < 60 then
            Arc = 50
        elseif Distance > 60 and Distance < 61 then
            Arc = 45
        elseif Distance > 61 and Distance < 62 then
            Arc = 40
        end
    elseif Power == 80 then
        if Distance > 57 and Distance < 59 then
            Arc = 75
        elseif Distance > 59 and Distance < 63 then
            Arc = 70
        elseif Distance > 63 and Distance < 65 then
            Arc = 60
        elseif Distance > 65 and Distance < 69 then
            Arc = 50
        end
    elseif Power == 85 then
        if Distance > 57 and Distance < 63 then
            Arc = 85
        elseif Distance > 63 and Distance < 67 then
            Arc = 80
        elseif Distance > 67 and Distance < 70 then
            Arc = 75
        elseif Distance > 70 and Distance < 74 then
            Arc = 60
        end
    elseif Power == 90 then
        if Distance > 57 and Distance < 63 then
            Arc = 100
        elseif Distance > 63 and Distance < 67 then
            Arc = 95
        elseif Distance > 67 and Distance < 69 then
            Arc = 90
        elseif Distance > 69 and Distance < 74 then
            Arc = 85
        elseif Distance > 74 and Distance < 77 then
            Arc = 75
        elseif Distance > 77 and Distance < 79 then
            Arc = 65
        end
    elseif Power == 95 then
        if Distance > 57 and Distance < 58 then
            Arc = 120
        elseif Distance > 59 and Distance < 63 then
            Arc = 115
        elseif Distance > 63 and Distance < 68 then
            Arc = 110
        elseif Distance > 68 and Distance < 71 then
            Arc = 105
        elseif Distance > 71 and Distance < 74 then
            Arc = 100
        elseif Distance > 74 and Distance < 79 then
            Arc = 95
        elseif Distance > 79 and Distance < 81 then
            Arc = 90
        elseif Distance > 81 and Distance < 82 then
            Arc = 65
        elseif Distance > 82 and Distance < 86 then
            Arc = 60
        end
    elseif Power == 100 then
        if Distance > 57 and Distance < 66 then
            Arc = 130
        elseif Distance > 66 and Distance < 69 then
            Arc = 125
        elseif Distance > 69 and Distance < 74 then
            Arc = 120
        elseif Distance > 74 and Distance < 79 then
            Arc = 115
        elseif Distance > 79 and Distance < 82 then
            Arc = 110
        elseif Distance > 82 and Distance < 84 then
            Arc = 105
        elseif Distance > 84 and Distance < 88 then
            Arc = 100
        elseif Distance > 88 and Distance < 90 then
            Arc = 85
        elseif Distance > 90 and Distance < 93 then
            Arc = 65
        end
    end
    
    if Playground == true and Arc ~= nil then
        Arc = Arc - 5
    end
    
    return Arc
end

getgenv().Shoot = function()
    if not Player.Character or not Player.Character:FindFirstChild("Basketball") then
        return
    end
    
    local Goal = GetGoal()
    local Arc = GetArc()
    local MoveDirection = GetMoveDirection()
    
    if not Goal or not Arc then
        return
    end
    
    local Hit = (Goal.Position + Vector3.new(0, Arc, 0) + MoveDirection)
    local Direction = GetDirection(Hit)
    local RandomizedArgs = GetRandomizedTable(Player.Character.Torso.Position, Direction)
    local Basketball = GetBasketball()
    local Key = GetKeyFromKeyTable()
    
    if Playground == true then
        local Clock = GetClock()
        Key = Key .. Clock
    end
    
    Clicker:FireServer(Basketball, Basketball.PowerValue.Value, RandomizedArgs, Key)
    
    if GetBasketball() ~= nil then
        RemoveKeyFromKeyTable()
    end
end

local function PerformShoot()
    if Player.Character and Player.Character:FindFirstChild("Basketball") and IsInFooting then
        if Player.Character.Humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
            Player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            task.wait(0.25)
        end
        
        Shoot()
    end
end

-- Keyboard input
_G.InputBegan = UIS.InputBegan:Connect(function(Key, GPE)
    if not GPE and Key.KeyCode == Enum.KeyCode.X and Player.Character and Player.Character:FindFirstChild("Basketball") and IsInFooting then
        PerformShoot()
    end
end)

-- Mobile touch input
if _G.ShootButton then
    _G.ShootButton.MouseButton1Click:Connect(function()
        PerformShoot()
    end)
    
    _G.ShootButton.TouchTap:Connect(function()
        PerformShoot()
    end)
end

-- Update mobile button visibility
local function UpdateMobileButton()
    if _G.ShootButton then
        if IsInFooting then
            _G.ShootButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)  -- Green when ready
            _G.ShootButton.Text = "SHOOT READY"
        else
            _G.ShootButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)  -- Blue when not ready
            _G.ShootButton.Text = "SHOOT (X)"
        end
    end
end

_G.Stepped = RS.Stepped:Connect(function()
    InFootingCheck()
    UpdateMobileButton()
    
    if IsInFooting then
        HL.Enabled = true
    else
        HL.Enabled = false
    end
    
    if HL.Adornee == nil or HL.Adornee.Parent == nil then
        if Player.Character then
            HL.Adornee = Player.Character
        end
    end
end)

-- Handle device type changes
UIS.LastInputTypeChanged:Connect(function(lastInputType)
    if lastInputType == Enum.UserInputType.Touch then
        -- Mobile device detected
        if _G.TouchGui then
            _G.TouchGui.Enabled = true
        end
    else
        -- Keyboard/mouse detected
        if _G.TouchGui then
            _G.TouchGui.Enabled = false  -- Hide button on PC
        end
    end
end)

-- Initial device check
if UIS.TouchEnabled and UIS.MouseEnabled == false then
    -- Mobile device
    if _G.TouchGui then
        _G.TouchGui.Enabled = true
    end
else
    -- PC device
    if _G.TouchGui then
        _G.TouchGui.Enabled = false
    end
end

print("Silent Aim loaded successfully! Mobile support enabled.")
print("Press X or tap the mobile button when highlighted to shoot.")
