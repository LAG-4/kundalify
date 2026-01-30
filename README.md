# Kundalify (Cosmic Kundali)

Kundalify is a Flutter app that generates a North Indian style Vedic birth chart (Kundali) from real astrological data fetched from a public Astrology API, then renders the chart using Flutter drawing primitives (`CustomPainter`) - no static images, no WebViews.

Flow:

[Welcome]
  -> (Tap "Get Started")
[Input]
  -> (Enter birth details + Tap "Generate")
[Loading]
  -> (API call success)
[Kundali Display] <-> [Share/Save]
  -> (Tap "Generate Another")
[Input]

If the API call fails:

[Error]
  -> (Tap "Try Again" or "Edit Details")

## Tech stack
- Flutter + Dart
- Riverpod (`flutter_riverpod`)
- `http` for API calls
- `share_plus` + `path_provider` for Share/Save

## Setup

Prerequisites:
- Flutter SDK installed and on PATH

Install dependencies:

flutter pub get

Run:

flutter run

Format:

dart format .

Analyze:

flutter analyze

Test:

flutter test

Run a single test:

flutter test test/widget_test.dart --plain-name "welcome -> input flow"

## API configuration

This project is wired for the Prokerala Astrology API (OAuth2 client-credentials).
Provider:
- Base URL: `https://api.prokerala.com/v2`
- Token URL: `https://api.prokerala.com/token`
- Endpoints used:
  - `GET /astrology/divisional-planet-position` (houses + planet house placements)
  - `GET /astrology/planet-position` (retrograde + ascendant sign)

You must provide your own credentials via `--dart-define` (do not commit keys):

flutter run \
  --dart-define=PROKERALA_CLIENT_ID=... \
  --dart-define=PROKERALA_CLIENT_SECRET=...

Optional overrides:

flutter run \
  --dart-define=PROKERALA_CLIENT_ID=... \
  --dart-define=PROKERALA_CLIENT_SECRET=... \
  --dart-define=PROKERALA_BASE_URL=https://api.prokerala.com/v2 \
  --dart-define=PROKERALA_TOKEN_URL=https://api.prokerala.com/token \
  --dart-define=PROKERALA_AYANAMSA=1 \
  --dart-define=PROKERALA_LANG=en \
  --dart-define=PROKERALA_CHART_TYPE=lagna

Notes:
- If keys are missing, the app shows an Error screen explaining what to pass.
- Prokerala expects `coordinates=lat,lon` and `datetime=YYYY-MM-DDTHH:MM:SS+HH:MM` (the "+" is URL-encoded automatically by Dart `Uri`).
- Prokerala explicitly recommends calling their API from a backend for native/mobile apps (to avoid shipping your client secret). For this assignment, keys are provided at runtime via `--dart-define` and must never be committed.

## Rendering (North Indian Kundali)

The kundali chart is rendered via `CustomPainter`:
- 12 houses (North Indian layout)
- zodiac sign label per house
- planet abbreviations inside houses: Su, Mo, Ma, Me, Ju, Ve, Sa, Ra, Ke

## Validation notes vs app.atri.care (fill in)

Validated with:
- Date of Birth:
- Time of Birth:
- Latitude:
- Longitude:

Result:
- Match status:
- Differences (if any):

## Folder structure
- `lib/main.dart`: app entry
- `lib/src/app/`: app wiring
- `lib/src/core/`: theme + shared widgets
- `lib/src/features/kundali/`: kundali flow, API integration, chart renderer
- `test/`: Flutter tests

## Flutter Developer Intern - Assignment (full transcription)

### Objective

Build a custom Flutter UI component that renders an Astrological Kundali (North Indian style preferred) using real astrological data fetched from a public Astrology API.

This task is designed to evaluate:

- Flutter UI and custom painting skills
- API integration and data handling
- Attention to detail and validation
- Code quality and documentation

### Task Overview

You will build a Flutter app that:

1. Takes birth details as user input
2. Fetches kundali data from an Astrology API
3. Plots a visual kundali chart using a custom Flutter component (no static images)
4. Validates the output against app.atri.care

### Functional Requirements

#### 1. User Input Screen

Create a screen to collect the following inputs:

- Date of Birth (DD/MM/YYYY)
- Time of Birth (HH:MM, 24-hour format)
- Latitude (decimal)
- Longitude (decimal)

Basic validation is expected (empty fields, valid ranges, etc.).

#### 2. Astrology API Integration

- Create a free trial account on any public Astrology API (example: AstrologyAPI, Prokerala, etc.)
- Fetch kundali / chart / planetary position data using the user inputs
- Clearly document:
  - API used
  - Endpoint name
  - Request and response structure

IMPORTANT: Do NOT hardcode responses. API integration must be real.

#### 3. Kundali UI Component

You must implement a custom Flutter widget to render the kundali.

UI Expectations:

- Draw the kundali using `CustomPainter` or equivalent
- Display:
  - 12 houses
  - Zodiac signs per house
  - Planet abbreviations inside houses (e.g. Su, Mo, Ma, Me, Ju, Ve, Sa, Ra, Ke)
- Layout should be clean, readable, and scalable

Do NOT use images, SVG downloads, or webviews.

#### 4. Validation Requirement (Very Important)

You must validate your output kundali with:

https://app.atri.care

For the same birth details:

- Cross-check house placements
- Planet positions
- Zodiac signs

Add a short note in `README`:

- Which birth details you validated with
- Whether the output matched exactly or had differences

### Technical Requirements

- Flutter (latest stable)
- Clean folder structure
- Reusable widgets
- Proper naming conventions
- No crashes on invalid input

Bonus (optional):

- Light animations
- Dark mode support
- Responsive layout

### Submission Requirements

You must submit all of the following:

1. APK file (debug or release)
2. Screen recording showing:
   - Inputting birth details
   - API call
   - Kundali rendering
3. GitHub repository (public)
   - Complete source code
   - Proper commit history
4. `README.md` containing:
   - Setup instructions
   - API used
   - Screenshots
   - Validation notes vs app.atri.care

### Evaluation Criteria

- Accuracy of kundali rendering
- Quality of custom UI implementation
- Code readability and structure
- Correct API usage
- Validation effort and honesty

### Final Notes

This assignment mirrors real production work at Atri. We care deeply about:

- UI precision
- Astrological correctness
- Engineering discipline
