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

-- Load the keybindings 
local keybindings = love.graphics.newImage('images/keybindings.png')
local keybindings_2 = love.graphics.newImage('images/keybindings_2.png')

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
-- Highlighted option in the menu
local highlighted = 1

-- Countdown for gamestart after gameover
local countdown = 3

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

    gkeybindingsSprites = {
        ['interact'] = love.graphics.newQuad(0, 0, 48, 48, keybindings:getDimensions()),
        ['restart'] = love.graphics.newQuad(0, 48, 48, 48, keybindings:getDimensions()),
        ['timeControl'] = love.graphics.newQuad(48, 0, 48, 48, keybindings:getDimensions()),
        ['pause'] = love.graphics.newQuad(48, 48, 48, 48, keybindings:getDimensions()),
    }

    gkeybindingsSprites2 = {
        ['jump'] = love.graphics.newQuad(0, 0, 64, 32, keybindings_2:getDimensions()),
        ['quit'] = love.graphics.newQuad(0, 32, 64, 32, keybindings_2:getDimensions()),
    }

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
        if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
            -- if highlighted is 1, set it to 2, and if it is not 1 set it to 1.
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
    elseif GAMESTATE == 'play' then
        if SCROLLING then
            countdown = countdown - dt

            if countdown <= 0 then
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
        end
    elseif GAMESTATE == 'gameover' then
        if love.keyboard.wasPressed('r') then
            GAMESTATE = 'menu'
            countdown = 3
            mage:init()
            obstaclesManager:init()
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
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

        -- Display countdown before game starts
        displayCountdown()

        displayKeybindings()

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

function displayCountdown() 
    if countdown > 0 then
        love.graphics.setFont(gFonts['bold'])
        love.graphics.printf(tostring(math.ceil(countdown)), 0, WINDOW_HEIGHT / 2 - 160, WINDOW_WIDTH, 'center')
    end
end

function displayKeybindings() 
    -- Keybindings in der oberen rechten Ecke anzeigen und skaliren
    love.graphics.setFont(gFonts['medium'])
    -- Set the keybinding sprites to the right corner and next to it the text
    love.graphics.draw(keybindings, gkeybindingsSprites['interact'], WINDOW_WIDTH - 300, 10)
    love.graphics.print("Interact", WINDOW_WIDTH - 250, 20)

    love.graphics.draw(keybindings, gkeybindingsSprites['restart'], WINDOW_WIDTH - 300, 40)
    love.graphics.print("Restart", WINDOW_WIDTH - 250, 50)

    love.graphics.draw(keybindings, gkeybindingsSprites['timeControl'], WINDOW_WIDTH - 170, 10)
    love.graphics.print("Time Control", WINDOW_WIDTH - 120, 20)

    love.graphics.draw(keybindings, gkeybindingsSprites['pause'], WINDOW_WIDTH - 170, 40)
    love.graphics.print("Pause", WINDOW_WIDTH - 120, 50)

    love.graphics.draw(keybindings_2, gkeybindingsSprites2['jump'], WINDOW_WIDTH - 300, 80)
    love.graphics.print("Jump", WINDOW_WIDTH - 230, 85)

    love.graphics.draw(keybindings_2, gkeybindingsSprites2['quit'], WINDOW_WIDTH - 170, 80)
    love.graphics.print("Quit", WINDOW_WIDTH - 110, 85)
end
