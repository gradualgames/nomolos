##########################################
# CA65 releated                          #
##########################################

AS      	= ca65
LD      	= ld65
MAPFILE 	= nomolos.map
LSTFILE     = nomolos.lst
DEBUGFILE       = nomolos.txt
ASFLAGS 	= -g -l -o
LDFLAGS 	= -m $(MAPFILE) --dbgfile $(DEBUGFILE) -o 
CONFIG  	= -C nomolos.cfg
INCLUDEPATHLIST = -I./src

##########################################
# Project specific                       #
##########################################

# common directories
SRC_DIR          = 

# Files list
MAIN_FILES		= nomolos
CONFIG_FILE     = nomolos.cfg
COMMON_FILES	= constants nomolosLogic rom0 chrrom0 loadLevelState playLevelState map camera sprite entity controller

# Now create list with proper path
FILELIST = $(addprefix $(SRC_DIR), $(MAIN_FILES)) \
	   $(addprefix $(SRC_DIR), $(COMMON_FILES)) \

# Then prepare sources files list
SOURCES  = $(FILELIST:=.asm)
OBJECTS  = $(FILELIST:=.o) 
LISTS    = $(FILELIST:=.lst)

# Name used for final results
NES_FILE = nomolos.nes

##########################################
# Rules                                  #
##########################################

all: $(SOURCES) $(NES_FILE)

# Linking nes file
$(NES_FILE): $(OBJECTS)
	$(LD) $(CONFIG) $(OBJECTS) $(LDFLAGS) $(NES_FILE)

# Assembling all objects
$(OBJECTS): %.o : %.asm
	$(AS) $< $(ASFLAGS) $@

# Cleaning
clean:
	rm -f $(OBJECTS) $(NES_FILE) $(MAPFILE) $(LISTS) $(DEBUGFILE) *.nl
