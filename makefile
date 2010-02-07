#Makefile for Nomolos

#Utility programs
NAMELIST_GENERATOR = nlgen

#CA65 programs
ASSEMBLER       = ca65
LINKER          = ld65

#directories
SRC_DIR     = src
INCLUDE_DIR = include
BIN_DIR     = bin

#Files
OUTPUT_NAME     = nomolos
NES_FILE        = $(OUTPUT_NAME).nes
FILES           = nomolos \
                  nomolosLogic \
                  rom0 \
                  rom1 \
                  rom2 \
                  chrrom0 \
                  chrrom1 \
                  chrrom2 \
                  chrrom3 \
                  loadLevelState \
                  playLevelState \
                  levelOutState \
                  levelInState \
                  gameOverState \
                  titleState \
                  map \
                  camera \
                  sprite \
                  entity \
                  controller \
                  sound \
                  geotests \
                  zp \
                  mapper \
                  ppu \
                  gameUIData \
                  levelDataIndex
OBJECT_FILES    = $(addprefix $(BIN_DIR)/,$(addsuffix .o, $(FILES)))
LST_FILES = $(addprefix $(SRC_DIR)/,$(addsuffix .lst, $(FILES)))
CONFIG_FILE     = $(OUTPUT_NAME).cfg
MAP_FILE         = $(OUTPUT_NAME).map
DEBUG_FILE      = $(OUTPUT_NAME).dbg

#Switches
INCLUDE_FLAGS = -I include \
                -I include/modules \
                -I include/entities \
                -I include/data/spritesheets \
                -I include/data/levels \
                -I include/data/gameUIData \
                -I include/ft_driver \
                -I include/global
ASSEMBLER_FLAGS = -g -l $(INCLUDE_FLAGS) -o
LINKER_FLAGS    = -C $(CONFIG_FILE) -m $(MAP_FILE) --dbgfile $(DEBUG_FILE) -o
NAMELIST_GENERATOR_FLAGS = -o $(NES_FILE) \
                           -nl ram ZEROPAGE 0000 \
                           -nl ram STACK 0100 \
                           -nl ram BSS 0200 \
                           -nl 0 ROM0 8000 \
                           -nl 1 ROM1 8000 \
                           -nl 2 ROM2 8000 \
                           -nl 7 CODE C000 \
                           -map $(MAP_FILE) \
                           $(addprefix -lst ,$(LST_FILES))

#Rules

#Rule for making the NES rom
all: $(NES_FILE)

#Rule for making the NES rom and generating debug files for FCEUXDSP
debug: $(NES_FILE)
	$(NAMELIST_GENERATOR) $(NAMELIST_GENERATOR_FLAGS)

#Rule for linking the final NES rom
$(NES_FILE): $(OBJECT_FILES) $(CONFIG_FILE)
	$(LINKER) $(OBJECT_FILES) $(LINKER_FLAGS) $(NES_FILE)

#Rule for assembling all the object files from source files
$(OBJECT_FILES): $(BIN_DIR)/%.o : $(SRC_DIR)/%.asm
	$(ASSEMBLER) $< $(ASSEMBLER_FLAGS) $@

#Rule for cleaning the build
clean:
	rm -f $(OBJECT_FILES) $(NES_FILE) $(MAP_FILE) $(LST_FILES) $(DEBUG_FILE) *.nl