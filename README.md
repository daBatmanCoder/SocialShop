# Arnacon Authentication Integration

## Overview
This document provides a comprehensive guide on integrating Google and Facebook sign-in functionalities into the Arnacon app. It includes instructions on setting up OAuth credentials, handling authentication on the client-side, and verifying access tokens on the server to securely authenticate users.

## Prerequisites
- Node.js installed on your server.
- Google Cloud Functions for server-side logic.
- Access to Google Developer Console and Facebook Developer Console.
- A registered application on both platforms with OAuth configured.

## Setup Instructions

### Google Sign-In Integration

1. **Google Developer Console Setup**:
    - Go to the [Google Developer Console](https://console.developers.google.com/).
    - Create a new project or select an existing one.
    - Navigate to 'Credentials', create OAuth 2.0 credentials, and note down your client ID and client secret.
    - Configure the consent screen with the required scopes (`email`, `profile`).

2. **Client-Side Configuration**:
    - Install the Google Sign-In SDK in your project.
    - Implement the sign-in button in your SwiftUI view.
    ```swift
    import GoogleSignIn

    GoogleSignInButton(action: handleSignInButton)
    ```

3. **Server-Side Token Verification**:
    - Deploy a function to Google Cloud Functions to verify the token.
    ```javascript
    const {OAuth2Client} = require('google-auth-library');
    const client = new OAuth2Client(CLIENT_ID);

    async function verifyToken(token) {
        const ticket = await client.verifyIdToken({
            idToken: token,
            audience: CLIENT_ID,
        });
        const payload = ticket.getPayload();
        return payload; // contains user_id, email, name, etc.
    }
    ```

### Facebook Sign-In Integration

1. **Facebook Developer Console Setup**:
    - Visit the [Facebook Developers](https://developers.facebook.com/) site and create a new app.
    - In the app dashboard, navigate to 'Facebook Login' and setup your platform (iOS).
    - Note down the `App ID` and `App Secret`.

2. **Client-Side Configuration**:
    - Install the Facebook SDK for iOS.
    - Implement the Facebook login button.
    ```swift
    import FacebookLogin

    let loginButton = FBLoginButton()
    loginButton.permissions = ["public_profile", "email"]
    ```

3. **Server-Side Token Verification**:
    - Set up a server-side endpoint to verify the Facebook token and fetch user data.
    ```javascript
    const axios = require('axios');

    async function verifyFacebookToken(userAccessToken) {
        const url = `https://graph.facebook.com/me?fields=id,name,email&access_token=${userAccessToken}`;
        const response = await axios.get(url);
        return response.data; // contains user_id, name, email if allowed
    }
    ```

## Deployment
- Deploy your Google and Facebook token verification functions to Google Cloud Functions.
- Ensure your server uses HTTPS to secure data transmission.

## Usage
- Users sign in through the app using Google or Facebook.
- The app receives an OAuth token and sends it to the server.
- The server verifies the token, retrieves user details, and issues a unique identifier for use within Arnacon.

## Security Considerations
- Securely store OAuth credentials and ensure tokens are handled securely in transit.
- Implement robust error handling and validation on the server-side to prevent unauthorized access.

## Conclusion
This setup provides a secure and scalable way to manage user authentication in the Arnacon app using Google and Facebook OAuth integrations.

