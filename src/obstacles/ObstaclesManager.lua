local ObstaclesManager = {}
ObstaclesManager.__index = ObstaclesManager

local Scorpion = require 'src/obstacles/Scorpion'
local Cactus = require 'src/obstacles/Cactus'
local Vulture = require 'src/obstacles/Vulture'


function ObstaclesManager:new()
    local instance = setmetatable({}, ObstaclesManager)
    instance:init()
    return instance
end

function ObstaclesManager:init()
    self.obstacles = {}
    self.obstacleSpeed = 400
    self.obstacleGap = 900
end

function ObstaclesManager:setObstacleValues(level)
    if level == 1 then 
        self.obstacleSpeed = 400
        self.obstacleGap = 400
    elseif level == 2 then
        self.obstacleSpeed = 450
        self.obstacleGap = 500
    elseif level == 3 then
        self.obstacleSpeed = 500
        self.obstacleGap = 500
    elseif level == 4 then
        self.obstacleSpeed = 550
        self.obstacleGap = 550
    elseif level == 5 then
        self.obstacleSpeed = 600
        self.obstacleGap = 550
    elseif level == 6 then
        self.obstacleSpeed = 650
        self.obstacleGap = 550
    elseif level == 7 then
        self.obstacleSpeed = 650
        self.obstacleGap = 650
    end 
end

function ObstaclesManager:getObstacleValues()
    return self.obstacleSpeed, self.obstacleGap
end

function ObstaclesManager:spawnObstacle(obstacleSpeed, level)
    local obstacleType = math.random(1, 3)
    local obstacle

    if obstacleType == 1 then
        obstacle = Cactus:new(obstacleSpeed)
    elseif obstacleType == 2 then
        obstacle = Scorpion:new(obstacleSpeed)
    elseif obstacleType == 3 and level >= 3 then
        obstacle = Vulture:new(obstacleSpeed)
    else
        -- If the level is not high enough, we only spawn cacti
        obstacle = Cactus:new(obstacleSpeed) 
    end

    table.insert(self.obstacles, obstacle)
end


function ObstaclesManager:removeObstacles()
    for i = #self.obstacles, 1, -1 do
        if self.obstacles[i].x < -self.obstacles[i].width then
            table.remove(self.obstacles, i)
            return true
        end
    end
    return false
end

function ObstaclesManager:update(dt, isTimeControlActive, level)
    self:removeObstacles()
    self:setObstacleValues(level)

    local lastObstacle = self.obstacles[#self.obstacles]

    if #self.obstacles == 0 or WINDOW_WIDTH - lastObstacle.x > self.obstacleGap then
        self:spawnObstacle(self.obstacleSpeed, level)
    end

    for _, obstacle in ipairs(self.obstacles) do
        local adjustedDt = dt
        if isTimeControlActive then
            adjustedDt = dt * 0.5 -- Slow down obstacles
        end
        obstacle:update(adjustedDt)
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

function ObstaclesManager:getObstacles()
    return self.obstacles
end

return ObstaclesManager
