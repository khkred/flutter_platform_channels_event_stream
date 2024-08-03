import Flutter
import UIKit
import CoreMotion

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    let METHOD_CHANNEL_NAME = "com.harishkunchala.barometer/method"
    let PRESSURE_STREAM_NAME = "com.harishkunchala.barometer/pressure"
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        setupChannels()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func setupChannels() {
        guard let controller = window?.rootViewController as? FlutterViewController else {
            fatalError("rootViewController is not type FlutterViewController")
        }
        
        // Method Channel
        let methodChannel = FlutterMethodChannel(name: METHOD_CHANNEL_NAME, binaryMessenger: controller.binaryMessenger)
        methodChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            guard call.method == "isSensorAvailable" else {
                result(FlutterMethodNotImplemented)
                return
            }
            result(CMAltimeter.isRelativeAltitudeAvailable())
        })
        
        // Event Channel
        let pressureStreamHandler = PressureStreamHandler()
        let pressureChannel = FlutterEventChannel(name: PRESSURE_STREAM_NAME, binaryMessenger: controller.binaryMessenger)
        pressureChannel.setStreamHandler(pressureStreamHandler)
    }
}
