local MenuState = {}

local highlighted = 1

function MenuState:enter()
    -- Reset the highlighted option when entering the menu state
    highlighted = 1
end

function MenuState:update()
    if love.keyboard.wasPressed('up') then
        love.audio.play(selectSound)
        highlighted = highlighted - 1
        if highlighted < 1 then
            highlighted = 3  -- Wrap around to the last option
        end
    elseif love.keyboard.wasPressed('down') then
        love.audio.play(selectSound)
        highlighted = highlighted + 1
        if highlighted > 3 then
            highlighted = 1  -- Wrap around to the first option
        end
    end    

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        if highlighted == 1 then
            love.audio.play(selectSound)
            gameStateManager:change('play')
        elseif highlighted == 2 then
            love.audio.play(selectSound)
            gameStateManager:change('howtoplay')
        elseif highlighted == 3 then
            love.audio.play(selectSound)
            love.event.quit()
        end
    end

end

function MenuState:draw()
    love.graphics.draw(BACKGROUND, 0, 0)

    love.graphics.setFont(gFonts['extrabold'])
    love.graphics.printf("CHRONO DASH", 0, WINDOW_HEIGHT / 2 - 70, WINDOW_WIDTH, 'center')
    
    love.graphics.setFont(gFonts['bold'])
    if highlighted == 1 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf("START", 0, WINDOW_HEIGHT / 2 + 70, WINDOW_WIDTH, 'center')

    love.graphics.setColor(1, 1, 1, 1)

    if highlighted == 2 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf("HOW TO PLAY", 0, WINDOW_HEIGHT / 2 + 140, WINDOW_WIDTH, 'center')
    
    love.graphics.setColor(1, 1, 1, 1)

    if highlighted == 3 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf("QUIT", 0, WINDOW_HEIGHT / 2 + 210, WINDOW_WIDTH, 'center')

    love.graphics.setColor(1, 1, 1, 1)
end

return MenuState
