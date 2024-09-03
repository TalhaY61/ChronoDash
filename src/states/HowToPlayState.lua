-- src/states/HowToPlayState.lua
local HowToPlayState = {}

-- Load the keybindings and background
local keybindings = love.graphics.newImage('images/keybindings.png')
local keybindings_2 = love.graphics.newImage('images/keybindings_2.png')

local gKeybindingsSprites = {
    ['interact'] = love.graphics.newQuad(0, 0, 64, 64, keybindings:getDimensions()),
    ['restart'] = love.graphics.newQuad(0, 64, 64, 64, keybindings:getDimensions()),
    ['timeControlAbility'] = love.graphics.newQuad(64, 0, 64, 64, keybindings:getDimensions()),
    ['pause'] = love.graphics.newQuad(64, 64, 64, 64, keybindings:getDimensions()),
}

local gKeybindingsSprites2 = {
    ['jump'] = love.graphics.newQuad(0, 0, 128, 64, keybindings_2:getDimensions()),
    ['quit'] = love.graphics.newQuad(0, 64, 128, 64, keybindings_2:getDimensions()),
}

function HowToPlayState:enter()
    
end

function HowToPlayState:update()
    if love.keyboard.wasPressed('q') then
        gameStateManager:change('menu')
    end
end

function HowToPlayState:draw()
    -- Draw the background
    love.graphics.draw(BACKGROUND, 0, 0)

    -- Calculate the positions to center the keybindings
    local centerX = (WINDOW_WIDTH - 300) / 2
    local centerY = (WINDOW_HEIGHT - 150) / 2
    
    -- Display the keybindings on the screen

    -- The Interact keybinding (not implemented yet)
    -- love.graphics.draw(keybindings, gKeybindingsSprites['interact'], WINDOW_WIDTH / 2, 10)
    -- love.graphics.print("Interact", WINDOW_WIDTH / 2, 20)

    love.graphics.setFont(gFonts['medium'])
    love.graphics.print("Press Q to go back to the menu", centerX, centerY - 50)

    -- The Restart keybinding
    love.graphics.draw(keybindings, gKeybindingsSprites['restart'], centerX - 50, centerY)
    love.graphics.print("Restart", centerX + 10, centerY + 20)
    
    -- The Time Control keybinding
    love.graphics.draw(keybindings, gKeybindingsSprites['timeControlAbility'], centerX - 50, centerY + 50)
    love.graphics.print("Time Control", centerX + 10, centerY + 70)

    -- The Pause keybinding
    love.graphics.draw(keybindings, gKeybindingsSprites['pause'], centerX - 50, centerY + 100)
    love.graphics.print("Pause", centerX + 10, centerY + 120)

    -- The Jump keybinding
    love.graphics.draw(keybindings_2, gKeybindingsSprites2['jump'], centerX + 150, centerY)
    love.graphics.print("Jump (x2 for Doublejump)", centerX + 270, centerY + 20)

    -- The Quit keybinding
    love.graphics.draw(keybindings_2, gKeybindingsSprites2['quit'], centerX + 135, centerY + 50)
    love.graphics.print("Quit", centerX + 240, centerY + 70)
end

return HowToPlayState
