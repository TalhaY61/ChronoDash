local Obstacle = require 'src/Obstacle'
local Vulture = setmetatable({}, { __index = Obstacle })
Vulture.__index = Vulture

function Vulture:new(speed)
    local instance = Obstacle.new(self, 'images/vulture.png', speed)
    
    -- Set the vulture's height to 100 pixels above the platform
    instance.y = PLATFORM_HEIGHT - instance.height - 150
    self.speed = speed + 50
    
    return instance
end

return Vulture
