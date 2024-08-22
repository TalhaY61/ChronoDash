ObstaclesManager = Class{}

function ObstaclesManager:init()
    self.obstacles = {} -- Table to store all obstacles
    self.spawnTimer = 0
    self.spawnInterval = 5 -- Time in seconds between spawning obstacles
end

function ObstaclesManager:spawnObstacle()
    local obstacleType = math.random(1, 2) -- Randomly choose between 1 and 2
    local newObstacle

    if obstacleType == 1 then
        newObstacle = Scorpion() -- Create a new Scorpion
    else
        newObstacle = Cactus() -- Create a new Cactus
    end

    table.insert(self.obstacles, newObstacle)
end

function ObstaclesManager:update(dt)
    self.spawnTimer = self.spawnTimer - dt

    -- Spawn a new obstacle if the timer has elapsed
    if self.spawnTimer <= 0 then
        self:spawnObstacle()
        self.spawnTimer = self.spawnInterval
    end

    --[[Update all obstacles. Loop backwards to remove obstacles that have gone off screen,
    it start by i = #self.obstacles, which is the last element in the table and goes down to 1. --]] 
    for i = #self.obstacles, 1, -1 do
        local obstacle = self.obstacles[i]
        obstacle:update(dt)

        -- Remove obstacle if it goes off screen
        if obstacle.x + obstacle.width < 0 then
            table.remove(self.obstacles, i)
        end
    end
end

function ObstaclesManager:render()
    -- Index not needed, so use _ as a placeholder
    -- Loop through all obstacles and render each one
    for _, obstacle in ipairs(self.obstacles) do
        obstacle:render()
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
