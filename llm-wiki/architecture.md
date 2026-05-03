# Architecture

## Scenes
- `res://scenes/main_menu.tscn`: entry menu.
- `res://scenes/game.tscn`: slot gameplay screen.
- `res://scenes/settings.tscn`: settings screen.

## Scripts
- `GameManager`: autoload for coins, bet, last win, settings, and persistence.
- `AudioManager`: autoload for generated spin/win/jackpot tones and simple music.
- `slot_machine.gd`: owns reel setup, spin flow, result generation, payout, and game UI.
- `reel.gd`: owns one reel's visual state and spin tween.
- `ui_manager.gd`: builds Main Menu and Settings UI.

## Data Flow
- UI calls `GameManager.spend_bet()` when a spin starts.
- `slot_machine.gd` randomizes reel results and waits for all reels to stop.
- Payout is calculated and applied through `GameManager.award()`.
- Labels update through `GameManager` signals.

