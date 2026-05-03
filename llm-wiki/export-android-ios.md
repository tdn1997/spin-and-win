# Export Android and iOS

## Android
- Preset name: `Android`
- Package: `com.example.spinandwin`
- App name: `spin-and-win`
- Orientation: portrait
- Architectures: ARMv7 and ARM64 enabled.

Before exporting:
- Install Godot Android export templates.
- Configure Android SDK/JDK paths in Godot Editor.
- Add release signing if publishing.

## iOS
- Preset name: `iOS`
- Bundle identifier: `com.example.spinandwin`
- App name: `spin-and-win`
- Orientation: portrait.

Before exporting:
- Install iOS export templates.
- Configure Apple team ID and signing identity.
- Open the generated project in Xcode for device/App Store builds.

## Current Limitation
`godot` is not available in the shell PATH on this machine, so export preset validation should be completed inside Godot Editor.

