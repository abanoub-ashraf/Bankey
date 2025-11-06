import Foundation

/// Protocol for notifying when login is completed successfully.
///
/// This delegate pattern decouples the LoginViewController from the AppDelegate,
/// allowing the login screen to notify its delegate when authentication succeeds
/// without knowing the specifics of what happens next.
///
/// The AppDelegate implements this protocol to handle post-login navigation
/// (either to onboarding or directly to the main app).
///
/// Example usage:
/// ```
/// class AppDelegate: LoginViewControllerDelegate {
///     func didFinishLogIn() {
///         // Navigate to next screen based on onboarding state
///     }
/// }
/// ```
protocol LoginViewControllerDelegate: AnyObject {
    /// Called when the user successfully completes the login process.
    ///
    /// The delegate should handle navigation to the appropriate next screen
    /// (onboarding for first-time users, or main app for returning users).
    func didFinishLogIn()
}
