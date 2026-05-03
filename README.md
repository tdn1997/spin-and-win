# spin-and-win

Mobile-first slot machine game built with Godot 4.x.

## Overview

`spin-and-win` is a simple portrait slot machine game for Android and iOS. It includes a main menu, playable 3-reel slot screen, settings screen, coin balance, bet handling, win calculation, reel animation, and generated audio feedback.

## Requirements

- Godot 4.x
- Android export templates and Android SDK/JDK for Android builds
- Xcode, iOS export templates, and Apple signing credentials for iOS builds

## Project Structure

```text
res://
  scenes/
    main_menu.tscn
    game.tscn
    settings.tscn
  scripts/
    game_manager.gd
    slot_machine.gd
    reel.gd
    ui_manager.gd
    audio_manager.gd
  assets/
    Slot Machine/
    external/
  resources/
    symbols/
  skills/
  llm-wiki/
```

## Gameplay

- Starting coins: `1000`
- Default bet: `10`
- Tap `SPIN` to play.
- Bet is subtracted before reels spin.
- Reels stop with staggered timing.

Payouts:

- `777 / 777 / 777`: jackpot, `bet * 50`
- Any 3 matching symbols: `bet * 10`
- Any 2 matching symbols: `bet * 2`
- No match: `0`

## Running

Open this folder in Godot 4.x, then run the project. The main scene is:

```text
res://scenes/main_menu.tscn
```

This repo was validated with:

```text
Godot 4.6.2 stable
```

## Mobile Export

Export presets are included in `export_presets.cfg`.

- Android package: `com.example.spinandwin`
- iOS bundle identifier: `com.example.spinandwin`
- Orientation: portrait

Before building, configure export templates, Android SDK/JDK, and iOS signing in Godot Editor.

## Assets

The game uses local assets from:

```text
assets/Slot Machine/
```

No external assets are currently downloaded. Future downloaded free assets should be stored in:

```text
assets/external/
```

See `llm-wiki/assets.md` for asset mapping and license notes.

