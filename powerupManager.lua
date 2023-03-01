local love = require('love')
local player = require('player')
local boss = require('boss')
local powerup = require('powerup')

local powerupManager = {}

function powerupManager:load()
    self.powerups = {}
    self.hasCreatedLv2 = false
    self.hasCreatedLv3 = false
end

function powerupManager:draw()
    for k, powerup in pairs(self.powerups) do
        powerup:draw()
    end
end

function powerupManager:update(dt)

    if boss.health < 1300 and not self.hasCreatedLv2 then
        self.hasCreatedLv2 = true
        self:createPowerup()
    end

    if boss.health < 700 and not self.hasCreatedLv3 then
        self.hasCreatedLv3 = true
        self:createPowerup()
    end

    for index, powerup in pairs(self.powerups) do
        powerup:update(dt)

        if CalculateDistance(powerup.x, powerup.y, player.x, player.y) < player.radius + powerup.radius then
            player.powerLev = player.powerLev + 1
            table.remove(self.powerups, index)
        end
    end
end

function powerupManager:createPowerup()
    local posx = math.random(love.graphics:getWidth())
    local posy = math.random(love.graphics:getHeight() / 3)
    table.insert(self.powerups, powerup:create(posx, posy, 30, 100, 100))
end

function powerupManager:reset()
    self.hasCreatedLv2 = false
    self.hasCreatedLv3 = false 
end

return powerupManager