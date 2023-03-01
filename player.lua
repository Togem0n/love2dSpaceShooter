local love = require('love')
local tear = require('tear')

local player = {}

function player:load()
    self.size = 20
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
    self.health = 5
    self.inviDuration = 3
    self.inviTimer = 0
    self.invi = false
    self.getDmg = false

    self.powerLev = 1
end

function player:draw()
    -- draw collision collider
    if ShowDebugging then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.rectangle("fill", self.x - 2, self.y - 2, 4, 4)
        love.graphics.circle("line", self.x, self.y, self.radius)
    end

    -- draw invincible effect
    if self.invi then
        love.graphics.setColor(0, 1, 1)
        love.graphics.circle("line", self.x, self.y, 15)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end

    -- draw player
    love.graphics.print(self.health..'', self.x - 5, self.y - 10, 0)
    love.graphics.polygon(
        "line",
        self.x + ((4 / 3) * self.radius) * math.cos(self.angle),
        self.y - ((4 / 3) * self.radius) * math.sin(self.angle),
        self.x - self.radius * (2 / 3 * math.cos(self.angle) + math.sin(self.angle)),
        self.y + self.radius * (2 / 3 * math.sin(self.angle) - math.cos(self.angle)),
        self.x - self.radius * (2 / 3 * math.cos(self.angle) - math.sin(self.angle)),
        self.y + self.radius * (2 / 3 * math.sin(self.angle) + math.cos(self.angle))
    )

    -- draw tears
    for _, tear in pairs(self.tears) do
        tear:draw()
    end
end

function player:update(dt)
    self:move(dt)
    self:shootInpt()
    self:checkShootCooldown(dt)
    self:updateTears(dt)
    self:setInvi(dt)
end

function player:move(dt)
    if (love.keyboard.isDown('d') or love.keyboard.isDown('right')) and self.x + self.radius + self.speed * dt < love.graphics:getWidth() then
        self.x = self.x + self.speed * dt
    elseif (love.keyboard.isDown('a') or love.keyboard.isDown('left')) and self.x - self.radius - self.speed * dt > 0 then
        self.x = self.x - self.speed * dt
    end
    if (love.keyboard.isDown('w') or love.keyboard.isDown('up')) and self.y - self.radius - self.speed * dt > 0 then
        self.y = self.y - self.speed * dt
    elseif (love.keyboard.isDown('s')  or love.keyboard.isDown('down')) and self.y + self.radius + self.speed * dt < love.graphics:getHeight() then
        self.y = self.y + self.speed * dt
    end
end

function player:shootInpt()
    if love.keyboard.isDown("space") and self.canShoot then
        if self.powerLev == 1 then
            self:shoot()
        elseif self.powerLev == 2 then
            self:doubleShoot()
        else
            self:tripleShoot()
        end
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
            table.remove(self.tears, index)
        end
    end
end

function player:shoot()
    table.insert(self.tears, tear:load(self.x, self.y, -math.pi / 2))
end

function player:doubleShoot()
    table.insert(self.tears, tear:load(self.x - 5, self.y, -math.pi / 2))
    table.insert(self.tears, tear:load(self.x + 5, self.y, -math.pi / 2))
end

function player:tripleShoot()
    table.insert(self.tears, tear:load(self.x, self.y, -math.pi / 2))
    table.insert(self.tears, tear:load(self.x - 5, self.y, -4*math.pi / 10))
    table.insert(self.tears, tear:load(self.x + 5, self.y, -6*math.pi / 10))
end

function player:removeTears()
    for k, tear in pairs(self.tears) do
        self.tears[k] = nil
    end
end

function player:healthDown()
    if not self.invi then
        player.health = player.health - 1
        player.invi = true
        player.getDmg = true
    end
end

function player:setInvi(dt)
    if self.invi == true then
        if self.inviTimer < self.inviDuration then
            self.inviTimer = self.inviTimer + dt
        else
            self.inviTimer = 0
            self.invi = false
        end
    end
end

function player:reset()
    player.health = 5
    player.x = love.graphics.getWidth() / 2
    player.y = love.graphics.getHeight() / 2
    player.powerLev = 1
    self:removeTears()
end

return player