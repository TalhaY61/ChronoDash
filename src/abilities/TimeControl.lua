local BaseAbility = require 'src/abilities/BaseAbility'

local TimeControl = setmetatable({}, {__index = BaseAbility})
TimeControl.__index = TimeControl

function TimeControl:new()
    local instance = BaseAbility:new()
    setmetatable(instance, TimeControl)
    
    instance:init()
    return instance
end

function TimeControl:init() 
    self.image = love.graphics.newImage('images/timeControlAbility_all.png')
    self.sprites = {
        start = love.graphics.newQuad(0, 0, 32, 32, self.image:getDimensions()),
        active = love.graphics.newQuad(32, 0, 32, 32, self.image:getDimensions()),
        finished = love.graphics.newQuad(0, 32, 32, 32, self.image:getDimensions())
    }
    self.currentQuad = self.sprites.start

    -- Ability-specific variables
    self.activeDuration = 3      -- TimeControl active for 3 seconds
    self.cooldownDuration = 10    -- 5 seconds cooldown
    self.isActive = false
    self.isCooldown = false
    self.timer = 0
end

function TimeControl:activate()
    if not self.isActive and not self.isCooldown then
        self.isActive = true
        self.currentQuad = self.sprites.active
        self.timer = self.activeDuration
    end
end

function TimeControl:update(dt)
    if self.isActive then
        self.timer = self.timer - dt
        if self.timer <= 0 then
            self.isActive = false
            self.isCooldown = true
            self.timer = self.cooldownDuration
            self.currentQuad = self.sprites.finished
        end
    elseif self.isCooldown then
        self.timer = self.timer - dt
        if self.timer <= 0 then
            self.isCooldown = false
            self.currentQuad = self.sprites.start
        end
    end
end

function TimeControl:render()
    love.graphics.draw(self.image, self.currentQuad, 10, 70)
end

return TimeControl
