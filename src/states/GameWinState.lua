local GameWinState = {}

function GameWinState:enter()
    
end

function GameWinState:update(dt)
    if love.keyboard.wasPressed('r') then
        gameStateManager:change('play')
    end
end

function GameWinState:draw()
    love.graphics.setFont(gFonts['bold'])
    love.graphics.draw(BACKGROUND, 0, 0)
    love.graphics.printf("YOU WIN", 0, WINDOW_HEIGHT / 2 - 20, WINDOW_WIDTH, 'center')
    love.graphics.printf("Press R to Restart", 0, WINDOW_HEIGHT / 2 + 20, WINDOW_WIDTH, 'center')
end

return GameWinState
