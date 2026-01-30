# Kundalify (Cosmic Kundali)

Kundalify is a Flutter app that generates a North Indian style Vedic birth chart (Kundali) from real astrological data fetched from a public Astrology API, then renders the chart using Flutter drawing primitives (no static images).

This repository is based on the "Flutter Developer Intern – Assignment" brief (see `Flutter Developer Intern Assignment.pdf`).

## Current state (what’s in the repo today)
- App shell + onboarding UI is implemented:
  - Welcome screen with animations
  - Loading screen with animated painters
- State management uses Riverpod (`flutter_riverpod`).
- The input form, real API integration, and kundali chart rendering screen are expected next (per assignment).

## App overview (target flow)
1. Welcome
2. Birth details input (DOB, TOB, latitude, longitude)
3. Fetch kundali / planetary position data from an Astrology API
4. Render a North Indian kundali chart via a custom Flutter widget (`CustomPainter`)
5. Validate placements against https://app.atri.care

## Assignment requirements (full, README-ready)
### Objective
Build a custom Flutter UI component that renders an Astrological Kundali (North Indian style preferred) using real astrological data fetched from a public Astrology API.

This task evaluates:
- Flutter UI and custom painting skills
- API integration and data handling
- Attention to detail and validation
- Code quality and documentation

### Functional requirements
1) User input screen
- Date of Birth (DD/MM/YYYY)
- Time of Birth (HH:MM, 24-hour format)
- Latitude (decimal)
- Longitude (decimal)
- Basic validation (empty fields, valid ranges, etc.)

2) Astrology API integration
- Create a free trial account on a public Astrology API (examples: AstrologyAPI, Prokerala, etc.)
- Fetch kundali/chart/planetary position data using the user inputs
- Document:
  - API used
  - Endpoint name
  - Request and response structure
- IMPORTANT: Do not hardcode responses. API integration must be real.

3) Kundali UI component
- Implement a custom Flutter widget to render the kundali
- Use `CustomPainter` or equivalent
- Display:
  - 12 houses
  - zodiac signs per house
  - planet abbreviations inside houses (Su, Mo, Ma, Me, Ju, Ve, Sa, Ra, Ke)
- Do not use images, downloaded SVGs, or WebViews

4) Validation requirement (very important)
- Validate the generated kundali against https://app.atri.care using the same birth details:
  - Cross-check house placements
  - Planet positions
  - Zodiac signs
- Add a short note in this README:
  - Which birth details were validated with
  - Whether output matched exactly or had differences

### Technical requirements
- Flutter (latest stable)
- Clean folder structure
- Reusable widgets
- Proper naming conventions
- No crashes on invalid input

Bonus (optional):
- Light animations
- Dark mode support
- Responsive layout

### Submission requirements
- APK file (debug or release)
- Screen recording showing:
  - inputting birth details
  - API call
  - kundali rendering
- GitHub repository (public) with:
  - complete source code
  - proper commit history
- README.md containing:
  - setup instructions
  - API used
  - screenshots
  - validation notes vs app.atri.care

### Evaluation criteria
- Accuracy of kundali rendering
- Quality of custom UI implementation
- Code readability and structure
- Correct API usage
- Validation effort and honesty

## Tech stack
- Flutter + Dart
- Riverpod (`flutter_riverpod`)
- Custom UI/painters for animations and (eventually) the kundali chart
- `google_fonts` for typography
- `flutter_svg` for local icon assets (not for kundali rendering)

## Getting started (Flutter)
Prerequisites:
- Flutter SDK installed and on PATH
- Android Studio / Xcode (platform dependent)

Commands:
- Install deps: `flutter pub get`
- Run: `flutter run`
- Analyze: `flutter analyze`
- Format: `dart format .`
- Test: `flutter test`
- Single test: `flutter test test/widget_test.dart`
- Single test by name: `flutter test test/widget_test.dart --plain-name "welcome -> loading flow"`

Build APK:
- Release APK: `flutter build apk --release`

## API configuration (recommended approach)
Do not commit API keys.
Recommended: pass secrets via `--dart-define`:
- `flutter run --dart-define=ASTRO_API_KEY=... --dart-define=ASTRO_API_BASE_URL=...`

(When implemented) document here:
- Provider:
- Endpoint:
- Request example:
- Response example (redacted as needed):

## Validation notes vs app.atri.care (fill in once implemented)
Validated with:
- Date of Birth:
- Time of Birth:
- Latitude:
- Longitude:

Result:
- Match status:
- Differences (if any):

## Project structure
- `lib/main.dart`: app entry + ProviderScope
- `lib/src/app/`: app wiring (theme, routing)
- `lib/src/core/`: shared widgets and theme
- `lib/src/features/`: feature modules (presentation + application layers)
- `test/`: widget/unit tests

## Optional: website/ prototype (if present)
This repo also contains (or previously contained) a Vite + React + TypeScript prototype under `website/`.

Commands:
- `npm --prefix website install`
- `npm --prefix website run dev`
- `npm --prefix website run build`
- `npm --prefix website run preview`

Note: website env/key handling and any mock kundali logic should not be used as the final submission for the Flutter assignment.

