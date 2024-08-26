-- Load the modules
local Mage = require 'src/Mage'
local ObstaclesManager = require 'src/obstacles/ObstaclesManager'
local TimeControl = require 'src/abilities/TimeControl'

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
local timeControlAbility = TimeControl:new()    -- BaseAbility instance

-- Platform SCROLLING variables
local platformSpeed = 100
local platformScroll = 0
-- Background scrolling baş döndürüyor yaw xd
-- local backgroundSpeed = 100
-- local backgroundScroll = 0

GAMESTATE = 'menu'
local highlighted = 1

-- Pause variables, after collision
SCROLLING = true

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    love.window.setTitle('Chrono Dash')

    -- initialize our nice-looking retro text fonts
    gFonts = {
        ['small'] = love.graphics.newFont('fonts/Orbitron-Regular.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/Orbitron-Medium.ttf', 16),
        ['bold'] = love.graphics.newFont('fonts/Orbitron-Bold.ttf', 32)
    }
    love.graphics.setFont(gFonts['small'])

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

    if GAMESTATE == 'menu' then
        -- Menüsteuerung hier
        if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
            highlighted = highlighted == 1 and 2 or 1
        end
    
        -- confirm whichever option we have selected to change screens
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    
            if highlighted == 1 then
                GAMESTATE = 'play'
            end

            if highlighted == 2 then
                love.event.quit()
            end
        end
    
        -- we no longer have this globally, so include here
        if love.keyboard.wasPressed('escape') then
            love.event.quit()
        end

    elseif GAMESTATE == 'play' then
        if SCROLLING then
            -- Update platform SCROLLING
            platformScroll = (platformScroll + platformSpeed * dt) % platform:getWidth()
            --backgroundScroll = (backgroundScroll + backgroundSpeed * dt) % background:getWidth()

            -- Update the mage and obstacles
            mage:update(dt)
            -- Update the obstacles with the scaled delta time, for the time control ability
            local isTimeControlActive = mage.abilities.timeControl.isActive
            obstaclesManager:update(dt, isTimeControlActive)

            -- Check for collisions between mage and obstacles
            if obstaclesManager:checkCollisions(mage) then
                mage:takeDamage(1)
            end
        end
    elseif GAMESTATE == 'gameover' then
        -- Überprüfen, ob der Spieler neu starten möchte
        if love.keyboard.wasPressed('r') then
            GAMESTATE = 'menu'
            -- Spiel zurücksetzen, Leben wiederherstellen, Hindernisse löschen usw.
            mage:init()
            obstaclesManager:init()
        end
    end

    love.keyboard.keysPressed = {}
end

function love.draw()

    love.graphics.setFont(gFonts['bold'])

    if GAMESTATE == 'menu' then
        if highlighted == 1 then
            love.graphics.setColor(103/255, 1, 1, 1)
        end
        love.graphics.printf("START", 0, WINDOW_HEIGHT / 2 + 70, WINDOW_WIDTH, 'center')
    
        -- reset the color
        love.graphics.setColor(1, 1, 1, 1)
    
        -- render option 2 blue if we're highlighting that one
        if highlighted == 2 then
            love.graphics.setColor(103/255, 1, 1, 1)
        end
        love.graphics.printf("QUIT", 0, WINDOW_HEIGHT / 2 + 140, WINDOW_WIDTH, 'center')
    
        -- reset the color
        love.graphics.setColor(1, 1, 1, 1)

    elseif GAMESTATE == 'play' then
        -- Draw the background
        love.graphics.draw(background, 0, 0)
        -- love.graphics.draw(background, -backgroundScroll + background:getWidth(), 0)

        -- Draw the SCROLLING platforms
        love.graphics.draw(platform, -platformScroll, 655)
        love.graphics.draw(platform, -platformScroll + platform:getWidth(), 655)

        -- Draw the FPS in the upper left corner
        displayFPS()

        -- Draw the mage and obstacles
        mage:render()
        obstaclesManager:render()
        timeControlAbility:render()
    elseif GAMESTATE == 'gameover' then
        love.graphics.printf("GAME OVER", 0, WINDOW_HEIGHT / 2 - 20, WINDOW_WIDTH, 'center')
        love.graphics.printf("Press R to Restart", 0, WINDOW_HEIGHT / 2 + 20, WINDOW_WIDTH, 'center')
    end
end

function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(1, 1, 1) -- White for the text
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end