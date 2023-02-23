-- config.lua
local love = require('love')

function love.conf(t)
    t.version = "11.3"
    t.console = true        -- Enable the debug console for Windows.
    t.window.title = 'axolot'
    t.window.width =  1080  -- Game's screen width (number of pixels)
    t.window.height = 720   -- Game's screen height (number of pixels)
    t.window.resizable = false
end