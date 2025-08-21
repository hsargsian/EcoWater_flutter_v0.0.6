import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        }
        
        configureChannel()

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func configureChannel() {
        let controller = window?.rootViewController as! FlutterViewController
        let bluetoothChannel = FlutterMethodChannel(name: "com.echowater/bluetooth", binaryMessenger: controller.binaryMessenger)

        bluetoothChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            if call.method == "openBluetoothSettings" {
                self.openBluetoothSettings(result: result)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }

    private func openBluetoothSettings(result: @escaping FlutterResult) {
        let bluetoothURL = URL(string: "App-Prefs:root=Bluetooth")
        let settingsURL = URL(string: UIApplication.openSettingsURLString)

        if let bluetoothURL = bluetoothURL, UIApplication.shared.canOpenURL(bluetoothURL) {
            UIApplication.shared.open(bluetoothURL, options: [:]) { success in
                if success {
                    result(true)
                } else if let settingsURL = settingsURL {
                    // Fallback to general settings if Bluetooth settings cannot be opened
                    UIApplication.shared.open(settingsURL, options: [:]) { success in
                        if success {
                            result(true)
                        } else {
                            result(FlutterError(code: "UNAVAILABLE", message: "Failed to open settings", details: nil))
                        }
                    }
                } else {
                    result(FlutterError(code: "UNAVAILABLE", message: "Failed to open Bluetooth or general settings", details: nil))
                }
            }
        } else if let settingsURL = settingsURL {
            // Open general settings if Bluetooth settings cannot be opened directly
            UIApplication.shared.open(settingsURL, options: [:]) { success in
                if success {
                    result(true)
                } else {
                    result(FlutterError(code: "UNAVAILABLE", message: "Failed to open general settings", details: nil))
                }
            }
        } else {
            result(FlutterError(code: "UNAVAILABLE", message: "Cannot create settings URL", details: nil))
        }
    }

}
