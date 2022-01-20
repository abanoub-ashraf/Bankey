import Foundation

///
/// this protocol is for telling the app delegate that we finished
/// onboarding so it does something about it
///
protocol OnboardingContainerViewControllerDelegate: AnyObject {
    func didFinishOnboarding()
}
