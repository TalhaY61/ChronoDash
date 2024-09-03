-- Load the StateManager and the states
local StateManager = require 'src/states/StateManager'
local MenuState = require 'src/states/MenuState'
local HowToPlayState = require 'src/states/HowToPlayState'
local PlayState = require 'src/states/PlayState'
local GameOverState = require 'src/states/GameOverState'

-- Physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

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

    -- Create a new StateManager
    gameStateManager = StateManager:new()
    gameStateManager:add('menu', MenuState)
    gameStateManager:add('howtoplay', HowToPlayState)
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
