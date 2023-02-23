local love = require('love')

local boss = {}

function boss:load()
    self.x = love.graphics:getWidth()/2
    self.y = 0
    self.velX = 0
    self.velY = 0
    self.size = 1
    self.radius = 200

    self.minCooldown = 1
    self.maxCooldown = 3
    self.cooldownTimer = 0
end

function boss:draw()
    if ShowDebugging then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.rectangle("fill", self.x-5, self.y-5, 10, 10)
    end
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.circle("line", love.graphics:getWidth()/2, 0, self.radius)
end

function boss:update(dt)
    
end

return boss