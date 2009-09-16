ASSEMBLER       = ca65
LINKER          = ld65
MAPFILE         = nomolos.map
LSTFILE         = nomolos.lst
DEBUGFILE       = nomolos.txt
ASSEMBLER_FLAGS = -g -l -o
LINKER_FLAGS    = -m $(MAPFILE) --dbgfile $(DEBUGFILE) -o 
CONFIG          = -C nomolos.cfg

CONFIG_FILE     = nomolos.cfg
INCLUDE_FILES   = constants.inc
SOURCE_FILES    = nomolos.asm nomolosLogic.asm rom0.asm chrrom0.asm loadLevelState.asm playLevelState.asm map.asm camera.asm sprite.asm entity.asm controller.asm sound.asm
OBJECT_FILES    = nomolos.o nomolosLogic.o rom0.o chrrom0.o loadLevelState.o playLevelState.o map.o camera.o sprite.o entity.o controller.o sound.o

NES_FILE = nomolos.nes

all: $(NES_FILE)

$(NES_FILE): $(OBJECT_FILES) $(CONFIG_FILE)
	$(LINKER) $(CONFIG) $(OBJECT_FILES) $(LINKER_FLAGS) $(NES_FILE)

$(OBJECT_FILES): %.o : %.asm
	$(ASSEMBLER) $< $(ASSEMBLER_FLAGS) $@

clean:
	rm -f $(OBJECT_FILES) $(NES_FILE) $(MAPFILE) *.lst *.txt