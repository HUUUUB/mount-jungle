-- Mount Jungle - Power-Up System
-- Manages all power-up effects and mechanics

local Constants = require(script.Parent:WaitForChild("Constants"))

local PowerUpSystem = {}
local activePowerUps = {}

function PowerUpSystem:ApplyPowerUp(player, powerUpName)
  if activePowerUps[player.UserId] and activePowerUps[player.UserId][powerUpName] then
    return false, "Power-up already active"
  end
  
  if not activePowerUps[player.UserId] then
    activePowerUps[player.UserId] = {}
  end
  
  local duration = Constants.POWERUP_DURATION[powerUpName]
  local startTime = tick()
  
  activePowerUps[player.UserId][powerUpName] = {
    active = true,
    startTime = startTime,
    duration = duration
  }
  
  print("[PowerUpSystem] Applied " .. powerUpName .. " to " .. player.Name)
  
  local removingConnection
  removingConnection = game:GetService("RunService").Heartbeat:Connect(function()
    if tick() - startTime >= duration then
      PowerUpSystem:RemovePowerUp(player, powerUpName)
      removingConnection:Disconnect()
    end
  end)
  
  return true, "Power-up applied"
end

function PowerUpSystem:RemovePowerUp(player, powerUpName)
  if activePowerUps[player.UserId] and activePowerUps[player.UserId][powerUpName] then
    activePowerUps[player.UserId][powerUpName] = nil
    print("[PowerUpSystem] Removed " .. powerUpName .. " from " .. player.Name)
    return true
  end
  return false
end

function PowerUpSystem:IsPowerUpActive(player, powerUpName)
  if activePowerUps[player.UserId] and activePowerUps[player.UserId][powerUpName] then
    return activePowerUps[player.UserId][powerUpName].active
  end
  return false
end

function PowerUpSystem:GetActivePowerUps(player)
  return activePowerUps[player.UserId] or {}
end

function PowerUpSystem:GetMultiplier(powerUpName)
  return Constants.POWERUP_MULTIPLIERS[powerUpName] or 1.0
end

return PowerUpSystem