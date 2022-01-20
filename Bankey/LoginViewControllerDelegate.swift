import Foundation

///
/// - connects the login controller with the app delegate
///
/// - to tell the AppDelegate to do something after we login
///
protocol LoginViewControllerDelegate: AnyObject {
    func didFinishLogIn()
}
