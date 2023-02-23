local game = {}

local Text = require "../components/text" -- we are adding text

function game:load()
    self.state = {
        menu = false,
        paused = false,
        running = true,
        ended = false
    }
end

function game:draw(faded)
    if faded then
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

return game