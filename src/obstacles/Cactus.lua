local Obstacle = require 'src/Obstacle'
local Cactus = setmetatable({}, { __index = Obstacle })
Cactus.__index = Cactus

function Cactus:new(speed)
    return Obstacle.new(self, 'images/cactus.png', speed)
end

return Cactus
