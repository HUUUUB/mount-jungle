-- Mount Jungle - Input Handler (Client-Side)
-- Manages all user input and controls

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local InputHandler = {
  keyBindings = {
    moveForward = Enum.KeyCode.W,
    moveBackward = Enum.KeyCode.S,
    moveLeft = Enum.KeyCode.A,
    moveRight = Enum.KeyCode.D,
    jump = Enum.KeyCode.Space,
    sprint = Enum.KeyCode.LeftShift,
    interact = Enum.KeyCode.E,
    restart = Enum.KeyCode.R,
    pause = Enum.KeyCode.P,
    menu = Enum.KeyCode.M
  },
  inputState = {},
  callbacks = {}
}

function InputHandler:RegisterCallback(action, callback)
  if not self.callbacks[action] then
    self.callbacks[action] = {}
  end
  table.insert(self.callbacks[action], callback)
end

function InputHandler:TriggerCallback(action, ...)
  if self.callbacks[action] then
    for _, callback in ipairs(self.callbacks[action]) do
      callback(...)
    end
  end
end

function InputHandler:IsKeyPressed(keyCode)
  return UserInputService:IsKeyDown(keyCode)
end

function InputHandler:GetMovementInput()
  local moveX = 0
  local moveZ = 0
  
  if self:IsKeyPressed(self.keyBindings.moveForward) then moveZ = moveZ + 1 end
  if self:IsKeyPressed(self.keyBindings.moveBackward) then moveZ = moveZ - 1 end
  if self:IsKeyPressed(self.keyBindings.moveLeft) then moveX = moveX - 1 end
  if self:IsKeyPressed(self.keyBindings.moveRight) then moveX = moveX + 1 end
  
  return Vector2.new(moveX, moveZ)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
  if gameProcessed then return end
  
  if input.KeyCode == InputHandler.keyBindings.jump then
    InputHandler:TriggerCallback("jump")
  elseif input.KeyCode == InputHandler.keyBindings.sprint then
    InputHandler:TriggerCallback("sprintStart")
  elseif input.KeyCode == InputHandler.keyBindings.interact then
    InputHandler:TriggerCallback("interact")
  elseif input.KeyCode == InputHandler.keyBindings.restart then
    InputHandler:TriggerCallback("restart")
  elseif input.KeyCode == InputHandler.keyBindings.pause then
    InputHandler:TriggerCallback("pause")
  elseif input.KeyCode == InputHandler.keyBindings.menu then
    InputHandler:TriggerCallback("menu")
  end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
  if input.KeyCode == InputHandler.keyBindings.sprint then
    InputHandler:TriggerCallback("sprintEnd")
  end
end)

return InputHandler