-- classic OOP class library
Class = require 'class'

-- Mage class
require 'Mage'

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- Load the background and platform images
local background = love.graphics.newImage('background.png')
local platform = love.graphics.newImage('platform.png')

local platformSpeed = 100
local platformScroll = 0

local mage = Mage()  -- Mage Instance

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    love.window.setTitle('Chrono Dash')

    -- initialize input table
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
    -- Update platform scrolling
    platformScroll = (platformScroll + platformSpeed * dt) % platform:getWidth()

    -- Update the mage
    mage:update(dt)

    -- Reset input table
    love.keyboard.keysPressed = {}
end

function love.draw()
    -- Draw the background
    love.graphics.draw(background, 0, 0)

    -- Draw the scrolling platforms
    love.graphics.draw(platform, -platformScroll, 655)
    love.graphics.draw(platform, -platformScroll + platform:getWidth(), 655)

    -- Draw the mage
    mage:render()
end
