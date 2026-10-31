# Echo Flutter

Echo is a Flutter client for finding nearby service providers and contacting
them through an AI voice agent.

## Features

- Captures a service request with speech recognition.
- Uses the device location to search for nearby providers.
- Lets the user select one or more providers.
- Sends the request to the Echo backend, which starts AI-assisted calls.
- Tracks each call through a WebSocket connection.
- Displays the final call status, extracted date, time, price, summary,
  transcript, and recording link when available.

## Application flow

1. **Home** - grant location and microphone access, then record a request.
2. **Vendor selection** - review nearby providers and select providers to call.
3. **Calling service** - monitor live call statuses and review completed-call
   information.

The app uses GetX for routing, dependency injection, and reactive state.

## Requirements

- Flutter with Dart SDK `^3.11.1`
- Android Studio or Xcode for the target platform
- A configured Echo backend
- A physical device or emulator with location and microphone support

## Setup

```bash
flutter pub get
flutter devices
flutter run
```

For a release build:

```bash
flutter build apk
# or
flutter build ios
```

Run static analysis and tests with:

```bash
flutter analyze
flutter test
```

## Backend configuration

The app currently uses:

```text
https://echo-backend-q97a.onrender.com
```

This value is defined in
[`lib/app/constants/backend_url.dart`](lib/app/constants/backend_url.dart).
The client uses these backend routes:

| Purpose | Method | Route |
| --- | --- | --- |
| Find nearby providers | `GET` | `/places/search` |
| Resolve service request | `GET` | `/llm/response` |
| Start an agent call | `POST` | `/bolna_agent/call` |
| Receive call updates | WebSocket | `/websocket/{execution_id}` |

If the backend changes, update the URL in
`lib/app/constants/backend_url.dart` and use `wss://` for the WebSocket
connection in production.

## Platform permissions

The Android app declares internet, fine/coarse location, and microphone
permissions in
[`android/app/src/main/AndroidManifest.xml`](android/app/src/main/AndroidManifest.xml).
The iOS app includes microphone usage text in
[`ios/Runner/Info.plist`](ios/Runner/Info.plist). Location and microphone
permissions must still be granted by the user at runtime.

## Project structure

```text
lib/
├── main.dart
└── app/
    ├── constants/       # Backend URL, agent ID, and colors
    ├── modules/
    │   ├── home/        # Speech input and location-based search
    │   ├── vendor/      # Provider selection and call initiation
    │   └── calling_service/ # WebSocket status and call results
    └── routes/          # GetX routes and bindings
assets/                  # Bundled application assets
```

## Current implementation notes

- The agent ID is currently stored in
  `lib/app/constants/agent_ids.dart`.
- Provider phone numbers used when initiating calls are currently demo
  numbers in `VendorController`; replace them with provider data before
  production use.
- The backend must be running and reachable for provider search, LLM
  resolution, call initiation, and WebSocket updates.
