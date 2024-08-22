Scorpion = Class{}

local SCORPION_IMAGE = love.graphics.newImage('images/scorpion.png')

function Scorpion:init() 
    self.width = SCORPION_IMAGE:getWidth()
    self.height = SCORPION_IMAGE:getHeight()

    -- Set initial position off the right side of the screen
    self.x = WINDOW_WIDTH + self.width
    self.y = PLATFORM_HEIGHT - self.height -- Place the scorpion on the ground

    -- Set a speed for the scorpion to move towards the player
    self.speed = 300
end

function Scorpion:update(dt)
    -- Move the scorpion left across the screen
    self.x = self.x - self.speed * dt

    -- Reset position if scorpion moves off the screen
    if self.x < -self.width then
        self.x = WINDOW_WIDTH -- Respawn on the right
    end
end

function Scorpion:render()
    love.graphics.draw(SCORPION_IMAGE, self.x, self.y)
end
