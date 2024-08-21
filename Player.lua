Player = Class{}

function Player:init()
    -- Spieler auf die Plattform setzen
    self.width = 64
    self.height = 64

    -- Setze den Spieler auf die Plattform
    self.x = 100 
    self.y = 660 - self.height

    self.color = {1, 1, 1}
end


function Player:render() 
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end