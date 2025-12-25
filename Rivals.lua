

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local SCRIPT_URL = "https://raw.githubusercontent.com/jigeans22-oss/Jayhubb/refs/heads/main/Tb3.lua" 
local VALID_KEYS = {
    ["REDLINE-1234"] = true,
    ["REDLINE-5678"] = true,
}

local function promptKey()
    local gui = Instance.new("ScreenGui")
    gui.Name = "RedlineKeyUI"
    gui.Parent = game:GetService("CoreGui")

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.fromScale(0.35, 0.25)
    frame.Position = UDim2.fromScale(0.325, 0.375)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    frame.BorderSizePixel = 0

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(255,0,0)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.fromScale(1, 0.3)
    title.Text = "Redline Key System"
    title.TextColor3 = Color3.fromRGB(255,0,0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20

    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.fromScale(0.8, 0.25)
    box.Position = UDim2.fromScale(0.1, 0.4)
    box.PlaceholderText = "Enter your key"
    box.Text = ""
    box.TextColor3 = Color3.fromRGB(255,255,255)
    box.BackgroundColor3 = Color3.fromRGB(30,30,30)
    box.ClearTextOnFocus = false

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.fromScale(0.5, 0.2)
    btn.Position = UDim2.fromScale(0.25, 0.7)
    btn.Text = "Verify"
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(255,0,0)

    local result
    btn.MouseButton1Click:Connect(function()
        result = box.Text
    end)

    while result == nil do task.wait() end
    gui:Destroy()
    return result
end

local key = promptKey()


if not VALID_KEYS[key] then
    warn("Invalid key")
    return
end


local ok, src = pcall(function()
    return game:HttpGet(SCRIPT_URL)
end)

if not ok or not src or #src < 10 then
    warn("Failed to load script")
    return
end

loadstring(src)()
