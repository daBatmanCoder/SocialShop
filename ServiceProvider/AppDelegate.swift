import UIKit
import GoogleSignIn
import iArnaconSDK
import FacebookCore

public class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var web3Service: Web3IS? // Store web3Service globally
    var publicKey: String?
    
    override init() {
        super.init()
        print("AppDelegate is being initialized")
        createWeb3() // Initialize web3 service right when the app delegate is initialized
    }

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("App Launch: Initialize web3")
        // Initialize Facebook SDK
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Restore previous Google sign-in session
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let error = error {
                print("Error restoring Google sign-in: \(error)")
            } else if let user = user {
                print("User is already signed in: \(user)")
            } else {
                print("No previous Google sign-in session or error.")
            }
        }
        
        return true
    }

    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Handle URL that the Facebook and Google SDKs can both handle
        let handledGoogle = GIDSignIn.sharedInstance.handle(url)
        let handledFacebook = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        
        return handledGoogle || handledFacebook
    }

    func createWeb3() {
        let dataSaveHelper = UserDefaultsDataSaveHelper()
        let logger = ConsoleLogger()
        web3Service = Web3IS(_dataSaveHelper: dataSaveHelper, _logger: logger)
        logger.debug(value: web3Service!.WALLET.getPublicKey()!)
        publicKey = web3Service!.WALLET.getPublicKey()!
    }
}
