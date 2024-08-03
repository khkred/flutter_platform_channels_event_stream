# Flutter Platform Channels Event Stream

This Flutter project demonstrates how to use platform channels to stream pressure data from both Android and iOS devices. It also includes the necessary permission configuration for iOS in the info.plist file.

## Features

- Stream pressure data from Android and iOS devices
- Real-time updates using platform channels
- iOS permission configuration for sensor access

## Getting Started

### Prerequisites

- Flutter SDK
- Xcode (for iOS development)
- Android Studio (for Android development)

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/khkred/flutter_platform_channels_event_stream.git
   ```

2. Navigate to the project directory:
   ```
   cd flutter_platform_channels_event_stream
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

## Usage

1. Run the app on your desired device or emulator:
   ```
   flutter run
   ```

2. The app will display real-time pressure data streamed from the device sensors.

## iOS Configuration

The `info.plist` file includes the necessary permission request for accessing sensor data on iOS devices. Make sure to review and adjust the permissions if needed.

## Android Configuration

No additional configuration is required for Android devices.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the [MIT License](LICENSE).

## Acknowledgements

- Flutter team for providing platform channels functionality
