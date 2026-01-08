# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Ndmr (Native DMR) - A modern, cross-platform graphical application for programming Digital Mobile Radio (DMR) devices. Inspired by [qdmr](https://github.com/hmatuschek/qdmr), Ndmr aims to provide a native-feeling GUI experience on Windows, Linux, macOS, Android, and iOS.

### Goals
- Universal codeplug programming software supporting multiple DMR radio manufacturers
- Native UI experience on each platform
- Modern architecture with clean separation between UI and radio communication logic

### Target Radio (Initial)
- Anytone AT-D878UV

## Build & Development

### Prerequisites
- Flutter 3.38+ (install via `brew install --cask flutter` on macOS)
- Dart 3.10+

### Common Commands

```bash
# Install dependencies
flutter pub get

# Generate freezed/riverpod code (required after model changes)
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run -d macos    # macOS
flutter run -d chrome   # Web
flutter run -d linux    # Linux
flutter run -d windows  # Windows

# Build for production
flutter build macos
flutter build web
flutter build apk       # Android
flutter build ios       # iOS

# Run tests
flutter test

# Run a single test file
flutter test test/widget_test.dart

# Analyze code
flutter analyze
```

### Code Generation

After modifying any file with `@freezed` or `@riverpod` annotations, regenerate code:
```bash
dart run build_runner build --delete-conflicting-outputs
```

## Architecture

### Tech Stack
- **Framework**: Flutter 3.x with Dart
- **State Management**: Riverpod (flutter_riverpod + riverpod_annotation)
- **Immutable Models**: Freezed with JSON serialization
- **File Handling**: file_picker + path_provider

### Project Structure
```
lib/
├── main.dart                 # Entry point
├── app.dart                  # MaterialApp with Riverpod
├── core/
│   └── theme/                # App theming (light/dark)
└── features/
    └── codeplug/
        ├── data/
        │   ├── models/       # Freezed data classes (Channel, Zone, Contact, etc.)
        │   └── repositories/ # File I/O operations
        └── presentation/
            ├── providers/    # Riverpod state management
            ├── screens/      # Page-level widgets
            └── widgets/      # Reusable UI components
```

### Data Models
Located in `lib/features/codeplug/data/models/`:
- **Channel**: Radio channel with frequency, power, mode (analog/digital), timeslot, color code
- **Zone**: Named group of channels
- **Contact**: DMR contact (talk group, private, all call) with DMR ID
- **ScanList**: List of channels for scanning
- **RadioSettings**: Radio configuration (DMR ID, callsign, display settings)
- **Codeplug**: Aggregate model containing all of the above

### State Management
- `CodeplugNotifier` (`codeplug_provider.dart`): Main state holder for the current codeplug
- `CodeplugRepository`: Handles file save/load operations

### Reference: qdmr
The original qdmr project (C++/Qt) provides context for DMR radio programming concepts:
- Codeplug management (channels, zones, contacts, scan lists)
- Device-specific communication protocols
- Multi-manufacturer radio support (Radioddity, Baofeng, TYT, Anytone, BTECH, etc.)

## MCP Servers

This project has the following MCP servers enabled:
- `drawio-diagrams` - For creating and editing architecture diagrams
- `google-suite` - For Google Workspace integration
