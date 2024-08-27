-- Load the StateManager and the states
local StateManager = require 'src/states/StateManager'
local MenuState = require 'src/states/MenuState'
local PlayState = require 'src/states/PlayState'
local GameOverState = require 'src/states/GameOverState'

-- Physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Load the keybindings 
local keybindings = love.graphics.newImage('images/keybindings.png')
local keybindings_2 = love.graphics.newImage('images/keybindings_2.png')

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    love.window.setTitle('Chrono Dash')

    -- initialize our nice-looking retro text fonts
    gFonts = {
        ['small'] = love.graphics.newFont('fonts/Orbitron-Regular.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/Orbitron-Medium.ttf', 16),
        ['bold'] = love.graphics.newFont('fonts/Orbitron-Bold.ttf', 32),
        ['extrabold'] = love.graphics.newFont('fonts/Orbitron-ExtraBold.ttf', 64)

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

    -- Create a new StateManager
    gameStateManager = StateManager:new()
    gameStateManager:add('menu', MenuState)
    gameStateManager:add('play', PlayState)
    gameStateManager:add('gameover', GameOverState)

    -- Start the game with the menu state
    gameStateManager:change('menu')

    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key] or false
end

function love.update(dt)
    gameStateManager:update(dt)
    love.keyboard.keysPressed = {}
end

function love.draw()
    gameStateManager:draw()
end

function displayKeybindings() 
    -- Display the keybindings on the screen

    love.graphics.setFont(gFonts['medium'])
    -- The Interact keybinding (not implemented yet)
    love.graphics.draw(keybindings, gkeybindingsSprites['interact'], WINDOW_WIDTH - 300, 10)
    love.graphics.print("Interact", WINDOW_WIDTH - 250, 20)

    -- The Restart keybinding
    love.graphics.draw(keybindings, gkeybindingsSprites['restart'], WINDOW_WIDTH - 300, 40)
    love.graphics.print("Restart", WINDOW_WIDTH - 250, 50)
    
    -- The Time Control keybinding
    love.graphics.draw(keybindings, gkeybindingsSprites['timeControl'], WINDOW_WIDTH - 170, 10)
    love.graphics.print("Time Control", WINDOW_WIDTH - 120, 20)

    -- The Pause keybinding
    love.graphics.draw(keybindings, gkeybindingsSprites['pause'], WINDOW_WIDTH - 170, 40)
    love.graphics.print("Pause", WINDOW_WIDTH - 120, 50)

    -- The Jump keybinding
    love.graphics.draw(keybindings_2, gkeybindingsSprites2['jump'], WINDOW_WIDTH - 300, 80)
    love.graphics.print("Jump", WINDOW_WIDTH - 230, 85)

    -- The Quit keybinding
    love.graphics.draw(keybindings_2, gkeybindingsSprites2['quit'], WINDOW_WIDTH - 170, 80)
    love.graphics.print("Quit", WINDOW_WIDTH - 110, 85)
end

