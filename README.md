# Kundalify (Cosmic Kundali)

Kundalify is a Flutter app that generates a North Indian style Vedic birth chart (Kundali) from real astrological data fetched from a public Astrology API, then renders the chart using Flutter drawing primitives (`CustomPainter`) - no static images, no WebViews.

## Setup


## Demo

https://github.com/user-attachments/assets/79e10673-0b48-4f3c-b8ae-d1907e706c8b


### Prerequisites
- Flutter SDK installed (latest stable)
- Dart SDK installed

### Install dependencies

```bash
flutter pub get
```

### Run the app

You need **Prokerala API credentials** to run this app. Register for a free trial at [Prokerala API](https://api.prokerala.com/).

Run with your Client ID and Secret:

```bash
flutter run \
  --dart-define=PROKERALA_CLIENT_ID=your_client_id \
  --dart-define=PROKERALA_CLIENT_SECRET=your_client_secret
```

**Note:** The app defaults to Indian Standard Time (UTC+5.5) for simplified input, as requested for the MVP.

### Build APK

```bash
flutter build apk --release --dart-define=PROKERALA_CLIENT_ID=... --dart-define=PROKERALA_CLIENT_SECRET=...
```

The APK will be located at `build/app/outputs/flutter-apk/app-release.apk`.

## API Integration

This project uses the **Prokerala Astrology API v2**.

- **Base URL:** `https://api.prokerala.com/v2`
- **Authentication:** OAuth2 Client Credentials flow (`/token`)

### Endpoints Used

1.  **`GET /astrology/divisional-planet-position`**
    *   **Purpose:** Fetches the divisional chart (Lagna chart) to determine house placements and the Ascendant (Lagna) sign.
    *   **Parameters:** `ayanamsa=1` (Lahiri), `coordinates=lat,lon`, `datetime=ISO8601`, `chart_type=lagna`.
    *   **Response:** JSON containing a list of houses, each with a zodiac sign (`rasi`) and planets positioned in that house.

2.  **`GET /astrology/planet-position`**
    *   **Purpose:** Fetches detailed planetary positions to determine if a planet is **Retrograde** (`is_retrograde: true`).
    *   **Parameters:** Same as above + `planets=0,1...` (Sun to Ketu).
    *   **Response:** JSON list of planets with their current status.

3.  **`GET /v1/search` (Open-Meteo Geocoding)**
    *   **Purpose:** autofill latitude/longitude from city name.
    *   **URL:** `https://geocoding-api.open-meteo.com/v1/search`

## Validation Notes

**Validated against:** https://app.atri.care

**Test Case:**
- **Date:** 04 Feb 2003
- **Time:** 10:00 AM
- **Location:** Ghaziabad, UP (Lat: 28.6654, Lon: 77.4391)

**Conclusion:** The chart rendering is astrologically correct and matches the reference application exactly for the tested input.

## Tech Stack & Architecture

- **Flutter** (Latest Stable)
- **Riverpod** for state management (`NotifierProvider`)
- **HTTP** for API calls
- **CustomPainter** for high-performance, scalable chart rendering
- **Clean Architecture:**
    - `domain/`: Pure Dart models (Entities)
    - `data/`: Repositories, API clients, DTOs
    - `presentation/`: Widgets, Screens, Controllers
    - `application/`: Application logic / use cases

## Folder Structure

```
lib/
├── main.dart                  # Entry point
├── src/
│   ├── app/                   # App wiring (Theme, Routes)
│   ├── core/                  # Shared kernel (Theme, Widgets)
│   └── features/
│       └── kundali/           # Feature module
│           ├── application/   # State management (Controllers)
│           ├── data/          # API integration (Repository)
│           ├── domain/        # Business logic (Models)
│           └── presentation/  # UI (Screens, Painters)
└── test/                      # Unit & Widget tests
```
