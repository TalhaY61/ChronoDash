local StateManager = {}

function StateManager:new()
    local instance = {
        states = {},
        current = nil
    }
    setmetatable(instance, { __index = StateManager })
    return instance
end

function StateManager:add(name, state)
    self.states[name] = state
end

-- Change to a different state
-- (...) is a vararg, which is a way to pass a variable number of arguments to a function
function StateManager:change(name, ...)
    self.current = self.states[name]
    if self.current and self.current.enter then
        self.current:enter(...)
    end
end

-- Update the current state
function StateManager:update(dt)
    if self.current and self.current.update then
        self.current:update(dt)
    end
end

-- Draw the current state
function StateManager:draw()
    if self.current and self.current.draw then
        self.current:draw()
    end
end

return StateManager
