-- Mount Jungle - Game Manager (Server-Side)
-- Manages overall game flow, level progression, and player state

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")

local Constants = require(game.ReplicatedStorage:WaitForChild("Constants"))

local GameManager = {}
local playerData = {}
local activeLevels = {}
local leaderboardData = {}

-- Initialize player data
function GameManager:InitializePlayer(player)
  playerData[player.UserId] = {
    level = 1,
    coins = 0,
    checkpoint = 1,
    skins = {"default"},
    activeSkin = "default",
    powerups = {},
    totalTime = 0,
    completedLevels = {},
    bestTimes = {},
    lastLogin = os.time()
  }
  
  print("[GameManager] Player " .. player.Name .. " initialized")
end

-- Save player progress
function GameManager:SavePlayerProgress(player)
  if playerData[player.UserId] then
    print("[GameManager] Saving progress for " .. player.Name)
  end
end

-- Load player progress
function GameManager:LoadPlayerProgress(player)
  if playerData[player.UserId] then
    return playerData[player.UserId]
  end
  return nil
end

-- Start level
function GameManager:StartLevel(player, levelNumber)
  if levelNumber < 1 or levelNumber > Constants.LEVEL_COUNT then
    return false, "Invalid level"
  end
  
  playerData[player.UserId].level = levelNumber
  playerData[player.UserId].checkpoint = 1
  
  print("[GameManager] " .. player.Name .. " started level " .. levelNumber)
  return true, "Level started"
end

-- Complete level
function GameManager:CompleteLevel(player, levelNumber, timeSpent)
  local userId = player.UserId
  
  if not playerData[userId] then return false end
  
  -- Calculate coins earned
  local baseReward = Constants.COIN_BASE_REWARD
  local timeBonus = math.max(0, Constants.COIN_TIME_BONUS - (timeSpent / 60))
  local totalCoins = math.floor(baseReward + timeBonus)
  
  -- Apply difficulty multiplier
  totalCoins = totalCoins * Constants.DIFFICULTY_MULTIPLIERS[levelNumber]
  
  playerData[userId].coins = playerData[userId].coins + totalCoins
  table.insert(playerData[userId].completedLevels, levelNumber)
  playerData[userId].bestTimes[levelNumber] = timeSpent
  
  print("[GameManager] " .. player.Name .. " completed level " .. levelNumber .. " earning " .. totalCoins .. " coins")
  
  return true, totalCoins
end

-- Add coins to player
function GameManager:AddCoins(player, amount)
  playerData[player.UserId].coins = playerData[player.UserId].coins + amount
  return playerData[player.UserId].coins
end

-- Get player coins
function GameManager:GetCoins(player)
  return playerData[player.UserId].coins or 0
end

-- Purchase item from shop
function GameManager:PurchaseItem(player, itemType, itemName)
  local userId = player.UserId
  local price = Constants.SHOP_PRICES[itemType][itemName]
  
  if not price then
    return false, "Item not found"
  end
  
  if playerData[userId].coins < price then
    return false, "Not enough coins"
  end
  
  playerData[userId].coins = playerData[userId].coins - price
  
  if itemType == "skins" then
    table.insert(playerData[userId].skins, itemName)
  elseif itemType == "powerups" then
    playerData[userId].powerups[itemName] = (playerData[userId].powerups[itemName] or 0) + 1
  end
  
  print("[GameManager] " .. player.Name .. " purchased " .. itemName)
  return true, "Purchase successful"
end

-- Set active skin
function GameManager:SetActiveSkin(player, skinName)
  local userId = player.UserId
  
  for _, skin in ipairs(playerData[userId].skins) do
    if skin == skinName then
      playerData[userId].activeSkin = skinName
      return true, "Skin changed"
    end
  end
  
  return false, "Skin not owned"
end

-- Get player data
function GameManager:GetPlayerData(player)
  return playerData[player.UserId]
end

-- Update leaderboard
function GameManager:UpdateLeaderboard()
  leaderboardData = {}
  
  for userId, data in pairs(playerData) do
    table.insert(leaderboardData, {
      userId = userId,
      coins = data.coins,
      level = data.level,
      completedLevels = #data.completedLevels
    })
  end
  
  table.sort(leaderboardData, function(a, b)
    return a.coins > b.coins
  end)
end

-- Get leaderboard
function GameManager:GetLeaderboard(limit)
  limit = limit or 10
  local result = {}
  
  for i = 1, math.min(limit, #leaderboardData) do
    table.insert(result, leaderboardData[i])
  end
  
  return result
end

-- Player joining
Players.PlayerAdded:Connect(function(player)
  GameManager:InitializePlayer(player)
end)

-- Player leaving
Players.PlayerRemoving:Connect(function(player)
  GameManager:SavePlayerProgress(player)
  playerData[player.UserId] = nil
end)

-- Update leaderboard every 30 seconds
while true do
  wait(30)
  GameManager:UpdateLeaderboard()
end

return GameManager