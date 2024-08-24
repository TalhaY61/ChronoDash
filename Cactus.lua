local Cactus = {}
Cactus.__index = Cactus

function Cactus:new()
    local instance = setmetatable({}, Cactus)
    instance:init()
    return instance
end

function Cactus:init()
    self.image = love.graphics.newImage('images/cactus.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = WINDOW_WIDTH + self.width + math.random(0, 300)
    self.y = PLATFORM_HEIGHT - self.height

    self.speed = 300
end

function Cactus:update(dt)
    self.x = self.x - self.speed * dt

    if self.x < -self.width then
        self.x = WINDOW_WIDTH
    end
end

function Cactus:render()
    love.graphics.draw(self.image, self.x, self.y)
end

return Cactus
