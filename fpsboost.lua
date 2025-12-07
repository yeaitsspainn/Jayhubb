-- Delta Executor FPS Booster for The Bronx
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local RunService = game:GetService("RunService")

-- Force maximum performance
UserGameSettings.SavedQualityLevel = Enum.QualityLevel.Level01
settings().Rendering.QualityLevel = 1
settings().Rendering.EnableFRM = false
settings().Rendering.MeshCacheSize = 100
settings().Rendering.EagerBulkExecution = true

-- Disable unnecessary graphics
game:GetService("Lighting").GlobalShadows = false
game:GetService("Lighting").Technology = "Compatibility"
game:GetService("Lighting").FantasySky.Enabled = false

-- Optimize particles
for _, v in pairs(workspace:GetDescendants()) do
    if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") then
        v:Destroy()
    end
end

print("✅ FPS Booster Activated - Graphics at Minimum")
