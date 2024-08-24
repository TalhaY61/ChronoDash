
local ObstaclesManager = {}
ObstaclesManager.__index = ObstaclesManager


local Scorpion = require 'Scorpion'
local Cactus = require 'Cactus'

function ObstaclesManager:new()
    local instance = setmetatable({}, ObstaclesManager)
    instance:init()
    return instance
end

function ObstaclesManager:init()
    self.obstacles = {}
    self.spawnTimer = 0
end

function ObstaclesManager:spawnObstacle()
    local obstacleType = math.random(1, 2)
    local obstacle

    if obstacleType == 1 then
        obstacle = Cactus:new()
    else
        obstacle = Scorpion:new()
    end

    table.insert(self.obstacles, obstacle)
end

function ObstaclesManager:removeObstacles()
    for i = #self.obstacles, 1, -1 do
        if self.obstacles[i].x < -self.obstacles[i].width then
            table.remove(self.obstacles, i)
        end
    end
end

function ObstaclesManager:update(dt)
    self:removeObstacles()

    if #self.obstacles == 0 then
        self:spawnObstacle()
    end

    for _, obstacle in ipairs(self.obstacles) do
        obstacle:update(dt)
    end
end

function ObstaclesManager:render()
    for _, obstacle in ipairs(self.obstacles) do
        obstacle:render()
    end
end

function ObstaclesManager:checkCollisions(mage)
    for _, obstacle in ipairs(self.obstacles) do
        if mage:collides(obstacle) then
            return true
        end
    end
    return false
end

return ObstaclesManager
