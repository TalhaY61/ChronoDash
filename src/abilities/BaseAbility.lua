local BaseAbility = {}
BaseAbility.__index = BaseAbility

function BaseAbility:new()
    local instance = setmetatable({}, BaseAbility)
    return instance
end

function BaseAbility:activate() end

return BaseAbility
