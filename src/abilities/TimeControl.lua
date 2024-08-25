local BaseAbility = require 'src/abilities/BaseAbility'

local TimeControl = setmetatable({}, {__index = BaseAbility})
TimeControl.__index = TimeControl

-- Constructor for TimeControl
function TimeControl:new()
    local instance = BaseAbility:new()
    setmetatable(instance, TimeControl)
    
    instance:init()
    return instance
end

-- Initialize sprites and image
function TimeControl:init() 
    self.image = love.graphics.newImage('images/timeControlAbility_all.png')
    self.sprites = {
        ready = love.graphics.newQuad(0, 0, 32, 32, self.image:getDimensions()),
        active = love.graphics.newQuad(32, 0, 32, 32, self.image:getDimensions()),
        cooldown = love.graphics.newQuad(0, 32, 32, 32, self.image:getDimensions())
    }
    self.currentQuad = self.sprites.ready
end

-- Activate the ability
function TimeControl:activate()
end

-- Update the ability state
function TimeControl:update(dt)
end

-- Render the ability icon
function TimeControl:render()
    love.graphics.draw(self.image, self.currentQuad, 10, 70)
end

return TimeControl
