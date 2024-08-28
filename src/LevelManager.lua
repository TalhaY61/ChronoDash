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
    self.requiredScore = 100
    obstacleManager:setObstacleValues(self.currentLevel)
end

function LevelManager:update(dt)
    -- Check if the player has reached the required score for the next level
    if self.score >= self.requiredScore then
        obstacleManager:removeObstacles()
        self:advanceToNextLevel()
        obstacleManager:setObstacleValues(self.currentLevel)
    end
end

function LevelManager:advanceToNextLevel()
    self.currentLevel = self.currentLevel + 1
    self.score = 0 -- Reset score for the new level

    -- Optionally increase the required score for the next level
    self.requiredScore = self.requiredScore + 50

    -- If the level is not defined, the game can end or loop back
    if self.currentLevel > 3 then
        self.currentLevel = 1
    end
end

function LevelManager:reset()
    self.currentLevel = 1
    self.score = 0
    self.requiredScore = 100
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
