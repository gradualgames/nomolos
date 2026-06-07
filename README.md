# Nomolos: Storming the Catsle

**Nomolos: Storming the Catsle** is Gradual Games' first release for the Nintendo Entertainment System (NES). It is a classic action platformer starring a cat in armor named **Nomolos**.

## Story

Two cats, Solomon and his friend Snow, are enjoying a beautiful day together when a mysterious portal suddenly opens before them. An enormous purple arm shoots out, grabs Snow by the scruff of the neck, and vanishes back through the portal.

Determined to rescue his friend, Solomon follows.

On the other side, Solomon is transformed into **Nomolos**, a fierce feline warrior complete with armor and a humanoid physique. Spotting the massive purple figure retreating toward the dreaded **Catsle** with Snow in tow, Nomolos sets out on a perilous journey to save his friend.

## Features

- 12 action-packed platforming levels
- 4 powerful bosses guarding the path to the Catsle
- Multiple difficulty levels, including an Easy Mode for newcomers
- Powerful weapons and helpful powerups hidden throughout the world
- Dozens of enemies and hazards to overcome
- An all-Baroque soundtrack featuring music by:
  - Domenico Scarlatti
  - Johann Sebastian Bach
  - Jean-Philippe Rameau
  - François Couperin
  - Antonio Soler

## New In This Release

- Easier opening levels
- Upgraded cutscene graphics
- Bonus level / warp zone hidden somewhere in the game

Can you find it?

## Building From Source

### Dependencies

The build process has only two requirements:

- **cc65** (must be available in your system PATH)
- **Python 3** (must be available in your system PATH)

### Verify Installation

Linux:

```bash
cc65 --version
python3 --version
```

Windows:

```cmd
cc65 --version
python3 --version
```

### Build

From the root of the repository:

```bash
python3 build.py
```

This will compile the game and generate a playable `.nes` ROM image.

### Clean

To remove generated build files:

```bash
python3 build.py clean
```

### Running

The generated ROM can be played in any NES emulator or on compatible NES hardware using a flash cartridge.

## License

See the repository license file for licensing information.
