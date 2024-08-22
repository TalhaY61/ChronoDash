Cactus = Class{}

local CACTUS_IMAGE = love.graphics.newImage('images/cactus.png')

function Cactus:init()
    self.width = CACTUS_IMAGE:getWidth()
    self.height = CACTUS_IMAGE:getHeight()

    -- Set initial position off the right side of the screen
    self.x = WINDOW_WIDTH + self.width + math.random(0, 300)
    self.y = PLATFORM_HEIGHT - self.height -- Place the cactus on the ground

    -- Set a speed for the cactus to move towards the player
    self.speed = 300
end

function Cactus:update(dt)
    -- Move the cactus left across the screen
    self.x = self.x - self.speed * dt

    -- Reset position if cactus moves off the screen
    if self.x < -self.width then
        self.x = WINDOW_WIDTH -- Respawn on the right
    end
end

function Cactus:render()
    love.graphics.draw(CACTUS_IMAGE, self.x, self.y)
end
