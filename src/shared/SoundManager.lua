-- Mount Jungle - Sound Manager
-- Manages all sound effects and background music

local SoundManager = {
  sounds = {},
  volumes = {
    master = 0.7,
    music = 0.5,
    sfx = 0.8
  }
}

function SoundManager:InitializeSound(name, soundId, soundType)
  local sound = Instance.new("Sound")
  sound.SoundId = soundId
  sound.Volume = self.volumes[soundType or "sfx"] * self.volumes.master
  sound.Name = name
  sound.Parent = workspace
  
  self.sounds[name] = {
    sound = sound,
    soundType = soundType or "sfx"
  }
  
  return sound
end

function SoundManager:PlaySound(soundName)
  if self.sounds[soundName] then
    local sound = self.sounds[soundName].sound
    sound:Play()
    return true
  end
  return false
end

function SoundManager:StopSound(soundName)
  if self.sounds[soundName] then
    self.sounds[soundName].sound:Stop()
    return true
  end
  return false
end

function SoundManager:SetVolume(soundType, volume)
  self.volumes[soundType] = math.clamp(volume, 0, 1)
  
  for _, soundData in pairs(self.sounds) do
    if soundData.soundType == soundType then
      soundData.sound.Volume = volume * self.volumes.master
    end
  end
end

function SoundManager:PreloadSounds()
  self:InitializeSound("jump", "rbxassetid://12221944", "sfx")
  self:InitializeSound("land", "rbxassetid://12221967", "sfx")
  self:InitializeSound("coin", "rbxassetid://12221974", "sfx")
  self:InitializeSound("powerup", "rbxassetid://12221981", "sfx")
  self:InitializeSound("levelcomplete", "rbxassetid://12221988", "sfx")
end

return SoundManager