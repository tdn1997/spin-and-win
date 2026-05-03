# Godot Game Dev Conventions

## Engine
- Use Godot 4.x.
- Prefer GDScript and scene-based composition.
- Keep gameplay scenes under `res://scenes/` and reusable behavior under `res://scripts/`.

## GDScript Style
- Use typed variables and function return types where practical.
- Use signals for cross-system updates such as coins, bet, settings, and UI refreshes.
- Keep UI code in `Control`-based scenes for mobile responsiveness.
- Avoid hardcoded device resolution; use anchors, containers, and stretch settings.

## Scene Organization
- `main_menu.tscn` owns the entry flow.
- `game.tscn` owns slot gameplay.
- `settings.tscn` owns persistent settings controls.
- Autoloads:
  - `GameManager`: player state and persistence.
  - `AudioManager`: sound/music playback.

## Mobile First
- Portrait orientation only.
- Buttons should have large touch targets.
- Use containers and margins for safe spacing across devices.

