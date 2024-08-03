import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Method channel for checking sensor availability
  static const methodChannel = MethodChannel("com.harishkunchala.barometer/method");

  // Event channel for receiving pressure data
  static const pressureStream = EventChannel("com.harishkunchala.barometer/pressure");

  // Variables to hold sensor availability and pressure reading
  String _availability = "Unknown"; // Current status of the sensor
  double? _pressureReading; // Nullable double to represent the current pressure reading
  StreamSubscription? _pressureSubscription; // Subscription for the pressure data stream
  bool _isReading = false; // Flag to indicate if we are currently reading data

  @override
  void initState() {
    super.initState();
    // Check sensor availability when the widget is first created
    getSensorAvailability();
  }

  @override
  void dispose() {
    // Stop reading pressure data when the widget is disposed
    _stopReading();
    super.dispose();
  }

  // Method to check if the barometer sensor is available
  Future<void> getSensorAvailability() async {
    try {
      final available = await methodChannel.invokeMethod("isSensorAvailable");
      setState(() {
        _availability = available.toString(); // Update the availability status
      });
      debugPrint("Sensor Status: $_availability"); // Log the sensor status
    } on PlatformException catch (e) {
      debugPrint("Error checking sensor availability: ${e.message}"); // Log any errors
    }
  }

  // Start reading pressure data from the sensor
   _startReading() {
    debugPrint("Starting to read pressure data"); // Log the start of reading
    _pressureSubscription?.cancel(); // Cancel any existing subscription to avoid duplicates
    _pressureSubscription = pressureStream.receiveBroadcastStream().listen(
          (data) {
        debugPrint("Received pressure data: $data"); // Log received data
        setState(() {
          // Update pressure reading and set reading flag
          _pressureReading = data is double ? data : null; // Ensure data is of type double
          _isReading = true;

          debugPrint("Current Pressure: $_pressureReading");
        });
      },
      onError: (error) {
        debugPrint("Error receiving pressure data: $error"); // Log errors from the stream
        setState(() {
          _isReading = false; // Update reading flag on error
        });
      },
      onDone: () {
        debugPrint("Pressure stream closed"); // Log when the stream is closed
        setState(() {
          _isReading = false; // Update reading flag when stream is done
        });
      },
    );
    setState(() {
      _isReading = true; // Set reading flag to true when starting
    });
  }

  // Stop reading pressure data and reset the reading
  void _stopReading() {
    debugPrint("Stopping pressure reading"); // Log the stop action
    _pressureSubscription?.cancel(); // Cancel the subscription
    setState(() {
      _pressureReading = null; // Set reading to null to indicate no current reading
      _isReading = false; // Update reading flag
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display current sensor availability status
            Text('Sensor Status: $_availability'),
            const SizedBox(height: 20),
            // Button to re-check sensor availability
            ElevatedButton(
              onPressed: getSensorAvailability,
              child: const Text("Get Sensor Status"),
            ),
            const SizedBox(height: 10),
            // Display pressure reading if available, otherwise show "No reading"
            Text("Pressure Reading: ${_pressureReading?.toStringAsFixed(2) ?? 'No reading'}"),
            const SizedBox(height: 10),
            // Button to start reading pressure data if not currently reading
            if (!_isReading)
              ElevatedButton(
                onPressed: _startReading,
                child: const Text("Start Pressure Reading"),
              )
            // Button to stop reading pressure data if currently reading
            else
              ElevatedButton(
                onPressed: _stopReading,
                child: const Text("Stop Pressure Reading"),
              ),
          ],
        ),
      ),
    );
  }
}