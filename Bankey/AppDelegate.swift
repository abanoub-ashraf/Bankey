import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties
    
    var window: UIWindow?
    
    let loginViewController                 = LoginViewController()
    let onBoardingContainerViewController   = OnboardingContainerViewController()
    let dummyViewController                 = DummyViewController()
    let mainViewController                  = MainViewController()
    
    // MARK: - AppLifeCycle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor     = .systemBackground
        window?.rootViewController  = mainViewController
        
        mainViewController.selectedIndex = 2
        
        loginViewController.delegate                = self
        onBoardingContainerViewController.delgate   = self
        dummyViewController.logoutDelegate          = self
        
        return true
    }
    
}

// MARK: - Helper Functions

extension AppDelegate {
    
    ///
    /// sets the root view controller with smooth transition
    ///
    func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard animated, let window = self.window else {
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            return
        }
        
        window.rootViewController = vc
        window.makeKeyAndVisible()
        
        ///
        /// - this applies an animation transition
        ///
        /// - this creates a transition animation for the specified container view
        ///
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

///
/// the login view controler delegate's function will fire
/// and this controller will listen to that so it does something upon it
///
extension AppDelegate: LoginViewControllerDelegate {
    
    ///
    /// we wanna go to the onboarding controller after a successful login
    ///
    /// we wanna do that with animation transition
    ///
    func didFinishLogIn() {
        ///
        /// if onboarded is true, go to the dummy controller,
        /// if not, go to the onboarding
        ///
        setRootViewController(
            LocalState.hasOnboarded ? dummyViewController : onBoardingContainerViewController
        )
    }
    
}

// MARK: - OnboardingContainerViewControllerDelegate

extension AppDelegate: OnboardingContainerViewControllerDelegate {
    
    ///
    /// after onboarding is done, set this to true to use it
    /// to check after the login where to to based on its value
    ///
    func didFinishOnboarding() {
        LocalState.hasOnboarded = true
        
        setRootViewController(dummyViewController)
    }
    
}

// MARK: - LogoutDelegate

extension AppDelegate: LogoutDelegate {
    
    func didLogout() {
        setRootViewController(loginViewController)
    }
    
}
