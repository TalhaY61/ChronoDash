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
        self.obstacleGap = 600
    elseif level == 2 then
        self.obstacleSpeed = 450
        self.obstacleGap = 550
    elseif level == 3 then
        self.obstacleSpeed = 475
        self.obstacleGap = 525
    elseif level == 4 then
        self.obstacleSpeed = 550
        self.obstacleGap = 525
    elseif level == 5 then
        self.obstacleSpeed = 550
        self.obstacleGap = 500
    elseif level == 6 then
        self.obstacleSpeed = 575
        self.obstacleGap = 500
    elseif level == 7 then
        self.obstacleSpeed = 600
        self.obstacleGap = 450
    else 
        self.obstacleSpeed = 600
        self.obstacleGap = 450
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
    elseif obstacleType == 3 and level >= 2 then
        obstacle = Vulture:new(obstacleSpeed)
    else
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

function ObstaclesManager:update(dt, isTimeControlAbilityActive, level)
    self:removeObstacles()
    self:setObstacleValues(level)

    local lastObstacle = self.obstacles[#self.obstacles]

    if #self.obstacles == 0 or WINDOW_WIDTH - lastObstacle.x > self.obstacleGap then
        self:spawnObstacle(self.obstacleSpeed, level)
    end

    -- For TimeControlAbility, slow down the obstacles
    for _, obstacle in ipairs(self.obstacles) do
        local adjustedDt = dt
        if isTimeControlAbilityActive then
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
