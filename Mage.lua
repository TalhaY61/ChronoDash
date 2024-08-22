Mage = Class{}

function Mage:init()
    self.image = love.graphics.newImage('images/mage.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- Position on the screen
    self.x = 100
    self.y = PLATFORM_HEIGHT - self.height

    -- Velocity and Gravity
    self.dy = 0 -- If dy is positive, the mage is falling; if negative, the mage is jumping
    self.gravity = 40

    self.jumpHeight = -20 -- Negative y value to move up; positive y value to move down
    self.isJumping = false
    self.canJump = true -- Variable to check if jump is allowed

    -- Custom hitbox dimensions
    -- TODO: Adjust the hitbox dimensions to fit the mage sprite, this collision is a crazy crap
    self.hitboxWidth = self.width * 0.7 -- Reduce the width of the hitbox
    self.hitboxHeight = self.height -- Reduce the height of the hitbox
    self.hitboxOffsetX = (self.width - self.hitboxWidth) / 4 -- Center the hitbox horizontally
    self.hitboxOffsetY = (self.height - self.hitboxHeight) / 2 -- Center the hitbox vertically
end


function Mage:collides(obstacle)
    -- Check if there is no overlap on the x axis using the smaller hitbox
    if self.x + self.hitboxOffsetX + self.hitboxWidth < obstacle.x or self.x + self.hitboxOffsetX > obstacle.x + obstacle.width then
        return false
    end

    -- Check if there is no overlap on the y axis using the smaller hitbox
    if self.y + self.hitboxOffsetY + self.hitboxHeight < obstacle.y or self.y + self.hitboxOffsetY > obstacle.y + obstacle.height then
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

    --[[Draw smaller collision box
    love.graphics.setColor(1, 0, 0, 0.5)  -- Set color to semi-transparent red
    love.graphics.rectangle('line', self.x + self.hitboxOffsetX, self.y + self.hitboxOffsetY, self.hitboxWidth, self.hitboxHeight)
    love.graphics.setColor(1, 1, 1, 1)  -- Reset color to white --]]
end
