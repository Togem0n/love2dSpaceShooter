local love = require('love')
local bullet = require('bullet')
local player = require('player')

local boss = {}

function boss:load()
    self.x = love.graphics:getWidth()/2
    self.y = 0
    self.velX = 0
    self.velY = 0
    self.size = 1
    self.health = 1500
    self.radius = self.health / 5

    self.minCooldown = 1
    self.maxCooldown = 3
    self.cooldownTimer = 0
    self.ability = 0
    self.abilityDuration = 10
    self.abilityTimer = 0
    self.abilityAngle = 0
    self.stepTimer = 0
    self.stepDuration = 0.3
    self.inAbility = false
    self.abilityType = 0
    self.abilityTypeEnum = {
        linear = 1,
        circle = 2,
        random = 3
    }

    self.bullets = {}
    self.testAngle = 0
    self.testAngleStep = 3

    self.shouldSwitchAngle = false
    self.switchAngleDir = false
    self.switchAngleTimer = 0
    self.switchAngleCooldown = 5
end

function boss:draw()
    if ShowDebugging then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.rectangle("fill", self.x-5, self.y-5, 10, 10)
    end
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.circle("line", love.graphics:getWidth()/2, 0, self.radius)

    love.graphics.print(self.health..'', self.x -50, self.y + self.radius / 2 - 15, 0 , 3, 3)

    for index, bullet in pairs(self.bullets) do
        bullet:draw()
    end
end

function boss:update(dt)
    self:updateAngle(dt)
    self:updateAbility(dt)
    self:updateBullets(dt)
    self:updateRadius()
    self:updateDmgPlayer()
end

function boss:shootAccordingToHealth()
    if self.health > 1300 then
        self:shootRandomScatterPattern(10, boss.x, boss.y + boss.radius, 10, 100, 90)
    elseif self.health > 1000 then
        self:shootLinearPattern(10, boss.x, boss.y + boss.radius, 10, math.rad(boss.testAngle), 100)
    elseif self.health > 700 then
        self:shootCirclePattern(10, boss.x, boss.y + boss.radius, 10, math.rad(boss.testAngle), 100)
    elseif self.health > 300 then
        self:shootRingPattern(1, boss.x, boss.y + boss.radius, 10, math.rad(boss.testAngle), 100)
    elseif self.health > 0 then
        self:shootSprialPattern(15, boss.x, boss.y + boss.radius, 10, 100)
    end
end

function boss:shootLinearPattern(count, x, y, radius, angle, speed)
    local spacing = 2 * math.pi / (count - 1)
    for i = 1, count do
        local bulletAngle = angle + (i - 1) * spacing
        table.insert(self.bullets, bullet:create(x, y, radius, bulletAngle, speed))
    end
end

function boss:shootHomingPattern(count, x, y, radius, angle, speed)
    local angleRad = math.atan2(player.y - self.y, player.x - self.x)
    for i = 1, count do
        table.insert(self.bullets, bullet:create(x, y, radius, angleRad, speed))
    end
end

function boss:shootCirclePattern(count, x, y, radius, angle, speed)
    local angleSpacing = 2 * math.pi / count
    for i = 1, count do
        local bulletAngle = angle + (i - 1) * angleSpacing
        local bx = x + radius * math.cos(angle)
        local by = y + radius * math.sin(angle)
        table.insert(self.bullets, bullet:create(bx, by, radius, bulletAngle, speed))
    end
end

function boss:shootRingPattern(count, x, y, radius, angle, speed)
    local bulletsPerRing = 12
    local angleBetweenBullets = 2 * math.pi / bulletsPerRing

    for i = 1, count do
        for j = 1, bulletsPerRing do
            local bulletAngle = angle + (j - 1) * angleBetweenBullets
            local distance = i * 25
            local bx = x + distance * math.cos(bulletAngle)
            local by = y + distance * math.sin(bulletAngle)
            table.insert(self.bullets, bullet:create(bx, by, radius, bulletAngle, speed))
        end
    end
end

function boss:shootRandomScatterPattern(count, x, y, radius, speed, scatterAngle)
    for i = 1, count do
        local angle = math.random() * 2 * math.pi
        local distance = math.random() * radius
        local bx = x + distance * math.cos(angle)
        local by = y + distance * math.sin(angle)
        local bulletAngle = angle + (math.random() - 0.5) * scatterAngle
        table.insert(self.bullets, bullet:create(bx, by, radius, bulletAngle, speed))
    end
end

function boss:shootRotateAroundPlayerPattern(count, radius, speed)
    local angleStep = 2 * math.pi / count
    for i = 1, count do
        local angle = i * angleStep
        local x = player.x + radius * math.cos(angle)
        local y = player.y + radius * math.sin(angle)
        table.insert(self.bullets, bullet:create(x, y, 10, angle, speed))
    end
end

function boss:shootSprialPattern(count, x, y, radius, speed)
    local startAngle = math.random() * math.pi/2
    local startDistance = math.random() * 50 + radius
    local angle = startAngle
    local distance = startDistance

    for i = 1, count do
        local bx = x + distance * math.cos(angle)
        local by = x + distance * math.sin(angle)
        table.insert(self.bullets, bullet:create(x, y, 10, angle, speed))
        angle = angle + math.random() * 0.2 + 0.1
        distance = distance - math.random() * 2 - 1
    end 
end

-- updating shooting angle according to game time
function boss:updateAngle(dt)
    if self.testAngle < 180 and self.shouldSwitchAngle then
        if self.switchAngleTimer < self.switchAngleCooldown / 2 then
            self.testAngle = self.testAngle + self.testAngleStep
        elseif self.switchAngleTimer < self.switchAngleCooldown then
            self.testAngle = self.testAngle - self.testAngleStep
        else
            self.switchAngleTimer = 0
        end
        self.switchAngleTimer = self.switchAngleTimer + dt
    elseif self.testAngle < 180 and not self.shouldSwitchAngle then
        self.testAngle = self.testAngle + self.testAngleStep
    end

    if self.testAngle >= 180 then
        self.testAngle = 0
    end
end

-- updating shooting duration and cooldown
function boss:updateAbility(dt)
    if self.cooldownTimer < self.minCooldown and self.inAbility == false then
        self.cooldownTimer = self.cooldownTimer + dt
    else
        self.inAbility = true
        self.cooldownTimer = 0
    end

    if self.inAbility then
        self.abilityTimer = self.abilityTimer + dt
        if self.stepTimer < self.stepDuration then
            self.stepTimer = self.stepTimer + dt
            if self.stepTimer > self.stepDuration then
                self:shootAccordingToHealth()
                self.stepTimer = 0
            end
        end
        if self.abilityTimer > self.abilityDuration then
            self.inAbility = false
            self.abilityTimer = 0
        end
    end
end

function boss:updateBullets(dt)
    for index, bullet in pairs(self.bullets) do
        local distance = CalculateDistance(bullet.x, bullet.y, player.x, player.y)
        bullet:move(dt)

        if bullet:isOutOfScreen() then
            table.remove(self.bullets, index)
        end

        if CalculateDistance(bullet.x, bullet.y, player.x, player.y) < player.radius + bullet.radius and not player.invi then
            player:healthDown()
            table.remove(self.bullets, index)
        end

        if CalculateDistance(bullet.x, bullet.y, self.x, self.y) < boss.radius - bullet.radius then
            table.remove(self.bullets, index)
        end
    end
end

-- updating radius according to boss's health
-- radius range [300, 150] mapping boss's health [1500, 700] 
function boss:updateRadius()
    if self.health > 900 then
        self.radius = (self.health + 100) * 150 / 800
    end
end

function boss:updateDmgPlayer()
    if CalculateDistance(player.x, player.y, self.x, self.y) < player.radius + boss.radius and not player.invi then
        player:healthDown()
    end    
end

function boss:decreaseHealth()
    if self.health > 0  then
        self.health = self.health - 1
    end
end

function boss:reset()
    self:removeAllBullets()
    self:resetHealth()
end

function boss:removeAllBullets()
    for k, v in pairs(boss.bullets) do
        boss.bullets[k] = nil
    end
end

function boss:resetHealth()
    boss.health = 1500
end

return boss