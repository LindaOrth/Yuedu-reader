import FirebaseCore
import Foundation

enum FirebaseBootstrap {
    private static let placeholderAPIKey = "disabled"

    static var isConfigured: Bool {
        FirebaseApp.app() != nil
    }

    static func configureIfAvailable() {
        guard FirebaseApp.app() == nil else { return }
        guard let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
              let configuration = NSDictionary(contentsOfFile: path),
              let apiKey = configuration["API_KEY"] as? String,
              !apiKey.isEmpty,
              apiKey != placeholderAPIKey else {
            return
        }
        FirebaseApp.configure()
    }
}
