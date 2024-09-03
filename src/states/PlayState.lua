local PlayState = {}

-- Load the modules
local Mage = require 'src/Mage'
local ObstaclesManager = require 'src/obstacles/ObstaclesManager'
local TimeControlAbility = require 'src/abilities/TimeControlAbility'
local LevelManager = require 'src/LevelManager'
local Gemstone = require 'src/gemstones/Gemstone'

-- Platform height
PLATFORM_HEIGHT = 660

-- Load the background and platform images
BACKGROUND = love.graphics.newImage('images/background.png')
PLATFORM = love.graphics.newImage('images/platform.png')

-- Initialize game entities
local mage = Mage:new()                         -- Mage instance
local obstaclesManager = ObstaclesManager:new() -- ObstaclesManager instance
local timeControlAbilityAbility = TimeControlAbility:new()    -- BaseAbility instance
local gemstone = Gemstone:new()               -- Gemstones instance

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
            local isTimeControlAbilityActive = mage.abilities.timeControlAbility.isActive
            local getLevel = levelManager:getCurrentLevel()
            
            obstaclesManager:update(dt, isTimeControlAbilityActive, getLevel)
            timeControlAbilityAbility:update(dt)
            gemstone:update(dt, getLevel)

            local collectedGemstone = gemstone:checkGemstone(mage)
            if collectedGemstone then
                if collectedGemstone == 'blue' then
                    levelManager:addScore(10)
                elseif collectedGemstone == 'red' then
                    mage:addHealth(1)
                elseif collectedGemstone == 'green' then
                    levelManager:addScore(30)
                end
            end

            if obstaclesManager:removeObstacles() then
                levelManager:addScore(1)
            end

            if obstaclesManager:checkCollisions(mage) then
                mage:takeDamage(1)
                if mage.health <= 0 then
                    gameStateManager:change('gameover', levelManager:getScore())
                end
            end
            
            levelManager:update()
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
    gemstone:render()
    timeControlAbilityAbility:render()

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
    -- Simple FPS display across all states
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(1, 1, 1) -- White
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end

function displayCountdown() 
    -- Display the countdown before the game starts
    if countdown > 0 then
        love.graphics.setFont(gFonts['bold'])
        love.graphics.printf(tostring(math.ceil(countdown)), 0, WINDOW_HEIGHT / 2 - 160, WINDOW_WIDTH, 'center')
    end
end

function displayPauseMenu()
    -- Display the pause menu
    love.graphics.setFont(gFonts['bold'])
    love.graphics.printf('PAUSED', 0, 100, WINDOW_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press P to resume', 0, 160, WINDOW_WIDTH, 'center')
end

return PlayState
