local Obstacle = require 'src/Obstacle'
local Scorpion = setmetatable({}, { __index = Obstacle })
Scorpion.__index = Scorpion

function Scorpion:new()
    return Obstacle.new(self, 'images/scorpion.png', 300)
end

return Scorpion
