-- src/abilities/TimeControl.lua
local BaseAbility = require 'src/abilities/BaseAbility'

local TimeControl = setmetatable({}, {__index = BaseAbility})
TimeControl.__index = TimeControl

function TimeControl:new()
    local instance = BaseAbility:new()
    setmetatable(instance, TimeControl)
    instance.duration = 2      -- Dauer der Zeitverlangsamung in Sekunden
    instance.cooldown = 10      -- Abklingzeit der Fähigkeit in Sekunden
    instance.remainingTime = 0  -- Verbleibende Zeit der Fähigkeit
    instance.isActive = false   -- Status der Fähigkeit
    instance.cooldownTimer = 0  -- Timer für Abklingzeit
    return instance
end

function TimeControl:activate()
    if self.cooldownTimer <= 0 and not self.isActive then
        self.isActive = true
        self.remainingTime = self.duration
        _G.timeScale = 0.5  -- Zeit-Skala auf 0.5 setzen
    end
end

function TimeControl:update(dt)
    if self.isActive then
        self.remainingTime = self.remainingTime - dt
        if self.remainingTime <= 0 then
            self.isActive = false
            _G.timeScale = 1  -- Zeit-Skala zurücksetzen
        end
    end

    if self.cooldownTimer > 0 then
        self.cooldownTimer = self.cooldownTimer - dt
    end
end

return TimeControl
