-- Mount Jungle - Particle Effects
-- Creates visual effects for parkour actions

local ParticleEffects = {}

function ParticleEffects:CreateDustEffect(position)
  local attachment = Instance.new("Attachment")
  attachment.Parent = workspace
  attachment.Position = position
  
  local particle = Instance.new("ParticleEmitter")
  particle.Parent = attachment
  particle.Texture = "rbxasset://textures/particles/sparkles_main.dds"
  particle.Rate = 50
  particle.Lifetime = NumberRange.new(1)
  particle.Speed = NumberRange.new(10)
  particle.Enabled = true
  
  game:GetService("Debris"):AddItem(attachment, 2)
end

function ParticleEffects:CreateJumpEffect(position)
  local attachment = Instance.new("Attachment")
  attachment.Parent = workspace
  attachment.Position = position
  
  local particle = Instance.new("ParticleEmitter")
  particle.Parent = attachment
  particle.Texture = "rbxasset://textures/particles/smoke_main.dds"
  particle.Rate = 20
  particle.Lifetime = NumberRange.new(0.5)
  particle.Speed = NumberRange.new(5)
  particle.Enabled = true
  
  game:GetService("Debris"):AddItem(attachment, 1)
end

function ParticleEffects:CreatePowerUpEffect(position)
  local attachment = Instance.new("Attachment")
  attachment.Parent = workspace
  attachment.Position = position
  
  local particle = Instance.new("ParticleEmitter")
  particle.Parent = attachment
  particle.Texture = "rbxasset://textures/particles/sparkles_main.dds"
  particle.Rate = 100
  particle.Lifetime = NumberRange.new(1.5)
  particle.Speed = NumberRange.new(20)
  particle.Color = ColorSequence.new(Color3.fromRGB(255, 215, 0))
  particle.Enabled = true
  
  game:GetService("Debris"):AddItem(attachment, 2)
end

return ParticleEffects