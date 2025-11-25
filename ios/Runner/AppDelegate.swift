import Flutter
import UIKit
import LocalAuthentication

@main
@objc class AppDelegate: FlutterAppDelegate {
    // Define the channel name (must match the Dart side)
    private let CHANNEL = "system_info"
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Get the FlutterViewController
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        
        // Set up the MethodChannel
        let methodChannel = FlutterMethodChannel(
            name: CHANNEL,
            binaryMessenger: controller.binaryMessenger
        )
        
        methodChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard let self = self else { return }
            
            switch call.method {
            case "getSystemVersion":
                let version = self.getSystemVersion()
                result(version)
                
            case "getBatteryLevel":
                let batteryLevel = self.getBatteryLevel()
                if batteryLevel >= 0 {
                    result(batteryLevel)
                } else {
                    result(FlutterError(
                        code: "UNAVAILABLE",
                        message: "Battery level not available.",
                        details: nil
                    ))
                }
                
            case "processData":
                // Example of receiving arguments from Dart
                if let args = call.arguments as? [String: Any],
                   let inputData = args["inputData"] as? String,
                   let timestamp = args["timestamp"] as? Int64 {
                    
                    let processedData = "Processed: \(inputData) at \(timestamp)"
                    result(processedData)
                } else {
                    result(FlutterError(
                        code: "INVALID_ARGUMENT",
                        message: "Invalid arguments",
                        details: nil
                    ))
                }
                
            case "sendHelloWorld":
                // Receive Hello World from Flutter
                if let args = call.arguments as? [String: Any],
                   let message = args["message"] as? String,
                   let fromFlutter = args["fromFlutter"] as? Bool {
                    
                    // Process and send response back to Flutter
                    let response = fromFlutter 
                        ? "iOS says: Received '\(message)' from Flutter!"
                        : "iOS says: Hello!"
                    
                    result(response)
                } else {
                    result(FlutterError(
                        code: "INVALID_ARGUMENT",
                        message: "Invalid arguments for sendHelloWorld",
                        details: nil
                    ))
                }
                
            case "isBiometricAvailable":
                let isAvailable = self.isBiometricAvailable()
                result(isAvailable)
                
            case "authenticateWithBiometric":
                if let args = call.arguments as? [String: Any],
                   let reason = args["reason"] as? String {
                    self.authenticateWithBiometric(reason: reason, result: result)
                } else {
                    self.authenticateWithBiometric(reason: "Authenticate to continue", result: result)
                }
                
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    /**
     * Get the iOS system version
     * Returns a string like "iOS 18.0"
     */
    private func getSystemVersion() -> String {
        let osVersion = UIDevice.current.systemVersion
        let osName = UIDevice.current.systemName
        let deviceModel = UIDevice.current.model
        return "\(osName) \(osVersion) (\(deviceModel))"
    }
    
    /**
     * Get the current battery level
     * Returns battery percentage (0-100) or -1 if unavailable
     */
    private func getBatteryLevel() -> Int {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        
        if device.batteryState == .unknown {
            return -1
        } else {
            let batteryLevel = Int(device.batteryLevel * 100)
            return batteryLevel
        }
    }
    
    /**
     * Check if biometric authentication is available
     */
    private func isBiometricAvailable() -> Bool {
        let context = LAContext()
        var error: NSError?
        
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
    
    /**
     * Authenticate using biometric (Face ID / Touch ID)
     */
    private func authenticateWithBiometric(reason: String, result: @escaping FlutterResult) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        result([
                            "success": true,
                            "message": "Authentication successful! 🎉"
                        ])
                    } else {
                        let errorMessage = authenticationError?.localizedDescription ?? "Authentication failed"
                        result([
                            "success": false,
                            "message": "Authentication error: \(errorMessage)"
                        ])
                    }
                }
            }
        } else {
            let errorMessage = error?.localizedDescription ?? "Biometric authentication not available"
            result([
                "success": false,
                "message": errorMessage
            ])
        }
    }
}
