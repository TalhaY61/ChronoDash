local Obstacle = require 'src/Obstacle'
local Scorpion = setmetatable({}, { __index = Obstacle })
Scorpion.__index = Scorpion

function Scorpion:new(speed)
    return Obstacle.new(self, 'images/scorpion.png', speed)
end

return Scorpion
