-- Nomolos random ram script
-- Written by Derek Andrews <derek.george.andrews@gmail.com>
-- 7-11-2010

-- This script registers a callback on executing $C000, then fills
-- RAM with random values before proceeding, mainly to stress test
-- how well we are initializing variables without relying on initial
-- state of the system

local function fill_ram_with_random_values()

    for i=0,0x7FF do

        memory.writebyte(i, math.random() * 256)

    end;

end;

math.randomseed( os.time() );

memory.registerexecute(0xC000, 1, fill_ram_with_random_values);
