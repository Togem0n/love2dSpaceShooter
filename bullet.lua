local love = require('love')

local bullet = {}

function bullet:create(x, y, radius, angle, speed)
    local obj = {
        x = x,
        y = y,
        radius = radius,
        angle = angle,
        speed = speed,
    }
    setmetatable(obj, { __index = bullet })
    return obj
end

function bullet:draw()
    love.graphics.circle("fill", self.x, self.y, self.radius)
end

function bullet:move(dt)
    local dx = math.cos(self.angle) * self.speed * dt
    local dy = math.sin(self.angle) * self.speed * dt
    self.x = self.x + dx
    self.y = self.y + dy
end

function bullet:circlate(dt, player, distance)
    local dx = self.x - player.x
    local dy = self.y - player.y
    self.angle = math.atan2(dy, dx)

    -- increment angle to make object a rotate around object b
    self.angle = self.angle + 1 * dt

    self.x = player.x + distance * math.cos(self.angle)
    self.y = player.y + distance * math.sin(self.angle)
end

function bullet:isOutOfScreen()
    if self.x < 0 or self.x > love.graphics:getWidth() or self.y < 0 or self.y > love.graphics:getHeight() then
        return true
    else
        return false 
    end
end

return bullet