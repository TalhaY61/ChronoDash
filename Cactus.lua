
Cactus = Class{}

function Cactus:init()
    self.image = love.graphics.newImage('cactus.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- Set initial position off the right side of the screen
    self.x = WINDOW_WIDTH + self.width + math.random(0, 300)
    self.y = 660 - self.height -- Place the cactus on the ground

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
    love.graphics.draw(self.image, self.x, self.y)

    -- Draw collision box
    love.graphics.setColor(1, 0, 0, 0.5)  -- Set color to semi-transparent red
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1, 1)  -- Reset color to white
end
