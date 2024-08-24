ObstaclesManager = Class{}

function ObstaclesManager:init()
    self.obstacles = {} -- Table to store all obstacles
    self.spawnTimer = 0
end

function ObstaclesManager:spawnObstacle()
    -- Randomly spawn a cactus or a scorpion
    local obstacleType = math.random(1, 2)
    if obstacleType == 1 then
        table.insert(self.obstacles, Cactus())
    else
        table.insert(self.obstacles, Scorpion())
    end
end


function ObstaclesManager:update(dt)
    
end


function ObstaclesManager:render()
    -- Loop through all obstacles and render each one
    for _, obstacle in ipairs(self.obstacles) do
        obstacle:render() -- Call the render function for each obstacle, e.g. cactus:render()
    end
end

function ObstaclesManager:checkCollisions(mage)
    -- Loop through all obstacles and check for collisions with the mage
    for _, obstacle in ipairs(self.obstacles) do
        if mage:collides(obstacle) then
            return true
        end
    end
    return false
end
