import UIKit
import SwiftData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var modelContainer: ModelContainer?

    // First launch detection
    static var isFirstLaunch: Bool {
        get {
            return !UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        }
        set {
            UserDefaults.standard.set(!newValue, forKey: "hasLaunchedBefore") 
        }
    }
    func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        do {
            let schema = Schema([StoredImage.self, SavedTryOn.self])
            modelContainer = try ModelContainer(for: schema)
            _ = NetworkManager.shared
        } catch {
            fatalError("Failed to initialize SwiftData: \(error)")
        }

        // Ensure first launch key is correctly set
        if AppDelegate.isFirstLaunch {
            AppDelegate.isFirstLaunch = false
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }
}
