local GameOverState = {}

function GameOverState:enter()
    
end

function GameOverState:update()
    if love.keyboard.wasPressed('r') then
        gameStateManager:change('play')
    end
end

function GameOverState:draw()
    love.graphics.setFont(gFonts['bold'])
    love.graphics.draw(BACKGROUND, 0, 0)
    love.graphics.printf("GAME OVER", 0, WINDOW_HEIGHT / 2 - 20, WINDOW_WIDTH, 'center')
    love.graphics.printf("Press R to Restart", 0, WINDOW_HEIGHT / 2 + 20, WINDOW_WIDTH, 'center')
end

return GameOverState
