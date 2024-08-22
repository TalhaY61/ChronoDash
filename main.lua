-- main.lua
Class = require 'class'

require 'Mage'
require 'Scorpion'
require 'Cactus'
require 'ObstaclesManager'

-- Physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Platform height
PLATFORM_HEIGHT = 660

-- Load the background and platform images
local background = love.graphics.newImage('images/background.png')
local platform = love.graphics.newImage('images/platform.png')

-- Initialize game entities
local mage = Mage() -- Mage instance
local obstaclesManager = ObstaclesManager() -- ObstaclesManager instance

-- Platform scrolling variables
local platformSpeed = 100
local platformScroll = 0

-- Pause variables, after collision
local scrolling = true
local spawnTimer = 0    

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    love.window.setTitle('Chrono Dash')

    love.keyboard.keysPressed = {}
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

    if scrolling then
        -- Update platform scrolling
        platformScroll = (platformScroll + platformSpeed * dt) % platform:getWidth()

        spawnTimer = spawnTimer + dt

        if spawnTimer >= 3 then 
            obstaclesManager:spawnObstacle()
            spawnTimer = 0
        end

        -- Update the mage and obstacles
        mage:update(dt)
        obstaclesManager:update(dt)

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

    -- Draw the mage and obstacles
    mage:render()
    obstaclesManager:render()
end
