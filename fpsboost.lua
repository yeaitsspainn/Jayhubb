-- Nameless Hub FPS Booster | Low Performance Mode
local Lighting = game:GetService("Lighting")
local Terrain = workspace.Terrain
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- // Remove Shadows
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.FogStart = 0
Lighting.Brightness = 1

-- // Lower Terrain Quality
pcall(function()
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 1
end)

-- // Disable Post Effects
for i,v in pairs(Lighting:GetChildren()) do
    if v:IsA("BlurEffect")
    or v:IsA("SunRaysEffect")
    or v:IsA("BloomEffect")
    or v:IsA("DepthOfFieldEffect")
    or v:IsA("ColorCorrectionEffect") then
        v.Enabled = false
    end
end

-- // FPS Low Model Rendering
Settings = Instance.new("Folder", game)
for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") then
        obj.Material = Enum.Material.Plastic
        obj.Reflectance = 0
    elseif obj:IsA("Decal") or obj:IsA("Texture") then
        obj.Transparency = 1
    end
end

-- // Disable Particles
for _, p in ipairs(workspace:GetDescendants()) do
    if p:IsA("ParticleEmitter")
    or p:IsA("Trail")
    or p:IsA("Fire")
    or p:IsA("Smoke")
    or p:IsA("Sparkles") then
        p.Enabled = false
    end
end

-- // FPS Cap (Optional)
local RunService = game:GetService("RunService")
setfpscap(60)

print("Nameless Hub FPS Booster Enabled")
