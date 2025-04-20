import UIKit
import Flutter
import SwiftUI

@main
@objc class AppDelegate: FlutterAppDelegate {
    lazy var flutterEngine = FlutterEngine(name: "main_engine")

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Start the Flutter engine
        flutterEngine.run()

        // Set the initial route (optional)
        // flutterEngine.navigationChannel.invokeMethod("setInitialRoute", arguments: "/")

        // Register plugins
        GeneratedPluginRegistrant.register(with: self.flutterEngine)

        // Make the engine available to the FlutterViewController
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        self.window.rootViewController = flutterViewController
        self.window.makeKeyAndVisible()

        // Register the platform view factory
        if let registrar = flutterEngine.registrar(forPlugin: "ProfileViewPlugin") {
            let factory = ProfileViewFactory(messenger: registrar.messenger())
            registrar.register(
                factory,
                withId: "profile-view"
            )
        }#imageLiteral(resourceName: "simulator_screenshot_3EE04911-469C-44A6-9A9B-B07B2E6031B2.png")

        setupMethodChannel(controller: flutterViewController)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func setupMethodChannel(controller: FlutterViewController) {
        let methodChannel = FlutterMethodChannel(
            name: "com.example.weather_profile/channel",
            binaryMessenger: controller.binaryMessenger
        )

        methodChannel.setMethodCallHandler { [weak self] (call, result) in
            guard let self = self else { return }

            switch call.method {
            case "getUserProfile":
                let userProfile = [
                    "name": "John Doe",
                    "email": "john.doe@example.com",
                    "profilePicture": "https://randomuser.me/api/portraits/men/1.jpg"
                ]
                result(userProfile)

            case "sendFeedback":
                if let args = call.arguments as? [String: Any],
                   let feedback = args["feedback"] as? String {
                    // Show feedback alert
                    self.showFeedbackAlert(feedback: feedback)
                    result(true)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENTS",
                                      message: "Invalid arguments",
                                      details: nil))
                }

            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    private func showFeedbackAlert(feedback: String) {
        // Get the root view controller to show the alert
        if let viewController = self.window.rootViewController {
            let alert = UIAlertController(
                title: "Feedback Received",
                message: feedback,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            viewController.present(alert, animated: true)
        }
    }
}
