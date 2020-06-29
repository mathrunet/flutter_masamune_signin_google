part of masamune.signin.google;

/// Sign in to Firebase using Google OAuth.
class GoogleAuth {
  /// Gets the options for the provider.
  static const AuthProviderOptions options = const AuthProviderOptions(
      id: "google",
      provider: _provider,
      title: "Google SignIn",
      text: "Sign in with your Google account.");
  static Future<FirestoreAuth> _provider(
      BuildContext context, Duration timeout) {
    return signIn(timeout: timeout);
  }

  /// Sign in to Firebase using Google OAuth.
  ///
  /// [protorol]: Protocol specification.
  /// [timeout]: Timeout time.
  static Future<FirestoreAuth> signIn(
      {String protocol, Duration timeout = Const.timeout}) {
    return FirestoreAuth.signInWithProvider(
        providerCallback: (timeout) async {
          GoogleSignIn google = GoogleSignIn();
          GoogleSignInAccount googleCurrentUser = google.currentUser;
          if (googleCurrentUser == null) {
            googleCurrentUser = await google.signInSilently().timeout(timeout);
          }
          if (googleCurrentUser == null) {
            googleCurrentUser = await google.signIn().timeout(timeout);
          }
          if (googleCurrentUser == null) {
            Log.error("Google user could not get.");
            return Future.delayed(Duration.zero);
          }
          GoogleSignInAuthentication googleAuth =
              await googleCurrentUser.authentication;
          return GoogleAuthProvider.getCredential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
        },
        providerId: GoogleAuthProvider.providerId,
        protocol: protocol,
        timeout: timeout);
  }
}
