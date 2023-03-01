-- player's bullet ---> tears
local love = require('love')

local tear = {}

function tear:load(x, y, angle)
    local obj = {
        x = x,
        y = y,
        angle = angle,
        speed = 300,
        velX = 0,
        velY = 300,
        radius = 5,
        exploading = 0,
        exploadTimer = 0,
        explodingDur = 0.05,
        exploadingEnum = {
            notExploading = 0,
            inExploading = 1,
            doneExploding = 2
        },
    } 
    setmetatable(obj, { __index = tear })
    return obj 
end

function tear:draw()
    if self.exploading == self.exploadingEnum.notExploading then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setPointSize(self.radius)
        love.graphics.points(self.x, self.y)
    elseif self.exploading == self.exploadingEnum.inExploading then
        love.graphics.setColor(1, 1, 0)
        love.graphics.circle("fill", self.x, self.y, 5)
        love.graphics.setColor(0, 1, 0)
        love.graphics.circle("fill", self.x, self.y, 3)
    end
end

function tear:update(dt)
    self:move(dt)
    if self:isOutOfScreen() then
        self = nil
        collectgarbage()
    end
end

function tear:move(dt)
    local dx = math.cos(self.angle) * self.speed * dt
    local dy = math.sin(self.angle) * self.speed * dt
    self.x = self.x + dx
    self.y = self.y + dy
end

function tear:isOutOfScreen()
    if self.x < 0 or self.x > love.graphics:getWidth() or self.y < 0 or self.y > love.graphics:getHeight() then
        return true
    else
        return false 
    end
end

function tear:expload(dt)
    if self.exploading ~= self.exploadingEnum.doneExploding then
        self.exploading = self.exploadingEnum.inExploading
        self.exploadTimer = self.exploadTimer + dt
        if self.exploadTimer > self.explodingDur then
            self.exploading = self.exploadingEnum.doneExploding
            self.exploadTimer = 0
        end 
    end

end

return tear