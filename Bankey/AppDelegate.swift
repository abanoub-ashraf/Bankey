import UIKit

/// The main application delegate responsible for managing the app's lifecycle
/// and coordinating navigation between login, onboarding, and main screens.
///
/// This class acts as the central coordinator for the app's navigation flow:
/// 1. Login Screen → 2. Onboarding (first time only) → 3. Main Tab Bar Interface
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties

    /// The main window that hosts all view controllers
    var window: UIWindow?

    /// All view controllers are instantiated here and reused throughout the app lifecycle
    /// to maintain state and avoid recreating them unnecessarily
    let loginViewController                 = LoginViewController()
    let onBoardingContainerViewController   = OnboardingContainerViewController()
    let mainViewController                  = MainViewController()
    
    // MARK: - AppLifeCycle

    /// Called when the app finishes launching. This is the app's entry point.
    ///
    /// Sets up the main window, configures delegates, and displays the login screen.
    /// - Parameters:
    ///   - application: The singleton app instance
    ///   - launchOptions: Dictionary containing launch options (notifications, URLs, etc.)
    /// - Returns: true to indicate successful launch
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        // Create and configure the main window to fill the entire screen
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor     = .systemBackground

        // Set this AppDelegate as the delegate for login and onboarding screens
        // This allows us to respond to completion events (login success, onboarding finished)
        loginViewController.delegate                = self
        onBoardingContainerViewController.delgate   = self

        // Start the app flow by showing the login screen
        displayLogin()

        return true
    }
    
}

// MARK: - Helper Functions

extension AppDelegate {

    /// Displays the login screen as the root view controller.
    /// This is called on app launch to show the initial login screen.
    private func displayLogin() {
        setRootViewController(loginViewController)
    }

    /// Determines and displays the appropriate next screen after successful login.
    ///
    /// Uses LocalState to check if the user has completed onboarding:
    /// - If already onboarded: goes directly to the main tab bar interface
    /// - If not onboarded yet: shows the onboarding flow first
    private func displayNextScreen() {
        if LocalState.hasOnboarded {
            // User has already seen onboarding, go straight to main app
            prepMainView()

            setRootViewController(mainViewController)
        } else {
            // First time user, show onboarding screens
            setRootViewController(onBoardingContainerViewController)
        }
    }

    /// Prepares and configures the main view controller before displaying it.
    ///
    /// This sets up:
    /// - Status bar styling for the main interface
    /// - Navigation bar appearance (non-translucent with app's main color)
    private func prepMainView() {
        // Configure status bar style
        mainViewController.setStatusBar()

        // Configure navigation bar appearance globally for all navigation controllers
        UINavigationBar.appearance().isTranslucent      = false
        UINavigationBar.appearance().backgroundColor    = AppColors.mainColor
    }
    
    /// Sets the root view controller of the window with an optional smooth transition animation.
    ///
    /// This function handles all screen transitions in the app. The animation creates a
    /// professional cross-dissolve effect when switching between major screens (login,
    /// onboarding, main interface).
    ///
    /// - Parameters:
    ///   - viewController: The new view controller to set as root
    ///   - animated: Whether to animate the transition (default: true)
    func setRootViewController(_ viewController: UIViewController, animated: Bool = true) {
        // If animation is disabled or window doesn't exist, just set root directly
        guard animated, let window = self.window else {
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
            return
        }

        // Set the new root view controller
        window.rootViewController = viewController
        window.makeKeyAndVisible()

        // Apply a smooth cross-dissolve transition animation
        // Duration: 0.5 seconds - provides a professional, polished feel
        // transitionCrossDissolve: fades out old screen while fading in new screen
        UIView.transition(
            with: window,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: nil,
            completion: nil
        )
    }
    
}

// MARK: - LoginViewControllerDelegate

/// Extension conforming to LoginViewControllerDelegate protocol.
///
/// This delegate pattern allows the LoginViewController to notify the AppDelegate
/// when the user successfully logs in, so the app can navigate to the next screen.
extension AppDelegate: LoginViewControllerDelegate {

    /// Called when the user successfully completes the login process.
    ///
    /// This triggers the navigation logic that determines where to go next:
    /// - First-time users: shown the onboarding flow
    /// - Returning users: taken directly to the main tab bar interface
    func didFinishLogIn() {
        displayNextScreen()
    }

}

// MARK: - OnboardingContainerViewControllerDelegate

/// Extension conforming to OnboardingContainerViewControllerDelegate protocol.
///
/// This delegate pattern allows the OnboardingContainerViewController to notify
/// the AppDelegate when the user completes the onboarding flow.
extension AppDelegate: OnboardingContainerViewControllerDelegate {

    /// Called when the user finishes the onboarding flow.
    ///
    /// This method:
    /// 1. Saves the onboarding completion state to LocalState (UserDefaults)
    /// 2. Configures the main view controller's appearance
    /// 3. Navigates to the main tab bar interface
    ///
    /// The saved state ensures onboarding is only shown once per installation.
    func didFinishOnboarding() {
        // Mark onboarding as completed in persistent storage
        LocalState.hasOnboarded = true

        // Configure navigation bar and status bar for main interface
        prepMainView()

        // Navigate to main tab bar with smooth animation
        setRootViewController(mainViewController)
    }

}

// MARK: - LogoutDelegate

/// Extension conforming to LogoutDelegate protocol.
///
/// This delegate pattern allows any view controller to trigger a logout,
/// returning the user to the login screen.
extension AppDelegate: LogoutDelegate {

    /// Called when the user initiates a logout.
    ///
    /// Returns to the login screen, allowing the user to sign in again.
    /// Note: This does not clear the onboarding state, so returning users
    /// won't see onboarding again.
    func didLogout() {
        setRootViewController(loginViewController)
    }

}
