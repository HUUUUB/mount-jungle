-- Mount Jungle - Leaderboard Manager
-- Manages player rankings and statistics

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local LeaderboardManager = {}
local leaderboardStore = DataStoreService:GetDataStore("Leaderboard")
local playerStats = {}

-- Update player stats
function LeaderboardManager:UpdateStats(player, stats)
  local userId = player.UserId
  
  playerStats[userId] = {
    name = player.Name,
    userId = userId,
    coins = stats.coins or 0,
    level = stats.level or 1,
    completedLevels = stats.completedLevels or 0,
    bestTime = stats.bestTime or 0,
    lastUpdated = os.time()
  }
  
  -- Save to DataStore
  local success, err = pcall(function()
    leaderboardStore:SetAsync("player_" .. userId, playerStats[userId])
  end)
  
  if not success then
    print("[LeaderboardManager] Error saving stats for " .. player.Name .. ": " .. err)
  end
end

-- Get top players by coins
function LeaderboardManager:GetTopByCoin(limit)
  limit = limit or 10
  local result = {}
  
  for userId, stats in pairs(playerStats) do
    table.insert(result, stats)
  end
  
  table.sort(result, function(a, b)
    return a.coins > b.coins
  end)
  
  local topPlayers = {}
  for i = 1, math.min(limit, #result) do
    table.insert(topPlayers, {
      rank = i,
      name = result[i].name,
      coins = result[i].coins
    })
  end
  
  return topPlayers
end

-- Get top players by level
function LeaderboardManager:GetTopByLevel(limit)
  limit = limit or 10
  local result = {}
  
  for userId, stats in pairs(playerStats) do
    table.insert(result, stats)
  end
  
  table.sort(result, function(a, b)
    if a.level == b.level then
      return a.completedLevels > b.completedLevels
    end
    return a.level > b.level
  end)
  
  local topPlayers = {}
  for i = 1, math.min(limit, #result) do
    table.insert(topPlayers, {
      rank = i,
      name = result[i].name,
      level = result[i].level,
      completedLevels = result[i].completedLevels
    })
  end
  
  return topPlayers
end

-- Get player rank
function LeaderboardManager:GetPlayerRank(player)
  local userId = player.UserId
  local playerCoins = playerStats[userId].coins
  local rank = 1
  
  for _, stats in pairs(playerStats) do
    if stats.coins > playerCoins then
      rank = rank + 1
    end
  end
  
  return rank
end

-- Get total players
function LeaderboardManager:GetTotalPlayers()
  local count = 0
  for _ in pairs(playerStats) do
    count = count + 1
  end
  return count
end

return LeaderboardManager