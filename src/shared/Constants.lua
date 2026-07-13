-- Mount Jungle - Game Constants
-- Edit these values to customize game behavior

local Constants = {}

-- PLAYER MOVEMENT
Constants.MOVE_SPEED = 25
Constants.SPRINT_SPEED = 40
Constants.JUMP_HEIGHT = 50
Constants.JUMP_POWER = 50
Constants.ACCELERATION = 0.1
Constants.FRICTION = 0.15

-- PARKOUR MECHANICS
Constants.WALL_RUN_SPEED = 35
Constants.WALL_RUN_DURATION = 2
Constants.VINE_SWING_SPEED = 30
Constants.CLIMB_SPEED = 20
Constants.DOUBLE_JUMP_HEIGHT = 40

-- GAMEPLAY
Constants.LEVEL_COUNT = 5
Constants.CHECKPOINT_SAVE_INTERVAL = 10
Constants.RESPAWN_DELAY = 2
Constants.LEVEL_TIME_LIMITS = {
  [1] = 300, -- 5 minutes for beginner
  [2] = 400, -- ~6.5 minutes for intermediate
  [3] = 500, -- ~8 minutes for advanced
  [4] = 600, -- 10 minutes for expert
  [5] = 900  -- 15 minutes for master
}

-- CURRENCY & REWARDS
Constants.COIN_BASE_REWARD = 100
Constants.COIN_TIME_BONUS = 50
Constants.COIN_LEADERBOARD_BONUS = 200
Constants.LEVEL_COMPLETE_MULTIPLIER = 1.5

-- SHOP PRICES
Constants.SHOP_PRICES = {
  skins = {
    default = 0,
    jungle_warrior = 150,
    vine_ninja = 250,
    tiger_mode = 400,
    phantom = 600
  },
  powerups = {
    speed_boost = 100,
    double_jump = 150,
    wall_climb = 120,
    dash = 180,
    shield = 200
  }
}

-- POWER-UP EFFECTS
Constants.POWERUP_DURATION = {
  speed_boost = 30,
  double_jump = 60,
  wall_climb = 45,
  dash = 20,
  shield = 60
}

Constants.POWERUP_MULTIPLIERS = {
  speed_boost = 1.5,
  double_jump = 1.0,
  wall_climb = 1.3,
  dash = 2.0,
  shield = 1.0
}

-- DIFFICULTY MULTIPLIERS
Constants.DIFFICULTY_MULTIPLIERS = {
  [1] = 1.0,   -- Beginner
  [2] = 1.2,   -- Intermediate
  [3] = 1.5,   -- Advanced
  [4] = 2.0,   -- Expert
  [5] = 3.0    -- Master
}

-- UI SETTINGS
Constants.HUD_UPDATE_INTERVAL = 0.1
Constants.LEADERBOARD_REFRESH_INTERVAL = 5
Constants.NOTIFICATION_DURATION = 3

-- ANTI-CHEAT
Constants.MAX_SPEED_LIMIT = 100
Constants.MAX_JUMP_HEIGHT = 200
Constants.SPEED_CHECK_INTERVAL = 0.5
Constants.TELEPORT_DISTANCE_LIMIT = 50

-- SOUND VOLUMES
Constants.SOUND_VOLUME = {
  master = 0.7,
  music = 0.5,
  sfx = 0.8,
  ambient = 0.4
}

-- EFFECTS
Constants.PARTICLE_EFFECT_DURATION = 1.5
Constants.DUST_PARTICLE_COUNT = 20
Constants.SMOKE_PARTICLE_COUNT = 15

return Constants