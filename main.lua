-- main.lua
Class = require 'class'
require 'Mage'
require 'Scorpion'
require 'Cactus'
require 'ObstaclesManager'

-- Physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Load the background and platform images
local background = love.graphics.newImage('background.png')
local platform = love.graphics.newImage('platform.png')

-- Initialize game entities
local mage = Mage() -- Mage instance
local obstaclesManager = ObstaclesManager() -- ObstaclesManager instance

-- Platform scrolling variables
local platformSpeed = 100
local platformScroll = 0

-- Pause variables, after collision
local isPaused = false
local pauseDuration = 2
local pauseTimer = 0    

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
    if isPaused then
        pauseTimer = pauseTimer - dt
        if pauseTimer <= 0 then
            isPaused = false -- Resume game
        end
        return -- Skip the rest of the update
    end

    -- Update platform scrolling
    platformScroll = (platformScroll + platformSpeed * dt) % platform:getWidth()

    -- Update the mage and obstacles
    mage:update(dt)
    obstaclesManager:update(dt)

    if obstaclesManager:checkCollisions(mage) then
        isPaused = true
        pauseTimer = pauseDuration
        print("Collision detected! Game paused.")
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
