import UIKit

protocol LogoutDelegate: AnyObject {
    func didLogout()
}

///
/// - connects the login controller with the app delegate
///
/// - to tell the AppDelegate to do something after we login
///
protocol LoginViewControllerDelegate: AnyObject {
    func didFinishLogIn()
}

class LoginViewController: UIViewController {
    
    // MARK: - UI

    let titleLabel          = UILabel()
    let subtitleLabel       = UILabel()
    let loginView           = LoginView()
    let signInButton        = UIButton(type: .system)
    let errorMessageLabel   = UILabel()
    
    // MARK: - Properties

    ///
    /// this class will call the delegate function
    ///
    weak var delegate: LoginViewControllerDelegate?
    
    var username: String? {
        return loginView.usernameTextField.text
    }
    
    var password: String? {
        return loginView.passwordTextField.text
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        layout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        signInButton.configuration?.showsActivityIndicator = false
        loginView.usernameTextField.text = ""
        loginView.passwordTextField.text = ""
    }

}

// MARK: - Extensions

extension LoginViewController {
    
    private func style() {
        [
            titleLabel,
            subtitleLabel,
            loginView,
            signInButton,
            errorMessageLabel
        ].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textAlignment    = .center
        titleLabel.font             = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleLabel.text             = "Bankey"
        
        subtitleLabel.adjustsFontForContentSizeCategory = true
        subtitleLabel.textAlignment = .center
        subtitleLabel.font          = UIFont.preferredFont(forTextStyle: .title3)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.text          = "Your premium source for all things banking!"
        
        signInButton.configuration                  = .filled()
        signInButton.configuration?.imagePadding    = 8
        signInButton.setTitle("Sign In", for: [])
        signInButton.addTarget(self, action: #selector(signInTapped), for: .primaryActionTriggered)
        
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.textColor     = .systemRed
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.isHidden      = true
    }
    
    private func layout() {
        [
            titleLabel,
            subtitleLabel,
            loginView,
            signInButton,
            errorMessageLabel
        ].forEach { subView in
            view.addSubview(subView)
        }
        
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 3),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loginView.topAnchor.constraint(equalToSystemSpacingBelow: subtitleLabel.bottomAnchor, multiplier: 3),
            subtitleLabel.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loginView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: loginView.trailingAnchor, multiplier: 2),
            view.centerYAnchor.constraint(equalTo: loginView.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalToSystemSpacingBelow: loginView.bottomAnchor, multiplier: 2),
            signInButton.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: loginView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            errorMessageLabel.topAnchor.constraint(equalToSystemSpacingBelow: signInButton.bottomAnchor, multiplier: 2),
            errorMessageLabel.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
            errorMessageLabel.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
        ])
    }
}

// MARK: - Selectors

extension LoginViewController {
    
    @objc func signInTapped(sender: UIButton) {
        errorMessageLabel.isHidden = true
        
        login()
    }
    
    private func login() {
        guard
            let username = username,
            let password = password
        else {
            ///
            /// this is for me as a developer and it should never happens,
            /// if it happened then it's an error from my side
            ///
            assertionFailure("username / password should never be nil")
            return
        }
        
        ///
        /// show the error label if the username and password are empty
        ///
        if username.isEmpty || password.isEmpty {
            configureView(withMessage: "username / password cannot be blank")
            return
        }
        
        ///
        /// hardcode the login info for now
        ///
        if username == "Kevin" && password == "123" {
            signInButton.configuration?.showsActivityIndicator = true
            ///
            /// calling the delegate function
            ///
            delegate?.didFinishLogIn()
        } else {
            ///
            /// show an incorrect username and password error
            ///
            configureView(withMessage: "incorrect username / password")
        }
    }
    
    ///
    /// configure the error label with error message
    ///
    private func configureView(withMessage message: String) {
        errorMessageLabel.isHidden  = false
        errorMessageLabel.text      = message
    }

}
