-- Mount Jungle - Player Movement System (Client-Side)
-- Handles parkour mechanics: jumping, climbing, wall running, vine swinging

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Constants = require(game.ReplicatedStorage:WaitForChild("Constants"))

local player = game.Players.LocalPlayer
local character = script.Parent
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local PlayerMovement = {
  isMoving = false,
  isSprinting = false,
  isWallRunning = false,
  isClimbing = false,
  canDoubleJump = false,
  jumpCount = 0,
  currentSpeed = 0,
  velocity = Vector3.new(0, 0, 0)
}

local bodyVelocity
local bodyGyro

-- Initialize physics objects
function PlayerMovement:Initialize()
  bodyVelocity = Instance.new("BodyVelocity")
  bodyVelocity.Velocity = Vector3.new(0, 0, 0)
  bodyVelocity.MaxForce = Vector3.new(100000, 0, 100000)
  bodyVelocity.Parent = humanoidRootPart
  
  bodyGyro = Instance.new("BodyGyro")
  bodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
  bodyGyro.Parent = humanoidRootPart
  
  print("[PlayerMovement] Initialized for " .. character.Name)
end

-- Handle keyboard input
function PlayerMovement:HandleInput(input, gameProcessed)
  if gameProcessed then return end
  
  if input.KeyCode == Enum.KeyCode.Space then
    self:Jump()
  elseif input.KeyCode == Enum.KeyCode.LeftShift then
    self.isSprinting = true
  elseif input.KeyCode == Enum.KeyCode.E then
    self:TryClimb()
  elseif input.KeyCode == Enum.KeyCode.R then
    self:Respawn()
  end
end

-- Handle input release
function PlayerMovement:HandleInputEnded(input, gameProcessed)
  if input.KeyCode == Enum.KeyCode.LeftShift then
    self.isSprinting = false
  end
end

-- Jump function
function PlayerMovement:Jump()
  if self.jumpCount < 2 then
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    self.jumpCount = self.jumpCount + 1
    
    local jumpVelocity = Constants.JUMP_POWER
    humanoidRootPart.AssemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity + Vector3.new(0, jumpVelocity, 0)
  end
end

-- Wall run function
function PlayerMovement:WallRun()
  if self.isWallRunning then return end
  
  self.isWallRunning = true
  local startTime = tick()
  
  while self.isWallRunning and (tick() - startTime) < Constants.WALL_RUN_DURATION do
    local velocity = humanoidRootPart.AssemblyLinearVelocity
    if velocity.Y < 0 then
      humanoidRootPart.AssemblyLinearVelocity = Vector3.new(velocity.X, velocity.Y * 0.5, velocity.Z)
    end
    
    wait(0.1)
  end
  
  self.isWallRunning = false
end

-- Climb function
function PlayerMovement:TryClimb()
  local rayOrigin = humanoidRootPart.Position
  local rayDirection = (humanoidRootPart.CFrame.LookVector).Unit * 5
  
  local raycastParams = RaycastParams.new()
  raycastParams.FilterType = Enum.RaycastFilterType.Exclude
  raycastParams.FilterDescendantsInstances = {character}
  
  local result = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
  
  if result then
    print("[PlayerMovement] Climbing " .. result.Instance.Parent.Name)
    self.isClimbing = true
  end
end

-- Respawn player
function PlayerMovement:Respawn()
  if workspace:FindFirstChild("SpawnLocation") then
    humanoidRootPart.CFrame = workspace:FindFirstChild("SpawnLocation").CFrame + Vector3.new(0, 3, 0)
    print("[PlayerMovement] Respawned")
  end
end

-- Update movement based on input
function PlayerMovement:UpdateMovement()
  local moveDirection = Vector3.new(0, 0, 0)
  
  if UserInputService:IsKeyDown(Enum.KeyCode.W) then
    moveDirection = moveDirection + (humanoidRootPart.CFrame.LookVector)
  end
  if UserInputService:IsKeyDown(Enum.KeyCode.A) then
    moveDirection = moveDirection - (humanoidRootPart.CFrame.RightVector)
  end
  if UserInputService:IsKeyDown(Enum.KeyCode.S) then
    moveDirection = moveDirection - (humanoidRootPart.CFrame.LookVector)
  end
  if UserInputService:IsKeyDown(Enum.KeyCode.D) then
    moveDirection = moveDirection + (humanoidRootPart.CFrame.RightVector)
  end
  
  if moveDirection.Magnitude > 0 then
    moveDirection = moveDirection.Unit
  end
  
  local speed = self.isSprinting and Constants.SPRINT_SPEED or Constants.MOVE_SPEED
  
  if bodyVelocity then
    bodyVelocity.Velocity = Vector3.new(
      moveDirection.X * speed,
      humanoidRootPart.AssemblyLinearVelocity.Y,
      moveDirection.Z * speed
    )
  end
end

-- Reset jump when touching ground
function PlayerMovement:OnTouched()
  self.jumpCount = 0
  self.canDoubleJump = false
end

PlayerMovement:Initialize()

UserInputService.InputBegan:Connect(function(input, gameProcessed)
  PlayerMovement:HandleInput(input, gameProcessed)
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
  PlayerMovement:HandleInputEnded(input, gameProcessed)
end)

RunService.RenderStepped:Connect(function()
  PlayerMovement:UpdateMovement()
end)

humanoid.TouchInterest:Connect(function()
  PlayerMovement:OnTouched()
end)

print("[PlayerMovement] Script loaded successfully")