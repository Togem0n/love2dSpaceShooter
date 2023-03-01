-- game state logic, setting game state like menu state, running and pause state

local game = {}
local boss = require "boss"
local player = require "player"
local Text = require "components.text"

function game:load()
    self.state = {
        menu = true,
        paused = false,
        running = false,
        ended = false
    }
end

function game:drawPause(paused)
    if paused then
        Text(
            "PAUSED",
            0,
            love.graphics.getHeight() * 0.4,
            "h1",
            false,
            false,
            love.graphics.getWidth(),
            "center",
            1
        ):draw()
    end
end

function game:drawEnd(paused)
    if paused then
        Text(
            "PAUSED",
            0,
            love.graphics.getHeight() * 0.4,
            "h1",
            false,
            false,
            love.graphics.getWidth(),
            "center",
            1
        ):draw()
    end
end

function game:changeState(state)
    self.state.menu = state == "menu"
    self.state.paused = state == "paused"
    self.state.running = state == "running"
    self.state.ended = state == "ended"
end

function game:startNewGame()
    self:changeState("running")
end

function game:resetPlayerAndBoss()
    player:reset()
    boss:reset()
end

return game