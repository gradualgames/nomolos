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
FILES           = zp \
                  ram \
                  nomolos \
                  nomolos_logic \
                  level1 \
                  level1_2 \
                  level2 \
                  level2_2 \
                  boss2 \
                  level3 \
                  level3_2 \
                  level4 \
                  level4_2 \
                  level5 \
                  level5_2 \
                  level6 \
                  level6_2 \
                  boss3 \
                  boss1 \
                  entities \
                  slides \
                  load_level_state \
                  play_level_state \
                  level_in_state \
                  title_state \
                  continue_end_state \
                  map \
                  camera \
                  sprite \
                  entity \
                  controller \
                  soundengine \
                  sound_effects \
                  geotests \
                  mapper \
                  ppu \
                  statemanager \
                  fixed_bank_data
OBJECT_FILES    = $(addprefix $(BIN_DIR)/,$(addsuffix .o, $(FILES)))
LST_FILES = $(addprefix $(SRC_DIR)/,$(addsuffix .lst, $(FILES)))
CONFIG_FILE     = $(OUTPUT_NAME).cfg
MAP_FILE         = $(OUTPUT_NAME).map
DEBUG_FILE      = $(OUTPUT_NAME).dbg

#Switches
INCLUDE_FLAGS = -I include \
                -I include/entities \
                -I include/spritesheets \
                -I include/levels \
                -I include/fixed_bank_data
ASSEMBLER_FLAGS = -g -l $(INCLUDE_FLAGS) -o
LINKER_FLAGS    = -C $(CONFIG_FILE) -m $(MAP_FILE) --dbgfile $(DEBUG_FILE) -o
NAMELIST_GENERATOR_FLAGS = -rom $(NES_FILE) \
                           -nl ram ZEROPAGE 0000 \
                           -nl ram STACK    0100 \
                           -nl ram BSS      0200 \
                           -nl 0   ROM0     8000 \
                           -nl 11  ROM11    8000 \
                           -nl 13  ROM13    8000 \
                           -nl 15  CODE     C000 \
                           -map $(MAP_FILE) \
                           $(addprefix -lst ,$(LST_FILES))

#Rules

#Rule for making the NES rom
all: $(NES_FILE)

#Rule for ensuring bin directory is present
$(BIN_DIR):
	mkdir $(BIN_DIR)

#Rule for making the NES rom and generating debug files for FCEUXDSP
debug: $(NES_FILE)
	$(NAMELIST_GENERATOR) $(NAMELIST_GENERATOR_FLAGS)

#Rule for linking the final NES rom
$(NES_FILE): $(OBJECT_FILES) $(CONFIG_FILE)
	$(LINKER) $(OBJECT_FILES) $(LINKER_FLAGS) $(NES_FILE)

#Rule for assembling all the object files from source files
$(OBJECT_FILES): $(BIN_DIR)/%.o : $(SRC_DIR)/%.asm $(BIN_DIR)
	$(ASSEMBLER) $< $(ASSEMBLER_FLAGS) $@

#Rule for cleaning the build
clean:
	rm -f $(OBJECT_FILES) $(NES_FILE) $(MAP_FILE) $(LST_FILES) $(DEBUG_FILE) *.nl
	rm -rf $(BIN_DIR)