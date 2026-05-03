# Mobile Export Guide

## Supported Platforms
- Android
- iOS

Desktop and web are intentionally out of scope for this project.

## Android
- Package name: `com.example.spinandwin`
- App name: `spin-and-win`
- Orientation: portrait
- Export preset: `Android`
- Enable Android export templates in Godot before producing APK/AAB builds.

## iOS
- Bundle identifier: `com.example.spinandwin`
- App name: `spin-and-win`
- Orientation: portrait
- Export preset: `iOS`
- Configure Apple team ID and signing identity in Godot/Xcode before device builds.

## Notes
- Godot CLI is not currently available in the shell PATH, so final export validation must be done from Godot Editor.
- The placeholder app icon uses `res://assets/Slot Machine/slot-symbol1.png`.

