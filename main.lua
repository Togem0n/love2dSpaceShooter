require('globals')
local love = require('love')
local player = require('player')
local boss = require('boss')
local game = require('states/game')

function love.load()
    player:load()
    boss:load()
    game:load()
end

function love.keypressed(key)
    if game.state.running then
        if key == "escape" then
            game:changeState("paused")
        end 
    elseif game.state.paused then
        if key == "escape" then
            game:changeState("running")
        end 
    end

    if key == "t" then
        local angle = math.atan2(player.y - boss.y, player.x - boss.x)
        boss:shootLinearPattern(4, boss.x, boss.y + boss.radius, 10, math.rad(boss.testAngle), 50)
    end

    if key == "y" then
        boss:shootCirclePattern(5, love.graphics:getWidth()/2, love.graphics:getHeight()/2, 2, 50)
    end

    if key == "u" then
        boss:shootRandomScatterPattern(10, love.graphics:getWidth()/2, love.graphics:getHeight()/2, 5, 50, math.rad(90))
    end

    if key == "p" then
        for k, v in pairs(boss.bullets) do
            boss.bullets[k] = nil
        end
    end
    
end

function love.update(dt)
    if game.state.running then
        player:update(dt)
        boss:update(dt)

        for index, tear in pairs(player.tears) do
            if CalculateDistance(tear.x, tear.y, boss.x, boss.y) < boss.radius + tear.radius then
                if tear.exploading == tear.exploadingEnum.notExploading then
                    boss:decreaseHealth()
                end
                print(tear.exploding)
                tear:expload(dt)
            end
        end
    end
end

function love.draw()
    -- only do the below if it's paused or running state
    if game.state.running or game.state.paused then
        player:draw()
        boss:draw()
        game:draw(game.state.paused) -- we can now draw the paused screen

        if ShowDebugging then
            love.graphics.setColor(0, 1, 1)
            love.graphics.print("health:"..boss.health, 0, 0, 0)
            love.graphics.print("bullets:"..#boss.bullets, 0, 20, 0)
            love.graphics.print("tears:"..#player.tears, 0, 40, 0)
        end
    else
        print('nmsysl')
    end

end