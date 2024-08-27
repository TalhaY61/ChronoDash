local Mage = {}
Mage.__index = Mage

local TimeControl = require 'src/abilities/TimeControl'
local ObstaclesManager = require "src/obstacles/ObstaclesManager"

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

    self.heartImage = love.graphics.newImage('images/mage_hearts_all.png')
    self.sprites = {
        full = love.graphics.newQuad(0, 0, 32, 32, self.heartImage:getDimensions()),
        half = love.graphics.newQuad(32, 0, 32, 32, self.heartImage:getDimensions()),
        empty = love.graphics.newQuad(0, 32, 32, 32, self.heartImage:getDimensions())
    }
    self.currentQuad = self.sprites.full

    -- Position on the screen
    self.x = 100
    self.y = PLATFORM_HEIGHT - self.height

    -- Velocity and Gravity
    self.dy = 0
    self.gravity = 40

    -- Jumping variables
    self.jumpHeight = -15
    self.jumpCount = 0
    self.maxJumps = 2

    -- Health variables
    self.health = 3
    self.isInvincible = false
    self.invincibleTimer = 0
    self.invincibleDuration = 1

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

    if self.isInvincible then
        self.invincibleTimer = self.invincibleTimer - dt
        if self.invincibleTimer <= 0 then
            self.isInvincible = false
        end
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

function Mage:takeDamage(amount)
    if not self.isInvincible then
        self.health = self.health - amount
        self.isInvincible = true
        self.invincibleTimer = self.invincibleDuration
        
        if self.health == 0 then
            self:die()
        end
    end
end

function Mage:die()
    GAMESTATE = 'gameover'
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
    
    for i = 1, self.health do
        love.graphics.draw(self.heartImage, self.currentQuad, 10 + (i - 1) * 32, 30)
    end
end

return Mage
