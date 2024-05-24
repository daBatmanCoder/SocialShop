import SwiftUI
import GoogleSignInSwift
import GoogleSignIn
import FacebookLogin

struct ContentView: View {
    // A state to handle visibility of a loading indicator when logging in
    @State private var isLoggingIn = false
    @State private var navigateToNextScreen = false
    @State private var userIsLoggedIn = false

    init() {
        setupFacebookLoginObserver()
    }

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                // App Logo or Image
                Image(systemName: "globe")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.white)
                
                // App Title
                Text("Arnacon")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                Spacer()

                // Google Sign-In Button
                GoogleSignInButton(action: handleSignInButton)
                    .frame(height: 50)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
                FacebookLoginButton()
                    .frame(height: 50)
                    .padding()
                    .background(Color.indigo)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                
                Spacer()
                
                // Display a loading indicator when the login process is underway
                if isLoggingIn {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                }
            }
            .padding()
            
        }
        
        VStack {
            if userIsLoggedIn {
                // NavigationLink to next screen or show user info, etc.
            }
        }
//        VStack {
//            Text("Welcome to Arnacon")
//            if let publicKey = Web3Manager.shared.publicKey {
//                Text("Your Public Key: \(publicKey)")
//            } else {
//                Text("No Public Key Available")
//            }
//        }
    }
    
    func handleFBLogin() {
        
    }
    
    private func setupFacebookLoginObserver() {
        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: .main) { _ in
            self.userIsLoggedIn = AccessToken.current != nil
            if let token = AccessToken.current?.tokenString {
                print("Facebook Access Token: \(token)")
                sendAuthTokenToServer(idToken: token, urlOfPost: "https://us-central1-arnacon-nl.cloudfunctions.net/verifyFacebookToken")
                // Here you can add additional code to handle the token, such as sending it to your server
            }
        }
    }
    
    func handleSignInButton() {
        self.isLoggingIn = true
        guard let rootVC = getRootViewController() else {
            print("Root ViewController not found.")
            self.isLoggingIn = false
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { signInResult, error in
            self.isLoggingIn = false
            guard error == nil else {
                print("Error during Google SignIn: \(error!.localizedDescription)")
                return
            }
            guard let signInResult = signInResult else {
                print("No sign-in result available.")
                return
            }
            
            signInResult.user.refreshTokensIfNeeded { user, error in
                guard error == nil else {
                    print("Error refreshing tokens: \(error!.localizedDescription)")
                    return
                }
                guard let user = user else {
                    print("No user data received.")
                    return
                }
                
                let idToken = user.idToken
                print(idToken!.tokenString)
                sendAuthTokenToServer(idToken: idToken!.tokenString, urlOfPost: "https://us-central1-arnacon-nl.cloudfunctions.net/verifyToken")
                
                
            }
        }
    }
    
    func sendAuthTokenToServer(idToken: String, urlOfPost: String) {

        let publicKey = Web3Manager.shared.publicKey
        
        guard let authData = try? JSONEncoder().encode(["token": idToken, "user_address": publicKey]) else {
            return
        }
        let url = URL(string: urlOfPost)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: authData) { data, response, error in
            DispatchQueue.main.async {
                // Assuming verification was successful
                if response is HTTPURLResponse, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    self.navigateToNextScreen = true
                } else {
                    print("Failed to verify token or public key")
                }
            }
        }
        task.resume()
    }
    
    func getRootViewController() -> UIViewController? {
        return UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController
    }
}


struct FacebookLoginButton: UIViewRepresentable {
    func makeUIView(context: Context) -> FBLoginButton {
        let button = FBLoginButton()
        button.permissions = ["public_profile", "email"]
        return button
    }

    func updateUIView(_ uiView: FBLoginButton, context: Context) {
    }
}
