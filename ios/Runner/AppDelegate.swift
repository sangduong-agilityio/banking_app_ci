import Flutter
import UIKit
import LocalAuthentication
import os.log

@main
@objc class AppDelegate: FlutterAppDelegate {
    // Define the channel name (must match the Dart side)
    private let CHANNEL = "system_info"
    private var shortcutAction: String?
    private let logger = Logger(subsystem: "com.example.banking_app", category: "PlatformChannel")
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        logger.info("AppDelegate didFinishLaunchingWithOptions")
        logger.debug("Setting up MethodChannel: \(self.CHANNEL)")
        
        // Get the FlutterViewController
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        
        // Set up the MethodChannel
        let methodChannel = FlutterMethodChannel(
            name: CHANNEL,
            binaryMessenger: controller.binaryMessenger
        )
        
        methodChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard let self = self else { return }
            
            let startTime = Date()
            self.logger.info(" Method called: \(call.method)")
            
            switch call.method {
            case "getSystemVersion":
                self.logger.debug("Getting system version...")
                let version = self.getSystemVersion()
                self.logger.debug("System version: \(version)")
                result(version)
                
            case "getBatteryLevel":
                self.logger.debug("Getting battery level...")
                let batteryLevel = self.getBatteryLevel()
                if batteryLevel >= 0 {
                    self.logger.debug("Battery level: \(batteryLevel)%")
                    result(batteryLevel)
                } else {
                    self.logger.error("Battery level unavailable")
                    result(FlutterError(
                        code: "UNAVAILABLE",
                        message: "Battery level not available.",
                        details: nil
                    ))
                }
                
            case "processData":
                if let args = call.arguments as? [String: Any],
                   let inputData = args["inputData"] as? String,
                   let timestamp = args["timestamp"] as? Int64 {
                    self.logger.debug("Processing data: \(inputData) at \(timestamp)")
                    let processedData = "Processed: \(inputData) at \(timestamp)"
                    result(processedData)
                } else {
                    self.logger.error("Invalid arguments for processData")
                    result(FlutterError(
                        code: "INVALID_ARGUMENT",
                        message: "Invalid arguments",
                        details: nil
                    ))
                }
                
            case "sendHelloWorld":
                if let args = call.arguments as? [String: Any],
                   let message = args["message"] as? String,
                   let fromFlutter = args["fromFlutter"] as? Bool {
                    self.logger.debug("Received Hello World: message='\(message)', fromFlutter=\(fromFlutter)")
                    let response = fromFlutter 
                        ? "iOS says: Received '\(message)' from Flutter!"
                        : "iOS says: Hello!"
                    self.logger.debug("Sending response: \(response)")
                    result(response)
                } else {
                    self.logger.error("Invalid arguments for sendHelloWorld")
                    result(FlutterError(
                        code: "INVALID_ARGUMENT",
                        message: "Invalid arguments for sendHelloWorld",
                        details: nil
                    ))
                }
                
            case "isBiometricAvailable":
                self.logger.debug("Checking biometric availability...")
                let isAvailable = self.isBiometricAvailable()
                self.logger.info("Biometric available: \(isAvailable)")
                result(isAvailable)
                
            case "authenticateWithBiometric":
                let reason: String
                if let args = call.arguments as? [String: Any],
                   let argReason = args["reason"] as? String {
                    reason = argReason
                } else {
                    reason = "Authenticate to continue"
                }
                self.logger.info("Starting biometric authentication with reason: \(reason)")
                self.authenticateWithBiometric(reason: reason, result: result)
                
            case "addAppShortcuts":
                if let args = call.arguments as? [String: Any],
                   let shortcuts = args["shortcuts"] as? [[String: String]] {
                    self.logger.debug("Adding \(shortcuts.count) app shortcuts")
                    self.addAppShortcuts(shortcuts: shortcuts)
                    self.logger.info("App shortcuts added successfully")
                    result(nil)
                } else {
                    self.logger.error("Invalid shortcuts argument")
                    result(FlutterError(
                        code: "INVALID_ARGUMENT",
                        message: "Invalid shortcuts argument",
                        details: nil
                    ))
                }
                
            case "getShortcutAction":
                self.logger.debug("Getting shortcut action: \(self.shortcutAction ?? "nil")")
                result(self.shortcutAction)
                self.shortcutAction = nil
                
            default:
                self.logger.warning("Method not implemented: \(call.method)")
                result(FlutterMethodNotImplemented)
            }
            
            let duration = Date().timeIntervalSince(startTime)
            self.logger.info("Method '\(call.method)' completed in \(String(format: "%.2f", duration * 1000))ms")
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
        logger.debug("Setting up biometric authentication context...")
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            logger.debug("Showing biometric prompt to user...")
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.logger.info("Biometric authentication succeeded!")
                        result([
                            "success": true,
                            "message": "Authentication successful!"
                        ])
                    } else {
                        let errorMessage = authenticationError?.localizedDescription ?? "Authentication failed"
                        self.logger.error("Biometric authentication error: \(errorMessage)")
                        result([
                            "success": false,
                            "message": "Authentication error: \(errorMessage)"
                        ])
                    }
                }
            }
        } else {
            let errorMessage = error?.localizedDescription ?? "Biometric authentication not available"
            logger.error("❌ Biometric not available: \(errorMessage)")
            result([
                "success": false,
                "message": errorMessage
            ])
        }
    }
    
    /**
     * Add quick actions (app shortcuts)
     */
    private func addAppShortcuts(shortcuts: [[String: String]]) {
        logger.debug("Creating \(shortcuts.count) quick action shortcuts...")
        var shortcutItems: [UIApplicationShortcutItem] = []
        
        for (index, shortcut) in shortcuts.enumerated() {
            let id = shortcut["id"] ?? "shortcut_\(index)"
            let label = shortcut["label"] ?? "Shortcut"
            let icon = shortcut["icon"] ?? "ic_launcher"
            
            logger.debug("  - Creating shortcut: id=\(id), label=\(label)")
            
            let shortcutItem = UIApplicationShortcutItem(
                type: id,
                localizedTitle: label,
                localizedSubtitle: nil,
                icon: UIApplicationShortcutIcon(type: .compose),
                userInfo: nil
            )
            shortcutItems.append(shortcutItem)
        }
        
        UIApplication.shared.shortcutItems = shortcutItems
        logger.info("\(shortcutItems.count) shortcuts registered with UIApplication")
    }
    
    /**
     * Handle quick action launch
     */
    override func application(
        _ application: UIApplication,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        logger.info("Shortcut action detected: \(shortcutItem.type)")
        shortcutAction = shortcutItem.type
        completionHandler(true)
    }
}
