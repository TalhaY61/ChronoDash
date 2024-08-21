Mage = Class{}

function Mage:init()
    self.image = love.graphics.newImage('mage.png')
    -- Spieler auf die Plattform setzen
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- Setze den Spieler auf die Plattform
    self.x = 100 
    self.y = 660 - self.height

end


function Mage:render() 
    love.graphics.draw(self.image, self.x, self.y)
end