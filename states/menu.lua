local love = require('love')
local button = require('components.button')
local game = require('states.game')

local menu = {}

function menu:load()
    self.funcs = {
        newGame = function ()
            game:startNewGame()
        end,
        quitGame = function ()
            love.event.quit()
        end
    }

    self.buttons = {
        Button(self.funcs.newGame, nil, nil, love.graphics.getWidth() / 3, 50, "New Game", "center", "h3", love.graphics.getWidth() / 3, love.graphics.getHeight() * 0.25),
        Button(self.funcs.quitGame, nil, nil, love.graphics.getWidth() / 3, 50, "Quit Game", "center", "h3", love.graphics.getWidth() / 3, love.graphics.getHeight() * 0.5),
    }
end

function menu:draw()
    for k, button in pairs(self.buttons) do
        button:setButtonColor(0, 1, 1)
        button:draw()
    end
end

function menu:run(clicked)
    local mouse_x, mouse_y = love.mouse.getPosition()

    for name, button in pairs(self.buttons) do
        if button:checkHover(mouse_x, mouse_y, 10) then
            if clicked then
                print("click")
                button:click()
            end
        else
        end
    end
end

return menu