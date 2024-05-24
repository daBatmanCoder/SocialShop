import SwiftUI
import GoogleSignIn
import iArnaconSDK

@main
struct ServiceProviderApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
