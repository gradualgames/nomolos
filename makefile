#Makefile for Nomolos

#CA65 variables
ASSEMBLER       = ca65
LINKER          = ld65

#Files
NES_FILE        = nomolos.nes
FILES           = nomolos \
                  nomolosLogic \
                  rom0 \
                  chrrom0 \
                  loadLevelState \
                  playLevelState \
                  map \
                  camera \
                  sprite \
                  entity \
                  controller \
                  sound \
                  geotests
OBJECT_FILES    = $(addsuffix .o, $(FILES))
INCLUDE_FILES   = constants.inc macros.inc flags.inc structs.inc
CONFIG_FILE     = nomolos.cfg
MAPFILE         = nomolos.map
LSTFILE         = nomolos.lst
DEBUGFILE       = nomolos.txt

#Switches
ASSEMBLER_FLAGS = -g -l --include-dir ft_driver -o
LINKER_FLAGS    = -C $(CONFIG_FILE) -m $(MAPFILE) --dbgfile $(DEBUGFILE) -o 

#Rules

#Rule for making everything!
all: $(NES_FILE)

#Rule for linking the final NES rom
$(NES_FILE): $(OBJECT_FILES) $(CONFIG_FILE)
	$(LINKER) $(OBJECT_FILES) $(LINKER_FLAGS) $(NES_FILE)

#Rule for assembling all the object files from source files
$(OBJECT_FILES): %.o : %.asm $(INCLUDE_FILES)
	$(ASSEMBLER) $< $(ASSEMBLER_FLAGS) $@

#Rule for cleaning the build
clean:
	rm -f $(OBJECT_FILES) $(NES_FILE) $(MAPFILE) *.lst *.nl *.txt