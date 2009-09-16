#Makefile for Nomolos

#CA65 variables and switches
ASSEMBLER       = ca65
LINKER          = ld65
MAPFILE         = nomolos.map
LSTFILE         = nomolos.lst
DEBUGFILE       = nomolos.txt
ASSEMBLER_FLAGS = -g -l -o
LINKER_FLAGS    = -m $(MAPFILE) --dbgfile $(DEBUGFILE) -o 
CONFIG          = -C nomolos.cfg

#Output files
CONFIG_FILE     = nomolos.cfg
INCLUDE_FILES   = constants.inc
OBJECT_FILES    = nomolos.o nomolosLogic.o rom0.o chrrom0.o loadLevelState.o playLevelState.o map.o camera.o sprite.o entity.o controller.o sound.o
NES_FILE        = nomolos.nes

#Rules
all: $(NES_FILE)

$(NES_FILE): $(OBJECT_FILES) $(CONFIG_FILE)
	$(LINKER) $(CONFIG) $(OBJECT_FILES) $(LINKER_FLAGS) $(NES_FILE)

$(OBJECT_FILES): %.o : %.asm $(INCLUDE_FILES)
	$(ASSEMBLER) $< $(ASSEMBLER_FLAGS) $@

clean:
	rm -f $(OBJECT_FILES) $(NES_FILE) $(MAPFILE) *.lst *.nl *.txt