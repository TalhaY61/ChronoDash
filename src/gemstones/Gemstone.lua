local Gemstone = {}
Gemstone.__index = Gemstone

function Gemstone:new()
    local instance = setmetatable({}, Gemstone)
    instance:init()
    return instance
end

function Gemstone:init()
    self.gemstoneImage = love.graphics.newImage('images/gemstones.png')
    self.gemstoneQuads = {
        ['blue'] = love.graphics.newQuad(0, 0, 34, 42, self.gemstoneImage:getDimensions()),
        ['red'] = love.graphics.newQuad(34, 0, 34, 42, self.gemstoneImage:getDimensions()),
        ['green'] = love.graphics.newQuad(0, 42, 34, 42, self.gemstoneImage:getDimensions()),
    }
    self.width = self.gemstoneImage:getWidth()
    self.height = self.gemstoneImage:getHeight()

    self.gemstones = {}
    self.spawnTimer = 0
    self.spawnInterval = 10 -- seconds
end

function Gemstone:update(dt, level)
    self.spawnTimer = self.spawnTimer + dt
    
    if self.spawnTimer >= self.spawnInterval then
        self.spawnTimer = 0
        
        if level > 2 then
            local color = self:selectColor(level)
            if color then
                self:spawnGemstone(color)
            end
        end
    end

    for i = #self.gemstones, 1, -1 do
        local gemstone = self.gemstones[i]
        gemstone.x = gemstone.x - gemstone.speed * dt
        
        if gemstone.x + gemstone.width < 0 then
            table.remove(self.gemstones, i)
        end
    end
end

function Gemstone:spawnGemstone(color)
    local gemstone = {
        width = self.width,
        height = self.height,
        x = WINDOW_WIDTH + self.width,
        y = PLATFORM_HEIGHT - math.random(self.height, 100),
        speed = 400,
        quad = self.gemstoneQuads[color],
        color = color
    }

    table.insert(self.gemstones, gemstone)
end

function Gemstone:selectColor(level)
    if level > 6 then
        return 'green'
    elseif level > 4 then
        return 'red'
    elseif level > 2 then
        return 'blue'
    end
end

function Gemstone:checkGemstone(mage)
    for i = #self.gemstones, 1, -1 do
        local gemstone = self.gemstones[i]
        
        if self:collides(gemstone, mage) then
            -- Rückgabewert des gesammelten Edelsteins
            local collectedGemstone = gemstone.color
            table.remove(self.gemstones, i)
            return collectedGemstone
        end
    end
end


function Gemstone:collides(gemstone, mage)
    return not (gemstone.x + gemstone.width < mage.x or
                gemstone.x > mage.x + mage.width or
                gemstone.y + gemstone.height < mage.y or
                gemstone.y > mage.y + mage.height)
end

function Gemstone:render()
    for _, gemstone in ipairs(self.gemstones) do
        if gemstone.quad and self.gemstoneImage then
            love.graphics.draw(self.gemstoneImage, gemstone.quad, gemstone.x, gemstone.y)
        else
            -- Füge eine Fehlermeldung hinzu, um herauszufinden, welches Element nil ist
            print("Fehler: quad oder gemstoneImage ist nil")
        end
    end
end


return Gemstone
