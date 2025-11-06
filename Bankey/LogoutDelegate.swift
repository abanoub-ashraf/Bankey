import Foundation

/// Protocol for notifying when the user initiates logout.
///
/// This delegate pattern allows any view controller to trigger a logout
/// action without knowing the specifics of how logout is handled.
///
/// The AppDelegate implements this protocol to return to the login screen.
///
/// Example usage:
/// ```
/// class AppDelegate: LogoutDelegate {
///     func didLogout() {
///         // Return to login screen
///     }
/// }
/// ```
protocol LogoutDelegate: AnyObject {
    /// Called when the user requests to log out.
    ///
    /// The delegate should handle logout cleanup and navigate back
    /// to the login screen.
    func didLogout()
}
