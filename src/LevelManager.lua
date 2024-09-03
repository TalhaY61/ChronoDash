local LevelManager = {}
LevelManager.__index = LevelManager

local ObstaclesManager = require 'src/obstacles/ObstaclesManager'

local obstacleManager = ObstaclesManager:new()

function LevelManager:new()
    local instance = setmetatable({}, LevelManager)
    instance:init()

    return instance
end

function LevelManager:init()
    self.currentLevel = 1
    self.score = 0
    self.requiredScore = 20
    obstacleManager:setObstacleValues(self.currentLevel)
end

function LevelManager:update()
    -- Check if the player has reached the required score for the next level
    if self.score >= self.requiredScore then
        obstacleManager:removeObstacles()
        self:advanceToNextLevel()
        obstacleManager:setObstacleValues(self.currentLevel)
    end
end

function LevelManager:advanceToNextLevel()
    self.currentLevel = self.currentLevel + 1
    self.score = 0

    if self.currentLevel == 2 then
        self.requiredScore = self.score + 30
    elseif self.currentLevel == 3 then
        self.requiredScore = self.score + 40
    elseif self.currentLevel == 4 then
        self.requiredScore = self.score + 50
    else 
        self.requiredScore = self.score + 60
    end
end


function LevelManager:reset()
    self.currentLevel = 1
    self.score = 0
    self.requiredScore = 10
end

function LevelManager:addScore(points)
    self.score = self.score + points
end

function LevelManager:loseScore(points)
    if self.score - points < 0 then
        self.score = 0
        return
    end
    self.score = self.score - points
end

function LevelManager:getCurrentLevel()
    return self.currentLevel
end

function LevelManager:getScore()
    return self.score
end

function LevelManager:getRequiredScore()
    return self.requiredScore
end

return LevelManager
