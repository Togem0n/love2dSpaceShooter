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

    -- if key == "space" then
    --     print("press space")
    --     player:shoot()
    -- end
    
end

function love.update(dt)
    if game.state.running then
        player:update(dt)
        boss:update(dt)

        for index, tear in pairs(player.tears) do
            if CalculateDistance(tear.x, tear.y, boss.x, boss.y)  < boss.radius + tear.radius then
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
    else
        print('nmsysl')
    end

end