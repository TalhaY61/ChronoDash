local BaseAbility = {}
BaseAbility.__index = BaseAbility

function BaseAbility:new()
    local instance = setmetatable({}, BaseAbility)
    return instance
end

function BaseAbility:init() end
function BaseAbility:enter() end
function BaseAbility:exit() end
function BaseAbility:update(dt) end
function BaseAbility:render() end

return BaseAbility
