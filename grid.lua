_addon.name = 'grid'
_addon.version = '202406'
_addon.author = 'yyoshisaur'
_addon.commands = {'grid'}

require('sets')
require('logger')
local images = require('images')
local texts = require('texts')

grid_img_settings = {
    pos = {
        x = 0,
        y = 0,
    },
    size = {
        width = 100,
        height = 100,
    },
    texture = {
        path = string.format('%sres/%s.png',windower.addon_path, 'yellow'),
        fit =false,
    },
    draggable = false,
}

grid_txt_settings = {
    pos = {
        x = 0,
        y = 0,
    },
    bg = {
        alpha = 155,
        red = 0,
        green = 0,
        blue = 0,
    },
    text = {
        size = 9,
    }
} 

mouse_txt_settings = {
    pos = {
        x = 0,
        y = 0,
    },
    bg = {
        alpha = 255,
        red = 100,
        green = 0,
        blue = 0,
    },
    text = {
        size = 9,
    }
} 

local grid = {}
local mouse_txt = texts.new(mouse_txt_settings)

local grid_enable = true
local mouse_pos_enable = true

function init_grid()
    for i = 1 , math.ceil(windower.get_windower_settings().x_res/100) do
        grid[i] = {}
        for j = 1, math.ceil(windower.get_windower_settings().y_res/100) do
            local grid_pos_x = (i-1) * 100
            local grid_pos_y = (j-1) * 100
            grid[i][j] = {}
            grid_img_settings.pos.x = grid_pos_x
            grid_img_settings.pos.y = grid_pos_y
            grid[i][j]['img'] = images.new(grid_img_settings)
            grid_pos_str = string.format('(%d, %d)', grid_pos_x, grid_pos_y)
            grid_txt_settings.pos.x = grid_pos_x + 5
            grid_txt_settings.pos.y = grid_pos_y + 5
            grid[i][j]['txt'] = texts.new(grid_pos_str, grid_txt_settings)
        end
    end
end

function show_grid(grid_color)
    for i = 1 , math.ceil(windower.get_windower_settings().x_res/100) do
        for j = 1, math.ceil(windower.get_windower_settings().y_res/100) do
            if grid_color then
                grid[i][j]['img']:path(string.format('%sres/%s.png',windower.addon_path, grid_color))
            end
            grid[i][j]['img']:show()
            grid[i][j]['txt']:show()
        end
    end
end

function hide_grid()
    for i = 1 , math.ceil(windower.get_windower_settings().x_res/100) do
        for j = 1, math.ceil(windower.get_windower_settings().y_res/100) do
            grid[i][j]['img']:hide()
            grid[i][j]['txt']:hide()
        end
    end
end

windower.register_event('mouse', function(type, x, y, delta, blocked)
    if not mouse_pos_enable then return end
    local mouse_pos_str = string.format('(%4d, %4d)', x, y)
    local mouse_pos_x = x
    local mouse_pos_y = y - 20
    if x > windower.get_windower_settings().x_res - 75 then
        mouse_pos_x = x - 80
    end
    if y < 50 then
        mouse_pos_y = y + 20
    end

    mouse_txt:pos(mouse_pos_x, mouse_pos_y)
    mouse_txt:text(mouse_pos_str)
    mouse_txt:show()
end)

help = [[
toggle mouse position 
  //grid mouse
toggle grid
  //grid grid
change grid color
  //grid color red/blue/yellow/white]]
 
windower.register_event('addon command', function (...)
    local cmd = {...}

    cmd_1 = cmd[1] and cmd[1]:lower() or ''

    if S{'mouse', 'm'}:contains(cmd_1) then
        mouse_pos_enable = not mouse_pos_enable
        if not mouse_pos_enable then
            mouse_txt:hide()
        end
    elseif S{'grid', 'g'}:contains(cmd_1) then
        grid_enable = not grid_enable
        if grid_enable then
            show_grid()
        else
            hide_grid()
        end
    elseif S{'color', 'c'}:contains(cmd_1) then
        local grid_color = cmd[2] and cmd[2]:lower() or ''
        if grid_color and S{'red', 'blue', 'yellow', 'white'}:contains(grid_color) then
            grid_enable = true
            show_grid(grid_color)
        end
    else
        log(help)
    end
end)

init_grid()
show_grid()