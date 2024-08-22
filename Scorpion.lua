-- Scorpion class
Scorpion = Class{}

function Scorpion:init() 
    self.image = love.graphics.newImage('scorpion.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- Set initial position off the right side of the screen
    self.x = WINDOW_WIDTH + self.width
    self.y = 660 - self.height -- Place the scorpion on the ground

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
    love.graphics.draw(self.image, self.x, self.y)

    -- Draw collision box
    love.graphics.setColor(1, 0, 0, 0.5)  -- Set color to semi-transparent red
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1, 1)  -- Reset color to white
end
