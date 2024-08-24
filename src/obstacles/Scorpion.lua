-- src/Scorpion.lua
local Obstacle = require 'src/obstacles/Obstacle'
local Scorpion = setmetatable({}, { __index = Obstacle })
Scorpion.__index = Scorpion

function Scorpion:new()
    return Obstacle.new(self, 'images/scorpion.png', 500)
end

return Scorpion
