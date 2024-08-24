-- Load the modules
local Mage = require 'src/Mage'
local ObstaclesManager = require 'src/obstacles/ObstaclesManager'

-- Physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Platform height
PLATFORM_HEIGHT = 660

-- Load the background and platform images
local background = love.graphics.newImage('images/background.png')
local platform = love.graphics.newImage('images/platform.png')

-- Initialize game entities
local mage = Mage:new()                         -- Mage instance
local obstaclesManager = ObstaclesManager:new() -- ObstaclesManager instance

-- Platform scrolling variables
local platformSpeed = 100
local platformScroll = 0

-- Pause variables, after collision
local scrolling = true

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    love.window.setTitle('Chrono Dash')

    love.keyboard.keysPressed = {}

    _G.timeScale = 1  -- Setze die Zeit-Skala beim Laden des Spiels zurück
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key] or false
end

function love.update(dt)

    -- Update the time scale, its for the time control ability
    local scaledDt = dt * (_G.timeScale or 1)

    if scrolling then
        -- Update platform scrolling
        platformScroll = (platformScroll + platformSpeed * dt) % platform:getWidth()

        -- Update the mage and obstacles
        mage:update(dt)
        -- Update the obstacles with the scaled delta time, for the time control ability
        obstaclesManager:update(scaledDt)

        -- Check for collisions between mage and obstacles
        if obstaclesManager:checkCollisions(mage) then
            scrolling = false
        end
    end

    love.keyboard.keysPressed = {}
end

function love.draw()
    -- Draw the background
    love.graphics.draw(background, 0, 0)

    -- Draw the scrolling platforms
    love.graphics.draw(platform, -platformScroll, 655)
    love.graphics.draw(platform, -platformScroll + platform:getWidth(), 655)

    -- Draw the FPS in the upper left corner
    love.graphics.setColor(1, 1, 1) -- White for the text
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)

    -- Draw the mage and obstacles
    mage:render()
    obstaclesManager:render()
end
