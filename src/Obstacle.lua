local Obstacle = {}
Obstacle.__index = Obstacle

function Obstacle:new(imagePath, speed)
    local instance = setmetatable({}, Obstacle)
    instance:init(imagePath, speed)
    return instance
end

function Obstacle:init(imagePath, speed)
    self.image = love.graphics.newImage(imagePath)
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.x = WINDOW_WIDTH + self.width
    self.y = PLATFORM_HEIGHT - self.height
    self.speed = speed
end

function Obstacle:update(dt)
    self.x = self.x - self.speed * dt
end

function Obstacle:render()
    love.graphics.draw(self.image, self.x, self.y)
end

return Obstacle
