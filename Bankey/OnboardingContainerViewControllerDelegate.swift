import Foundation

/// Protocol for notifying when the onboarding flow is completed.
///
/// This delegate pattern allows OnboardingContainerViewController to notify
/// its delegate (AppDelegate) when the user finishes or skips onboarding,
/// without knowing the specifics of what happens next.
///
/// The AppDelegate implements this protocol to:
/// 1. Mark onboarding as complete in LocalState
/// 2. Navigate to the main app interface
///
/// Example usage:
/// ```
/// class AppDelegate: OnboardingContainerViewControllerDelegate {
///     func didFinishOnboarding() {
///         LocalState.hasOnboarded = true
///         // Navigate to main app
///     }
/// }
/// ```
protocol OnboardingContainerViewControllerDelegate: AnyObject {
    /// Called when the user completes or skips the onboarding flow.
    ///
    /// The delegate should save the onboarding completion state and
    /// navigate to the main app interface.
    func didFinishOnboarding()
}
