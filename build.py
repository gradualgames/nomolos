import os
from subprocess import call
import shlex
import shutil
import sys

nes_file = "nomolos.nes"
linker_cfg_file = "nomolos.cfg"
map_file = "nomolos.map"
debug_file = "nomolos.nes.dbg"
ndx_file = "nomolos.nes.ndx"

src_path = "src"
bin_path = "bin"

include_paths = ["include",
                 "include/entities",
                 "include/fixed_bank_data",
                 "include/levels",
                 "include/spritesheets"]

files =["boss1.asm",
        "boss2.asm",
        "boss3.asm",
        "boss4.asm",
        "boss5.asm",
        "camera.asm",
        "continue_end_state.asm",
        "controller.asm",
        "ending_state.asm",
        "entities.asm",
        "entity.asm",
        "fixed_bank_data.asm",
        "geotests.asm",
        "level_in_state.asm",
        "level1.asm",
        "level1_2.asm",
        "level2.asm",
        "level2_2.asm",
        "level3.asm",
        "level3_2.asm",
        "level4.asm",
        "level4_2.asm",
        "level5.asm",
        "level5_2.asm",
        "level6.asm",
        "level6_2.asm",
        "load_level_state.asm",
        "map.asm",
        "mapper.asm",
        "nomolos.asm",
        "nomolos_logic.asm",
        "play_level_state.asm",
        "ppu.asm",
        "ram.asm",
        "slides.asm",
        "sound_effects.asm",
        "soundengine.asm",
        "sprite.asm",
        "statemanager.asm",
        "title_state.asm",
        "zp.asm"]


def clean_build():
    if os.path.exists(nes_file):
        os.remove(nes_file)
    if os.path.exists(map_file):
        os.remove(map_file)
    if os.path.exists(debug_file):
        os.remove(debug_file)
    if os.path.exists(ndx_file):
        os.remove(ndx_file)
    if os.path.exists(bin_path):
        shutil.rmtree(bin_path, ignore_errors=True)

def make_build(additional_args):
    global files
    abs_include_paths = []
    for include_path in include_paths:
        abs_include_paths.append(os.path.normpath(include_path))

    file_names = [os.path.splitext(file_name)[0]
        for file_name in files]

    ca65_args = ["ca65", "-g"]

    for abs_include_path in abs_include_paths:
        ca65_args.append("-I")
        ca65_args.append(abs_include_path)

    clean_build()
    os.makedirs(bin_path, exist_ok=True)

    for file_name in file_names:
        ca65_args_file_name = list(ca65_args)
        ca65_args_file_name.append(os.path.normpath("%s/%s.asm" % (src_path, file_name)))
        ca65_args_file_name.append("-l")
        ca65_args_file_name.append(os.path.normpath("%s/%s.lst" % (bin_path, file_name)))
        ca65_args_file_name.append("-o")
        ca65_args_file_name.append(os.path.normpath("%s/%s.o" % (bin_path, file_name)))
        ca65_args_file_name.append("-DDEBUG")
        if additional_args != None:
            ca65_args_file_name.extend(additional_args)
        call(ca65_args_file_name)

    ld65_args = ["ld65", "-o", nes_file, "-C", linker_cfg_file, "-m", map_file, "--dbgfile", debug_file]
    ld65_args.extend([os.path.normpath("%s/%s.o") % (bin_path, file_name) for file_name in file_names])
    call(ld65_args)

if len(sys.argv) == 1:
    make_build(None)

if len(sys.argv) >= 2:
    if "clean" in sys.argv:
        clean_build()
    else:
        additional_args = []
        for i in range(1, len(sys.argv)):
            additional_args.append(sys.argv[i])
            make_build(additional_args)
