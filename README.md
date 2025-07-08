# MIUN Live - Video Streaming App

A Flutter application for live video streaming using VideoSDK with enhanced camera and audio controls.

## Features

### ✨ New Enhanced Features

- **Default Audio/Video Off**: Camera and microphone are disabled by default when joining meetings for privacy
- **Camera Switching**: Toggle between front and rear cameras seamlessly
- **Flash Control**: Enable/disable camera flash when using rear camera (placeholder implementation)
- **Clean Architecture**: Improved code structure with service layers and state management
- **Enhanced UI**: Modern, responsive design with better visual feedback

### 🎥 Core Functionality

- **Live Feed Search**: Search and join active live video feeds
- **Real-time Video Streaming**: High-quality video streaming using VideoSDK
- **Audio Controls**: Mute/unmute microphone during calls
- **Video Controls**: Enable/disable camera with visual indicators
- **Room Monitoring**: Automatic disconnection when live feed ends
- **Permission Handling**: Proper camera and microphone permission requests

## Architecture

The app follows a clean architecture pattern with:

- **Models**: Data models for meeting state management
- **Services**: Business logic for VideoSDK, permissions, and flash control
- **Widgets**: Reusable UI components for meeting controls and participant tiles
- **Pages**: Screen-level components for navigation and user interaction

## Key Components

### Services
- `MeetingService`: Handles VideoSDK operations (room creation, camera switching, etc.)
- `PermissionService`: Manages camera and microphone permissions
- `FlashService`: Controls camera flash functionality (placeholder for platform implementation)

### Enhanced UI Components
- `EnhancedMeetingControls`: Modern control panel with camera switching and flash controls
- `EnhancedParticipantTile`: Improved video tile with participant information and status
- `EnhancedMeetingScreen`: Main meeting interface with clean state management

## Installation & Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd miun_live
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment**
   - Create a `.env` file in the root directory
   - Add your VideoSDK token:
     ```
     main_token=your_videosdk_token_here
     ```

4. **Run the app**
   ```bash
   flutter run
   ```

## Configuration

### Android Permissions
The app requires the following permissions (already configured in `AndroidManifest.xml`):
- `CAMERA`
- `RECORD_AUDIO`
- `INTERNET`
- `ACCESS_NETWORK_STATE`
- `MODIFY_AUDIO_SETTINGS`

### iOS Permissions
Configured in `Info.plist`:
- `NSCameraUsageDescription`
- `NSMicrophoneUsageDescription`

## Usage

1. **Start the app** - The app launches to the search screen
2. **Search for feeds** - Tap "Search Active Feeds" to find available live streams
3. **Join a feed** - When a feed is found, tap "Join Feed"
4. **Control your media**:
   - 🎤 Toggle microphone on/off
   - 📹 Toggle camera on/off
   - 🔄 Switch between front/rear camera
   - 💡 Toggle flash (rear camera only)
   - ❌ Leave the meeting

## Technical Details

### State Management
The app uses a custom `MeetingState` model for managing:
- Audio/video enabled states
- Camera orientation (front/rear)
- Flash status
- Loading and error states
- Participant information

### Default Behavior
- **Camera**: Disabled by default
- **Microphone**: Disabled by default
- **Initial Camera**: Front camera
- **Flash**: Disabled by default

### Error Handling
- Graceful permission handling with user feedback
- Automatic retry mechanisms for connection issues
- Proper cleanup on app disposal

## Known Limitations

1. **Flash Control**: The flash functionality is currently a placeholder implementation. For full functionality, platform-specific code would need to be added using method channels.

2. **Camera Detection**: Camera switching relies on device label detection, which may vary across devices.

## Future Enhancements

- [ ] Implement native flash control for Android/iOS
- [ ] Add recording functionality
- [ ] Screen sharing capabilities
- [ ] Chat functionality
- [ ] Multiple camera support
- [ ] Background blur/effects

## Dependencies

- `videosdk: ^2.2.0` - Core video SDK
- `flutter_screenutil: ^5.9.3` - Responsive design
- `cloud_firestore: ^5.6.7` - Firebase integration
- `permission_handler: ^12.0.0+1` - Permission management
- `flutter_dotenv: ^5.2.1` - Environment configuration

## License

This project is part of a graduation project and is intended for educational purposes.

---

## Development Notes

### Recent Improvements

1. **Architecture Refactoring**: Separated concerns into service layers
2. **UI Enhancement**: Modern, responsive design with better visual feedback
3. **Permission Handling**: Improved user experience with proper permission requests
4. **State Management**: Clean state management with immutable models
5. **Error Handling**: Better error handling and user feedback

### Bug Fixes

1. **Default Media State**: Fixed issue where camera/mic were enabled by default
2. **Participant Handling**: Improved local participant detection and management
3. **Navigation**: Fixed navigation issues and proper cleanup
4. **Permission Flow**: Streamlined permission request flow

The app now provides a much better user experience with proper privacy controls and modern UI patterns.
