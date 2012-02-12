-- Nomolos hitbox script
-- Written by Derek Andrews <derek.george.andrews@gmail.com>
-- 7-11-2010

-- This script shows locations of various hit boxes in Nomolos, used
-- for tweaking/tightening gameplay.

local running = true;
local restrainingorder = false;
local myoutput;

-- draw a box and take care of coordinate checking
local function box(x1,y1,x2,y2,color)
    y1 = y1 - 8;
    y2 = y2 - 8;
    -- gui.text(50,50,x1..","..y1.." "..x2..","..y2);
    if (x1 > 0 and x1 < 255 and x2 > 0 and x2 < 255 and y1 > 0 and y1 < 224 and y2 > 0 and y2 < 224) then
        --gui.drawbox(x1,y1,x2,y2,color);
        gui.drawline(x1,y1,x2,y1,color);
        gui.drawline(x2,y1,x2,y2,color);
        gui.drawline(x1,y2,x2,y2,color);
        gui.drawline(x1,y1,x1,y2,color);
    end;
end;

local function rect_in_rect_executed()

--rectangle A:
--w2 - left x
--w3 - top y
--b2 - width
--b3 - height
--rectangle B:
--w4 - left x
--w5 - top y
--b4 - width
--b5 - height
--global variables used:
--rectangle A:
--w6 - right x
--w7 - bottom y
--rectangle B:
--w8 - right x
--w9 - bottom y

    ah,bh = memory.readbyte(w2+1), memory.readbyte(w3+1)
    if (ah == 0 and bh == 0) then
        a,b = memory.readbyte(w2),memory.readbyte(w3)
        c,d = memory.readbyte(b2),memory.readbyte(b3)
        box(a,b,a+c,b+d,"red");
    end;

end;

local function draw_attack_rect()

    ah,bh = memory.readbyte(nomolos_attack_rect_x+1),memory.readbyte(nomolos_attack_rect_y+1);
    if (ah == 0 and bh == 0) then
        a,b = memory.readbyte(nomolos_attack_rect_x),memory.readbyte(nomolos_attack_rect_y);
        c,d = a+memory.readbyte(nomolos_attack_rect_width),b+memory.readbyte(nomolos_attack_rect_height);
        box(a,b,c,d, "green");
    end;

end;

local function draw_map_collision_test_dot()

    param_x = memory.readbyte(w0+1)*256+memory.readbyte(w0)
    param_y = memory.readbyte(w1+1)*256+memory.readbyte(w1)
    camera_x = memory.readbyte(camera_scroll_x+1)*256+memory.readbyte(camera_scroll_x)

    box_x = param_x - camera_x - 1
    box_y = param_y - 1
    box_x2 = box_x + 3
    box_y2 = box_y + 3

    box(box_x,box_y,box_x2,box_y2,"magenta");

end;

nomolos_screen_x = 0x0055
nomolos_screen_y = 0x0057
nomolos_width = 12
nomolos_height = 28

nomolos_attack_rect_x = 0x0059
nomolos_attack_rect_y = 0x005B
nomolos_attack_rect_width = 0x005D
nomolos_attack_rect_height = 0x005E

entity_instances = 0x0300

b2 = 0x0002
b3 = 0x0003
w0 = 0x000A
w1 = 0x000C
w2 = 0x000E
w3 = 0x0010
camera_scroll_x = 0x006F

geotests_rect_in_rect_16bit = 0xE988
nomolos_is_deadly_rts_1 = 0xC2C1
nomolos_is_deadly_rts_2 = 0xC2CD
nomolos_is_deadly_rts_3 = 0xC2D9

map_test_collision = 0XD821

memory.registerexecute(geotests_rect_in_rect_16bit, 110, rect_in_rect_executed)
memory.registerexecute(nomolos_is_deadly_rts_1, 1, draw_attack_rect)
memory.registerexecute(nomolos_is_deadly_rts_2, 1, draw_attack_rect)
memory.registerexecute(nomolos_is_deadly_rts_3, 1, draw_attack_rect)
memory.registerexecute(map_test_collision, 1, draw_map_collision_test_dot)

local a,b,c,d;
while (running) do

        ah,bh = memory.readbyte(nomolos_screen_x+1),memory.readbyte(nomolos_screen_y+1);
        if (ah == 0 and bh == 0) then
            a,b = memory.readbyte(nomolos_screen_x),memory.readbyte(nomolos_screen_y);
            c,d = a+nomolos_width,b+nomolos_height;
            box(a,b,c,d,"green");
        end;

    FCEU.frameadvance()
end

gui.popup("script exited main loop");

