# Countries App

A Flutter app to explore countries around the world. Browse, search, and save your favorite countries.

## Quick Start


flutter pub get


flutter run





**State Management:** BLoC pattern for predictable state handling and easier testing.

**Architecture:** Clean architecture with separate layers for UI, business logic, and data. Keeps things organized and maintainable.

**Dependency Injection:** Using `get_it` to manage dependencies without tight coupling.

**Routing:** `go_router` for type-safe navigation and deep linking.

**Data Models:** `freezed` generates immutable models with less boilerplate.

**Caching:** HTTP caching with `dio_cache_interceptor` and Hive for offline support.

**Local Storage:** `SharedPreferences` for saving your favorite countries.

## Features

- Browse all countries with search
- View detailed country information
- Save favorites 
- Works offline with cached data
- Dark theme support
- Responsive design for tablets
- Pull-to-refresh
- Smooth animations
