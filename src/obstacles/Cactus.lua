-- src/Cactus.lua
local Obstacle = require 'src/obstacles/Obstacle'
local Cactus = setmetatable({}, { __index = Obstacle })
Cactus.__index = Cactus

function Cactus:new()
    return Obstacle.new(self, 'images/cactus.png', 300)
end

return Cactus
