local PlayState = {}

-- Load the modules
local Mage = require 'src/Mage'
local ObstaclesManager = require 'src/obstacles/ObstaclesManager'
local TimeControl = require 'src/abilities/TimeControl'
local LevelManager = require 'src/LevelManager'

-- Platform height
PLATFORM_HEIGHT = 660

-- Load the background and platform images
BACKGROUND = love.graphics.newImage('images/background.png')
PLATFORM = love.graphics.newImage('images/platform.png')

-- Initialize game entities
local mage = Mage:new()                         -- Mage instance
local obstaclesManager = ObstaclesManager:new() -- ObstaclesManager instance
local timeControlAbility = TimeControl:new()    -- BaseAbility instance

local levelManager = LevelManager:new()

-- Pause variables, after collision
SCROLLING = true

-- Platform SCROLLING variables
local platformSpeed = 100
local platformScroll = 0

-- Countdown for game start
local countdown = 3

function PlayState:enter()
    -- Initialize the game entities
    mage:init()
    obstaclesManager:init()

    levelManager:reset()

    countdown = 3
    SCROLLING = true
end

function PlayState:update(dt)
    if SCROLLING then
        countdown = countdown - dt

        if countdown <= 0 then
            platformScroll = (platformScroll + platformSpeed * dt) % PLATFORM:getWidth()

            mage:update(dt)
            local isTimeControlActive = mage.abilities.timeControl.isActive
            local getLevel = levelManager:getCurrentLevel()
            obstaclesManager:update(dt, isTimeControlActive, getLevel)

            if obstaclesManager:removeObstacles() then
                levelManager:addScore(10)
            end

            if obstaclesManager:checkCollisions(mage) then
                mage:takeDamage(1)
                if mage.health <= 0 then
                    levelManager:reset()
                    gameStateManager:change('gameover')
                end
            end

            levelManager:update(dt)
        end
    end

    if love.keyboard.wasPressed('p') then
        SCROLLING = not SCROLLING
        displayCountdown()
    end
end


function PlayState:draw()
    love.graphics.draw(BACKGROUND, 0, 0)

    love.graphics.draw(PLATFORM, -platformScroll, 655)
    love.graphics.draw(PLATFORM, -platformScroll + PLATFORM:getWidth(), 655)

    displayFPS()
    displayCountdown()
    displayKeybindings()

    mage:render()
    obstaclesManager:render()
    timeControlAbility:render()

    -- Display the score and current level in the center at the top of the screen
    local scoreText = "Score: " .. tostring(levelManager:getScore())
    local levelText = "Level: " .. tostring(levelManager:getCurrentLevel())

    local combinedText = scoreText .. " | " .. levelText
    local textWidth = love.graphics.getFont():getWidth(combinedText)
    local textHeight = love.graphics.getFont():getHeight()

    love.graphics.printf(combinedText, (WINDOW_WIDTH - textWidth) / 2, textHeight / 2, textWidth, 'center')



    if not SCROLLING then
        displayPauseMenu()
    end
end


function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(1, 1, 1) -- White
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end

function displayCountdown() 
    -- display the countdown before the game starts
    if countdown > 0 then
        love.graphics.setFont(gFonts['bold'])
        love.graphics.printf(tostring(math.ceil(countdown)), 0, WINDOW_HEIGHT / 2 - 160, WINDOW_WIDTH, 'center')
    end
end

function displayPauseMenu()
    love.graphics.setFont(gFonts['bold'])
    love.graphics.printf('PAUSED', 0, 100, WINDOW_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press P to resume', 0, 160, WINDOW_WIDTH, 'center')
end

return PlayState
