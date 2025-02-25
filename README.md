# Dokusend
WIP Flutter app for converting image-scanned documents and PDFs to Markdown.

## Features
- Document list viewing and management
- Image document support
- Document sharing capabilities

## Getting Started
### Prerequisites
- Flutter SDK
- [documentapi](https://github.com/nihiluis/documentapi)
- [jobengine](https://github.com/nihiluis/jobengine)

## Development

### Local Development
Run the development server:

```bash
# Local run
sh dev.sh
```

### Code Generation
The project uses code generation for generating the SQL data logic.

```bash
# One-time code generation
flutter pub run build_runner build

# Watch mode for continuous code generation
flutter pub run build_runner watch
```

### Project Structure
```
lib/
  ├── services/           # Business logic and services
  │   └── document/       # Document-related services
  ├── views/             # UI components and screens
  └── main.dart          # Application entry point
```

## Build
Currently, only Windows has been tested.

```bash
# Android
flutter build apk

# iOS
flutter build ios

# Web
flutter build web

# Windows
flutter build windows

# macOS
flutter build macos
```