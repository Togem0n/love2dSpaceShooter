local love = require('love')
local tear = require('tear')

local player = {}

function player:load()
    self.size = 30
    self.view_angle = math.rad(90)
    self.x = love.graphics:getWidth() / 2
    self.y = love.graphics:getHeight() / 2
    self.speed = 300
    self.radius = self.size / 2
    self.angle = self.view_angle
    self.thrusting = false
    self.thrust = {
        x = 0,
        y = 0,
        speed = 0
    }

    self.tears = {}
    self.shootCooldown = 0.1
    self.shootTimer = 0
    self.canShoot = true
end

function player:draw()
    if ShowDebugging then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.rectangle("fill", self.x - 2, self.y - 2, 4, 4)
        love.graphics.circle("line", self.x, self.y, self.radius)
    end
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.polygon(
        "line",
        self.x + ((4 / 3) * self.radius) * math.cos(self.angle),
        self.y - ((4 / 3) * self.radius) * math.sin(self.angle),
        self.x - self.radius * (2 / 3 * math.cos(self.angle) + math.sin(self.angle)),
        self.y + self.radius * (2 / 3 * math.sin(self.angle) - math.cos(self.angle)),
        self.x - self.radius * (2 / 3 * math.cos(self.angle) - math.sin(self.angle)),
        self.y + self.radius * (2 / 3 * math.sin(self.angle) + math.cos(self.angle))
    )

    for _, tear in pairs(self.tears) do
        tear:draw()
    end
    -- print(#self.tears)
end

function player:update(dt)
    self:move(dt)
    self:shootInpt()
    self:checkShootCooldown(dt)
    self:updateTears(dt)
end

function player:move(dt)
    if love.keyboard.isDown('d') or love.keyboard.isDown('right') then
        self.x = self.x + self.speed * dt
    elseif love.keyboard.isDown('a') or love.keyboard.isDown('left') then
        self.x = self.x - self.speed * dt
    end
    if love.keyboard.isDown('w') or love.keyboard.isDown('up') then
        self.y = self.y - self.speed * dt
    elseif love.keyboard.isDown('s')  or love.keyboard.isDown('down')then
        self.y = self.y + self.speed * dt
    end
end

function player:shootInpt()
    if love.keyboard.isDown("space") and self.canShoot then
        self:shoot()
        self.canShoot = false
    end
end

function player:checkShootCooldown(dt)
    if not self.canShoot then
        self.shootTimer = self.shootTimer + dt
        if self.shootTimer > self.shootCooldown then
            self.shootTimer = 0
            self.canShoot = true
        end
    end
end

function player:updateTears(dt)
    for index, tear in pairs(self.tears) do
        tear:update(dt)

        if tear:isOutOfScreen() or tear.exploding == tear.exploadingEnum.doneExploding then
            self:removeTear(index)
        end
    end
end

function player:shoot()
    table.insert(self.tears, tear:load(self.x, self.y))
end

function player:removeTear(index)
    table.remove(self.tears, index)
end

return player