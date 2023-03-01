local love = require('love')

local button = require('components.button')
local game = require('states.game')
local boss = require('boss')
local powerupManager = require('powerupManager')

local pause = {}

function pause:load()
    self.win = false
    self.ended = false
    self.funcs = {
        mainMenu = function ()
            game:resetPlayerAndBoss()
            game:changeState("menu")
        end,
        restart = function ()
            source = love.audio.newSource("music/BossMain.wav", "stream")
            self:reset() 
            powerupManager:reset()
            game:resetPlayerAndBoss()
            game:changeState("running")
        end
    }

    self.buttons = {
        Button(self.funcs.restart, nil, nil, love.graphics.getWidth() / 3, 50, "Restart", "center", "h3", love.graphics.getWidth() / 3, love.graphics.getHeight() * 0.25),
        Button(self.funcs.mainMenu, nil, nil, love.graphics.getWidth() / 3, 50, "Menu", "center", "h3", love.graphics.getWidth() / 3, love.graphics.getHeight() * 0.5),
    }
end

function pause:draw()
    if self.ended then
        if self.win then
            Text(
                "GGWP",
                0,
                love.graphics.getHeight() * 0.6,
                "h1",
                false,
                false,
                love.graphics.getWidth(),
                "center",
                1
            ):draw()
        else
            Text(
                "Oops",
                0,
                love.graphics.getHeight() * 0.6,
                "h1",
                false,
                false,
                love.graphics.getWidth(),
                "center",
                1
            ):draw()
        end
    end
    for k, button in pairs(self.buttons) do
        button:setButtonColor(0, 1, 1)
        button:draw()
    end
end

function pause:run(clicked)
    local mouse_x, mouse_y = love.mouse.getPosition()

    for name, button in pairs(self.buttons) do
        if button:checkHover(mouse_x, mouse_y, 10) then
            if clicked then
                button:click()
            end
        else
        end
    end
end

function pause:reset()
    self.win = false
    self.ended = false
end

return pause