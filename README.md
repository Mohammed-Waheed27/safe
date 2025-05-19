# Ru'yaAI - AI-Powered Crowd Counting and Analysis

A Flutter mobile app for advanced crowd counting and analysis using AI technology.

## Overview

Ru'yaAI is a powerful mobile application designed to provide real-time crowd counting, monitoring, and analysis using advanced AI technology. The app is built with Flutter and follows a clean architecture approach with a feature-first organization.

## Mobile-First Design

The application is designed with a mobile-first approach, ensuring optimal user experience on smartphone screens while still being responsive to larger displays:

- Responsive layouts that adapt to different screen sizes
- Bottom navigation for primary navigation on mobile 
- Modal sheets for additional options instead of side panels
- Touch-friendly UI elements with appropriate sizing
- Vertically stacked components for narrow screens

## Features

1. **Authentication** - Secure login and account creation
2. **Dashboard** - Overview of key metrics and quick access to main features
3. **Live Monitoring** - Real-time crowd counting from connected cameras
4. **Analysis** - Upload and analyze images or videos with AI
5. **Results** - View and manage analysis history
6. **Analytics** - Detailed insights, trends, and statistics
7. **Alerts** - Notification management for threshold events
8. **Zones** - Configure monitoring areas with specific thresholds
9. **Settings** - App configuration and account management

## Tech Stack

- **Flutter** - Cross-platform UI framework
- **Bloc** - State management
- **ScreenUtil** - Responsive UI scaling
- **Hive** - Local storage
- **FL Chart** - Data visualization

## Architecture

The project follows Clean Architecture principles with three main layers:

1. **Presentation Layer** - UI components and state management
2. **Domain Layer** - Business logic and use cases
3. **Data Layer** - Data sources and repositories

## Directory Structure

The project is organized with a feature-first approach:

```
lib/
├── core/                 # Core functionality
│   ├── config/           # App configuration
│   ├── di/               # Dependency injection
│   ├── util/             # Utilities
│
├── features/             # App features
│   ├── auth/             # Authentication
│   ├── dashboard/        # Dashboard
│   ├── live/             # Live monitoring
│   ├── analysis/         # Analysis
│   ├── results/          # Results
│   ├── analytics/        # Analytics
│   ├── alerts/           # Alerts
│   ├── zones/            # Zones
│   └── settings/         # Settings
│
└── main.dart             # App entry point
```

## Getting Started

1. Clone the repository
2. Install dependencies: `flutter pub get`
3. Run the app: `flutter run`

## Screenshots

The app includes various screens:

- Login/Registration screens
- Dashboard with key metrics
- Live monitoring view of connected cameras
- Analysis page for image/video upload
- Results page showing analysis history
- Analytics page with statistics and trends
- Alerts management page
- Zone configuration page
- Settings page

## Backend Integration

The app is designed to work with Firebase, but the backend integration is currently stubbed with mock data. To connect with your backend:

1. Update the data sources in the data layer
2. Configure Firebase or your preferred backend service
3. Update the API endpoints and models as needed

## Contributing

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
