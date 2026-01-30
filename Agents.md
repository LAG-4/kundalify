# AGENTS.md

Guidance for agentic coding tools working in this repository.
Follow existing patterns unless the task explicitly changes conventions.

## Repo snapshot
- Flutter app at repo root (`pubspec.yaml`, `lib/`, `test/`)
- Dart SDK: `^3.10.1` (see `pubspec.yaml`)
- State management: Riverpod (`flutter_riverpod`)
- Theme + UI primitives: `lib/src/core/theme/`, `lib/src/core/widgets/`
- Entry point: `lib/main.dart` -> `ProviderScope` -> `KundalifyApp`
- Test example: `test/widget_test.dart` (welcome -> loading flow)
- Optional/legacy: `website/` (Vite + React + TypeScript) exists in git history; may be absent locally

## Commands (Flutter)

### Setup
flutter pub get
flutter --version
dart --version

### Run
flutter devices
flutter run
flutter run -d <deviceId>

# Pass runtime config (recommended for API keys)
flutter run --dart-define=ASTRO_API_KEY=...
flutter run --dart-define=ASTRO_API_BASE_URL=...

### Format
# Preferred formatter
dart format .

# Or limit scope
dart format lib test

### Lint / static analysis
flutter analyze

### Tests
# All tests
flutter test

# Single test file
flutter test test/widget_test.dart

# Single test by name (substring match)
flutter test test/widget_test.dart --plain-name "welcome -> loading flow"

# Expanded reporter output
flutter test -r expanded

# Coverage
flutter test --coverage

### Build
# Android APK (release by default)
flutter build apk
flutter build apk --debug
flutter build apk --profile
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# Web
flutter build web --release

### Clean
flutter clean
flutter pub get

## Commands (website/ - optional Vite React app)

# Install deps
npm --prefix website install
# or: cd website && npm install

# Run dev server (per Vite config it uses port 3000)
npm --prefix website run dev

# Build + preview
npm --prefix website run build
npm --prefix website run preview

# Tests/lint: none configured in `website/package.json` (add ESLint/Prettier if needed)

## Code organization (Flutter)
- Keep app wiring minimal in `lib/main.dart` and `lib/src/app/kundalify_app.dart`.
- Use feature-first layout under `lib/src/features/<feature>/`:
  - `presentation/` for widgets/screens.
  - `application/` for Riverpod controllers/notifiers.
  - Add `domain/` for pure models/use-cases (no Flutter imports).
  - Add `data/` for API clients, DTOs, repositories, mappers.
- Shared UI building blocks go in `lib/src/core/widgets/`.
- Theme/tokens stay in `lib/src/core/theme/` (`AppColors`, `AppTheme`).

## Imports (Flutter)
- Group order:
  - `dart:` imports
  - third-party `package:` imports
  - local imports
- One blank line between groups.
- Current convention in `lib/`: relative imports between `lib/src/...` files.
- Tests may use `package:kundalify/...` imports for clarity.
- Use namespace aliases for common libs (e.g. `import 'dart:math' as math;`).

## Formatting (Flutter)
- Run `dart format` on any changed Dart code.
- Prefer `const` widgets/constructors and `final` locals.
- Use trailing commas in multi-line widget trees and argument lists.
- Prefer typed collection literals where it helps readability (`const <Widget>[]`, `<Color>[]`).
- Keep `build()` readable; extract private widgets (`_Foo`) or helpers when a widget grows.

## Naming conventions (Flutter)
- Files: `snake_case.dart`
- Types/widgets: `PascalCase`
- Members/locals: `lowerCamelCase`
- Private symbols: leading `_`
- Providers: `...Provider` suffix (example: `onboardingControllerProvider`)
- Notifiers/controllers: `...Controller` suffix when they own state transitions
- Screens: `...Screen` for full pages; `...View` for reusable UI blocks

## Riverpod conventions
- UI reads state with `ref.watch(...)`.
- UI triggers transitions in callbacks with `ref.read(provider.notifier).method()`.
- Keep side-effects out of `build()`; use controllers/notifiers or widget lifecycle.
- For API calls, prefer `AsyncNotifier` / `FutureProvider` and model loading/error states explicitly.
- Do not store `BuildContext` in providers/controllers.

## Types and modeling
- Avoid `dynamic` and `Map<String, dynamic>` beyond the API boundary.
- Create explicit DTOs for API responses; map to app/domain models.
- Validate required fields when parsing; surface parse errors as typed failures.
- Keep models immutable; prefer `const` where practical.

## Error handling and UX
- Treat network/API as fallible; never assume success.
- Catch exceptions in the data layer, map to typed failures, and return structured results.
- UI must handle: loading, error, empty, success (no silent failures).
- Prefer actionable user-facing errors; avoid raw stack traces in UI.
- Use `debugPrint` for diagnostics; avoid `print`.

## CustomPainter / rendering rules (Kundali)
- Kundali chart must be drawn using Flutter primitives (prefer `CustomPainter`).
- Do NOT render the kundali using static images, downloaded SVGs, or WebViews.
- Painter should:
  - scale to available size (avoid hard-coded pixels)
  - implement `shouldRepaint` correctly
  - keep text readable (minimum font sizes, handle overflow)

## Kundali assignment constraints (product requirements)
- Use a real public Astrology API (no hardcoded responses).
- Prefer North Indian style chart.
- Chart must display:
  - 12 houses
  - zodiac signs per house
  - planet abbreviations: Su, Mo, Ma, Me, Ju, Ve, Sa, Ra, Ke
- Validate output vs https://app.atri.care for at least one sample input and record notes in `README.md`.

## Secrets and local config
- Never commit API keys or credentials.
- Prefer `--dart-define` for secrets; read via `String.fromEnvironment(...)`.
- `android/local.properties` is machine-local and ignored (SDK paths).
- Generated folders like `.dart_tool/` and `build/` should remain untracked.

## Cursor / Copilot instructions
- No Cursor rules found at `.cursorrules` or `.cursor/rules/`.
- No Copilot instructions found at `.github/copilot-instructions.md`.
