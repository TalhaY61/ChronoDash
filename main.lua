

-- classic OOP class library
Class = require 'class'

-- bird class we've written
require 'Player'

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- Load the background and platform images
local background = love.graphics.newImage('background.png')
local platform = love.graphics.newImage('platform.png')

local platformSpeed = 60
local platformScroll = 0

local player = Player()


function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    -- Fenstergröße einstellen
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    love.window.setTitle('Chrono Dash')
    
end

-- Update-Funktion, um die Spiel-Logik zu aktualisieren
function love.update(dt)
    -- Plattform bewegen
    platformScroll = platformScroll - platformSpeed * dt
    if platformScroll <= -platform:getWidth() then
        platformScroll = 0
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

-- Render-Funktion, um den Spieler anzuzeigen
function love.draw()
    
    love.graphics.draw(background, 0, 0)
    love.graphics.draw(platform, platformScroll, 660)
    love.graphics.draw(platform, platformScroll + platform:getWidth(), 660)

    player:render()

end
