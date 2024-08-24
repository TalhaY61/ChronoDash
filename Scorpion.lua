local Scorpion = {}
Scorpion.__index = Scorpion

function Scorpion:new()
    local instance = setmetatable({}, Scorpion)
    instance:init()
    return instance
end

function Scorpion:init()
    self.image = love.graphics.newImage('images/scorpion.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = WINDOW_WIDTH + self.width
    self.y = PLATFORM_HEIGHT - self.height

    self.speed = 300
end

function Scorpion:update(dt)
    self.x = self.x - self.speed * dt

    if self.x < -self.width then
        self.x = WINDOW_WIDTH
    end
end

function Scorpion:render()
    love.graphics.draw(self.image, self.x, self.y)
end

return Scorpion
