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

/// How this copy of the app was packaged. The unsigned IPA built by CI has no
/// provisioning profile, so entitlement-gated services (CloudKit, iCloud,
/// Firebase accounts) have nothing to run against; sideload launchers such as
/// LiveContainer additionally refuse to apply a guest app's entitlements. The
/// packaging step stamps `YueduUnsignedBuild` into Info.plist so those services
/// can stay inert instead of trapping inside a framework that cannot work.
enum BuildCapabilities {
    static let isUnsignedSideloadBuild: Bool =
        (Bundle.main.object(forInfoDictionaryKey: "YueduUnsignedBuild") as? Bool) ?? false

    /// `CKContainer(identifier:)` raises when the identifier is missing from the
    /// app's `com.apple.developer.icloud-container-identifiers` entitlement,
    /// which is exactly the sideload case. Constructing the container is what
    /// has to be avoided: the exception cannot be caught from Swift.
    static var isCloudKitAvailable: Bool { !isUnsignedSideloadBuild }
}
