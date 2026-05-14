# Balatro Brainstorm Mobile Buttons

Auto Reroll and Restart Run buttons for Brainstorm on Android and iOS.
Built because Brainstorm's built-in auto reroll requires Immolate (.exe/.dll),
which cannot run on mobile. This mod bypasses that entirely with pure Lua seed searching.

## Requirements
- [Steamodded](https://github.com/Steamodded/smods)
- [Brainstorm](https://github.com/OceanRamen/Brainstorm)

## Installation
1. Download or clone this repo
2. Place the `SkippySkipMoh` folder in your Mods directory

**Android:**
/data/data/systems.shorty.lmm.balatro/files/save/ASET/Mods/
**iOS:**


## Features

### Auto Reroll Button
- Appears in the pause menu and game over screen
- Searches seeds using your Brainstorm tag settings (Charm Tag, Economy Tag, etc)
- Soul card search support via Brainstorm's soul search setting
- Pack search support
- Pure Lua implementation — no Immolate needed, works fully on mobile

### Restart Run Button
- Appears in the pause menu and game over screen
- Instantly restarts your current run with the same settings

## How to Use
1. Open Brainstorm settings in-game and set your desired tag/soul/pack target
2. Press **Auto Reroll** from the pause menu or game over screen
3. The mod will search up to 50,000 seeds and start a run with a matching one

## Credits
- [Brainstorm](https://github.com/OceanRamen/Brainstorm) by OceanRamen — seed search logic and pseudorandom implementation
- [Restart Run Button](https://thunderstore.io/c/balatro/p/ScrimpScrampi/Restart_Run_Button/) by ScrimpScrampi — original restart run concept
- Pha4tom — mobile adaptation and Auto Reroll button implementation

