require('globals')

local love = require('love')
local player = require('player')
local boss = require('boss')
local game = require('states.game')
local menu = require('states.menu')
local pause = require('states.pause')
local powerupManager = require('powerupManager')

function love.load()
    player:load()
    boss:load()
    game:load()
    menu:load()
    pause:load()
    powerupManager:load()
    source = love.audio.newSource("music/BossMain.wav", "stream")
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

    if key == "r" then
        boss:reset()
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        if not game.state.running then
            ClickedMouse = true
        end
    end
end

function love.update(dt)
    if game.state.running then
        -- update game logic
        player:update(dt)
        boss:update(dt)
        powerupManager:update(dt)

        -- collision detection between tears and boss
        for index, tear in pairs(player.tears) do
            if CalculateDistance(tear.x, tear.y, boss.x, boss.y) < boss.radius + tear.radius then
                if tear.exploading == tear.exploadingEnum.notExploading then
                    boss:decreaseHealth()
                end
                tear:expload(dt)
            end
        end

        -- play music
        if not source:isPlaying() then
            love.audio.play(source)
        end

        if player.health == 0 then
            pause.ended = true
            pause.win = false
            game:changeState("paused")
        end

        if boss.health == 0 then
            pause.ended = true
            pause.win = true
            game:changeState("paused")
        end

    elseif game.state.menu then
        menu:run(ClickedMouse)
        ClickedMouse = false
    elseif game.state.paused then
        love.audio.pause()
        pause:run(ClickedMouse)
        ClickedMouse = false
    end
end

function love.draw()
    if game.state.running or game.state.paused then
        -- draw game
        player:draw()
        boss:draw()
        powerupManager:draw()

        -- draw debug infos
        if ShowDebugging then
            love.graphics.setColor(0, 1, 1)
            love.graphics.print("bullets:"..#boss.bullets, 0, 20, 0)
            love.graphics.print("tears:"..#player.tears, 0, 40, 0)
        end

        -- draw pause scene
        if game.state.paused then
            pause:draw()
        end

        -- draw tutorial infos
        love.graphics.setColor(0, 1, 1)
        love.graphics.print("Move: Arrows", 0, 20, 0)
        love.graphics.print("Shoot: Space", 0, 40, 0)
        love.graphics.print("Pause: Esc", 0, 60, 0)
    elseif game.state.menu then
        menu:draw()
    end

end