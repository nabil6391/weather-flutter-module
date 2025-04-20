# Weather Profile App

A Flutter application with native module integration that demonstrates Flutter-native code integration, API fetching, and cross-platform communication.

## Project Overview

This app consists of two main tabs:
1. **Dashboard Tab (Flutter)** - Displays weather data from OpenWeatherMap API and shows user profile data received from the native module
2. **Profile Tab (Native)** - Displays a user profile using native code (SwiftUI for iOS / Jetpack Compose for Android)

## Project Structure

```
lib/
├── common/
│   ├── network/          # Network related code (DioClient)
│   ├── router/           # GoRouter configuration
│   ├── services/         # Cross-platform services
│   └── utils/            # Constants and utility functions
├── features/
│   ├── app_shell/        # Bottom navigation and app shell
│   ├── dashboard/        # Weather display and user profile card
│   │   ├── data/         # Data models for weather
│   │   ├── domain/       # State management
│   │   └── presentation/ # UI screens
│   └── user_profile/     # User profile from native
│       ├── data/       # Data models for user profile
│       ├── domain/    # State management
│       └── presentation/ # Native view integration
└── main.dart             # App entry point
```

## Native Module Integration

### iOS (SwiftUI)
- Uses `FlutterPlatformView` to embed SwiftUI into Flutter
- Implemented in `ProfileView.swift`
- Profile data is sent to Flutter via MethodChannel when user taps "Send Profile to Dashboard" button

### Android (Jetpack Compose)
- Uses `PlatformView` to embed Jetpack Compose into Flutter
- Implemented in `ProfileViewFactory.kt`
- Profile data is sent to Flutter via MethodChannel when user taps "Send Profile to Dashboard" button


## Data Flow

1. **Weather Data Flow**
    - Flutter initiates API request through WeatherService
    - DioClient makes the HTTP request to OpenWeatherMap API
    - Response is parsed into Weather model
    - WeatherProvider updates state and notifies listeners
    - UI reflects the received weather data

2. **User Profile Data Flow**
    - User taps "Send Profile to Dashboard" button in the native Profile tab
    - Native code (iOS/Android) sends user profile data via MethodChannel
    - Flutter MethodChannelService receives the data
    - Data is converted to UserProfile model
    - UserProvider updates its state with the profile data
    - Dashboard displays the user profile data in the UserProfileCard

3. **Feedback Flow**
    - User enters feedback text in the Dashboard tab
    - Feedback is sent to native code via MethodChannel
    - Native code shows an alert dialog with the feedback message

## Technical Implementation Details

### State Management
- Provider pattern with ChangeNotifier for reactive state updates
- Separate providers for weather data and user profile

### Navigation
- GoRouter for declarative routing
- Bottom navigation using AppShell pattern

### API Integration
- Dio HTTP client for API requests
- Clean separation of API services and business logic

### Cross-Platform Communication
- MethodChannel for bidirectional communication between Flutter and native code
- PlatformView for embedding native UI components in Flutter

## Assumptions and Decisions

1. **UI Design**: Kept the UI simple and focused on demonstrating the integration aspects rather than complex design
2. **Error Handling**: Implemented comprehensive error handling for API requests and platform communication
3. **Mock Data**: Used hardcoded user profile data in native code as specified in requirements
4. **User Experience**: Added loading indicators and feedback for better user experience
5. **PlatformView Approach**: Used PlatformView instead of Activities/ViewControllers for smoother integration
6. **Communication Mechanism**: User-triggered data passing (via button) for clearer demonstration of the communication flow

## Getting Started

1. Replace the API key in `lib/common/utils/constants.dart` with your own OpenWeatherMap API key
2. Run the app on iOS or Android:
   ```
   flutter run
   ```

## Requirements Fulfillment

- ✅ Integrated Flutter and native code (iOS/Android) in a single app
- ✅ Fetched weather data from an API (OpenWeatherMap)
- ✅ Implemented Flutter-native communication in both directions
- ✅ Created a bottom navigation bar with two tabs
- ✅ Displayed city name, temperature, and weather conditions
- ✅ Created native profile UI with SwiftUI and Jetpack Compose
- ✅ Sent user data from native to Flutter via MethodChannel
- ✅ Added bonus feature: sending feedback from Flutter to native
