local Mage = {}
Mage.__index = Mage

local TimeControl = require 'src/abilities/TimeControl'

function Mage:new()
    local instance = setmetatable({}, Mage)
    instance:init()
    instance.abilities = {
        timeControl = TimeControl:new()
    }
    return instance
end

function Mage:init()
    self.image = love.graphics.newImage('images/mage.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- Position on the screen
    self.x = 100
    self.y = PLATFORM_HEIGHT - self.height

    -- Velocity and Gravity
    self.dy = 0
    self.gravity = 40

    self.jumpHeight = -15
    self.jumpCount = 0
    self.maxJumps = 2

    -- Custom hitbox dimensions
    self.hitboxWidth = self.width * 0.7
    self.hitboxHeight = self.height
    self.hitboxOffsetX = (self.width - self.hitboxWidth) / 4
    self.hitboxOffsetY = (self.height - self.hitboxHeight) / 2
    
end

function Mage:collides(obstacle)
    if self.x + self.hitboxOffsetX + self.hitboxWidth < obstacle.x or
       self.x + self.hitboxOffsetX > obstacle.x + obstacle.width then
        return false
    end

    if self.y + self.hitboxOffsetY + self.hitboxHeight < obstacle.y or
       self.y + self.hitboxOffsetY > obstacle.y + obstacle.height then
        return false
    end

    return true
end

function Mage:update(dt)
    -- Apply gravity to the mage
    self.dy = self.dy + self.gravity * dt
    self.y = self.y + self.dy

    -- Prevent the mage from falling through the platform
    if self.y >= PLATFORM_HEIGHT - self.height then
        self.y = PLATFORM_HEIGHT - self.height
        self.dy = 0
        self.jumpCount = 0
    end

    if love.keyboard.wasPressed('space') and self.jumpCount < self.maxJumps then
       self:handleJump()
    end

    if love.keyboard.wasPressed('t') then
        self:timeControlAbility()
    end

    self:handleAbilities(dt)
end

function Mage:handleJump()
    self.dy = self.jumpHeight
    self.jumpCount = self.jumpCount + 1
end

function Mage:timeControlAbility()
    self.abilities.timeControl:activate()
end

function Mage:handleAbilities(dt)
    for _, ability in pairs(self.abilities) do
        ability:update(dt)
    end
end

function Mage:render()
    love.graphics.draw(self.image, self.x, self.y)
end

return Mage
