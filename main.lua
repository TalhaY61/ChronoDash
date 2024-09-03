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

    -- Initialize the sounds
    initSounds()

    -- Initialize text fonts
    gFonts = {
        ['small'] = love.graphics.newFont('fonts/Orbitron-Regular.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/Orbitron-Medium.ttf', 16),
        ['bold'] = love.graphics.newFont('fonts/Orbitron-Bold.ttf', 32),
        ['extrabold'] = love.graphics.newFont('fonts/Orbitron-ExtraBold.ttf', 64)

    }
    love.graphics.setFont(gFonts['small'])

    -- Initialize keybindings sprites
    gKeybindingsSprites = {
        ['interact'] = love.graphics.newQuad(0, 0, 48, 48, keybindings:getDimensions()),
        ['restart'] = love.graphics.newQuad(0, 48, 48, 48, keybindings:getDimensions()),
        ['timeControlAbility'] = love.graphics.newQuad(48, 0, 48, 48, keybindings:getDimensions()),
        ['pause'] = love.graphics.newQuad(48, 48, 48, 48, keybindings:getDimensions()),
    }

    -- Initialize keybindings sprites
    gKeybindingsSprites2 = {
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

    if love.keyboard.wasPressed('m') then
        if backgroundMusic:isPlaying() then
            backgroundMusic:pause()
        else
            backgroundMusic:play()
        end
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
    love.graphics.draw(keybindings, gKeybindingsSprites['interact'], WINDOW_WIDTH - 300, 10)
    love.graphics.print("Interact", WINDOW_WIDTH - 250, 20)

    -- The Restart keybinding
    love.graphics.draw(keybindings, gKeybindingsSprites['restart'], WINDOW_WIDTH - 300, 40)
    love.graphics.print("Restart", WINDOW_WIDTH - 250, 50)
    
    -- The Time Control keybinding
    love.graphics.draw(keybindings, gKeybindingsSprites['timeControlAbility'], WINDOW_WIDTH - 170, 10)
    love.graphics.print("Time Control", WINDOW_WIDTH - 120, 20)

    -- The Pause keybinding
    love.graphics.draw(keybindings, gKeybindingsSprites['pause'], WINDOW_WIDTH - 170, 40)
    love.graphics.print("Pause", WINDOW_WIDTH - 120, 50)

    -- The Jump keybinding
    love.graphics.draw(keybindings_2, gKeybindingsSprites2['jump'], WINDOW_WIDTH - 300, 80)
    love.graphics.print("Jump", WINDOW_WIDTH - 230, 85)

    -- The Quit keybinding
    love.graphics.draw(keybindings_2, gKeybindingsSprites2['quit'], WINDOW_WIDTH - 170, 80)
    love.graphics.print("Quit", WINDOW_WIDTH - 110, 85)
end

function initSounds()
    -- Initialize sounds
    selectSound = love.audio.newSource('sounds/select.wav', 'static')
    selectSound:setVolume(0.2)

    jumpSound = love.audio.newSource('sounds/jump.wav', 'static')
    jumpSound:setVolume(0.3)

    hitSound = love.audio.newSource('sounds/hit.wav', 'static')
    hitSound:setVolume(0.3)

    gemstoneSound = love.audio.newSource('sounds/pickUpGemstone.wav', 'static')
    gemstoneSound:setVolume(0.3)

    timeControlAbilitySound = love.audio.newSource('sounds/timeControlAbility.wav', 'static')
    timeControlAbilitySound:setVolume(0.3)
    
    gameOverSound = love.audio.newSource('sounds/die.wav', 'static')
    gameOverSound:setVolume(0.3)

    backgroundMusic = love.audio.newSource('sounds/chronodash_song.mp3', 'stream')
    backgroundMusic:setLooping(true)
    backgroundMusic:setVolume(0.1)
    love.audio.play(backgroundMusic)
end
