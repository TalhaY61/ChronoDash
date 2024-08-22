Mage = Class{}

function Mage:init()
    self.image = love.graphics.newImage('mage.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- Position on the screen
    self.x = 100
    self.y = 660 - self.height

    -- Velocity and Gravity
    self.dy = 0 -- If dy is positive, the mage is falling; if negative, the mage is jumping
    self.gravity = 40

    self.jumpHeight = -18 -- Negative y value to move up; positive y value to move down
    self.isJumping = false
    self.canJump = true -- Variable to check if jump is allowed
end

function Mage:collides(scorpion)
    -- Check if there is no overlap on the x axis
    if self.x + self.width - 10 < scorpion.x or self.x > scorpion.x + scorpion.width then
        return false
    end

    -- Check if there is no overlap on the y axis
    if self.y + self.height - 10 < scorpion.y or self.y > scorpion.y + scorpion.height then
        return false
    end

    -- If there is overlap on both x and y axis, collision detected
    return true
end



function Mage:update(dt)
    -- Jumping
    if love.keyboard.wasPressed('space') and self.canJump then
        self.isJumping = true
        self.dy = self.jumpHeight
        self.canJump = false -- Prevent continuous jumping
    end

    -- Apply gravity
    self.dy = self.dy + self.gravity * dt
    self.y = self.y + self.dy

    -- Reset jump when the mage hits the ground
    if self.y >= 660 - self.height then
        self.y = 660 - self.height
        self.dy = 0
        self.isJumping = false
        self.canJump = true -- Allow jumping again
    end
end

function Mage:render()
    love.graphics.draw(self.image, self.x, self.y)

    -- Draw collision box
    love.graphics.setColor(1, 0, 0, 0.5)  -- Set color to semi-transparent red
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1, 1)  -- Reset color to white
end
