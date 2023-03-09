import UIKit
import Flutter
// import awesome_notifications
// import shared_preferences_foundation
import flutter_local_notifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
        // FLUTTER LOCAL NOTIFICATIONS
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
        GeneratedPluginRegistrant.register(with: registry)

//        // WORKMANAGER
//        UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(15))
//        WorkmanagerPlugin.registerTask(withIdentifier: "com.company.simpleTask")
      }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
}
