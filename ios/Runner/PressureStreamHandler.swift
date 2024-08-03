//
//  PressureStreamHandler.swift
//  Runner
//
//  Created by Harish on 8/2/24.
//

import Foundation
import CoreMotion
import Flutter

class PressureStreamHandler: NSObject, FlutterStreamHandler {
    
    let altimeter = CMAltimeter()
    private var eventSink: FlutterEventSink?
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main) {
                [weak self] (data, error) in
                if let error = error {
                    events(FlutterError(code: "UNAVAILABLE", message: "Pressure data unavailable", details: error.localizedDescription))
                    return
                }
                if let pressureData = data?.pressure {
                    let pressureInKPa = pressureData.doubleValue * 10
                    events(pressureInKPa)
                }
            }
        } else {
            return FlutterError(code: "UNAVAILABLE", message: "Barometer not available", details: nil)
        }
        return nil

    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        altimeter.stopRelativeAltitudeUpdates()
        eventSink = nil
        return nil
    }
    
    
}
