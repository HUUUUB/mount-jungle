# Mount Jungle - Setup Guide

## Prerequisites
- Roblox Studio installed
- Basic knowledge of Lua
- Understanding of Roblox structure

## Installation Steps

### Step 1: Create New Game
1. Open Roblox Studio
2. Create new game
3. Select "Blank" template

### Step 2: Copy Scripts
1. Go to ServerScriptService in Explorer
2. Copy scripts from `src/server/` to ServerScriptService
3. Go to StarterPlayer > StarterCharacterScripts
4. Copy `PlayerMovement.lua` from `src/client/`
5. Go to ReplicatedStorage
6. Create "Modules" folder
7. Copy all scripts from `src/shared/` here

### Step 3: Create Maps
1. In Workspace, create folder called "Maps"
2. Create subfolders for each level
3. Design maps using Parts
4. Add spawn and end points

### Step 4: Configure UI
1. Go to StarterGui
2. Create ScreenGuis for menus
3. Implement buttons and layouts

### Step 5: Test Game
1. Click "Play" button
2. Test movement controls
3. Verify level progression
4. Check shop functionality

### Step 6: Publish
1. File > Publish to Roblox
2. Fill in game details
3. Publish!

## Troubleshooting

**Movement not working?**
- Ensure PlayerMovement.lua is in StarterCharacterScripts
- Check BodyVelocity initialization
- Verify Constants are loaded

**Shop errors?**
- Check GameManager is in ServerScriptService
- Verify ReplicatedStorage path

**Performance issues?**
- Reduce particle effects
- Optimize script connections
- Use profiler to identify bottlenecks