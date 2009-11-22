#Makefile for Nomolos

#Utility programs
NAMELIST_GENERATOR = Ca65LstToNl

#CA65 programs
ASSEMBLER       = ca65
LINKER          = ld65

#Files
NES_FILE        = nomolos.nes
FILES           = nomolos \
                  nomolosLogic \
                  rom0 \
                  rom1 \
                  chrrom0 \
                  chrrom1 \
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
LST_FILES = $(addsuffix .lst, $(FILES))
INCLUDE_FILES   = constants.inc \
                  macros.inc \
                  flags.inc \
                  structs.inc \
                  mouse.inc \
                  explosion.inc \
                  deentle.inc
CONFIG_FILE     = nomolos.cfg
MAPFILE         = nomolos.map
LSTFILE         = nomolos.lst
DEBUGFILE       = nomolos.txt

#Switches
ASSEMBLER_FLAGS = -g -l --include-dir ft_driver -o
LINKER_FLAGS    = -C $(CONFIG_FILE) -m $(MAPFILE) --dbgfile $(DEBUGFILE) -o 
NAMELIST_GENERATOR_FLAGS = -nl ram ZEROPAGE 0000 \
                           -nl ram STACK 0100 \
                           -nl ram BSS 0200 \
                           -nl 0 ROM0 8000 \
                           -nl 1 ROM1 8000 \
                           -nl 3 CODE C000 \
                           -map $(MAPFILE) \
                           $(addprefix -lst ,$(LST_FILES))

#Rules

#Rule for making everything!
all: $(NES_FILE)

#Rule for linking the final NES rom
$(NES_FILE): $(OBJECT_FILES) $(CONFIG_FILE)
	$(LINKER) $(OBJECT_FILES) $(LINKER_FLAGS) $(NES_FILE)
	$(NAMELIST_GENERATOR) $(NAMELIST_GENERATOR_FLAGS)

#Rule for assembling all the object files from source files
$(OBJECT_FILES): %.o : %.asm $(INCLUDE_FILES)
	$(ASSEMBLER) $< $(ASSEMBLER_FLAGS) $@

#Rule for cleaning the build
clean:
	rm -f $(OBJECT_FILES) $(NES_FILE) $(MAPFILE) *.lst *.nl *.txt