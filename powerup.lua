local love = require('love')

local powerup = {}

function powerup:create(x, y, radius, velx, vely)
    local obj = {
        x = x,
        y = y,
        velx = velx,
        vely = vely,
        radius = 20
    }
    setmetatable(obj, { __index = powerup })
    return obj
end

function powerup:draw()
    love.graphics.setColor(0, 1, 1)
    love.graphics.rectangle("fill", self.x - 2, self.y - 2, 4, 4)
    love.graphics.polygon('line', self.x - self.radius, self.y, self.x, self.y - self.radius, self.x + self.radius, self.y, self.x, self.y + self.radius)
end

function powerup:update(dt)
    local dx = self.velx * dt
    local dy = self.vely * dt
    if self.x + self.radius + dx > love.graphics:getWidth() or self.x - self.radius + dx < 0 then
        self.velx = -self.velx
    end

    if self.y + self.radius + dy > love.graphics:getHeight() or self.y - self.radius + dy < 0 then
        self.vely = -self.vely
    end

    self.x = self.x + dx
    self.y = self.y + dy

end
return powerup