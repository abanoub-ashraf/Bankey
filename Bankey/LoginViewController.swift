import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - UI

    let loginView           = LoginView()
    let signInButton        = UIButton(type: .system)
    let errorMessageLabel   = UILabel()
    
    // MARK: - Properties

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

}

// MARK: - Extensions

extension LoginViewController {
    
    private func style() {
        [loginView, signInButton, errorMessageLabel].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
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
        [loginView, signInButton, errorMessageLabel].forEach { subView in
            view.addSubview(subView)
        }
        
        NSLayoutConstraint.activate([
            loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: loginView.trailingAnchor, multiplier: 1)
        ])
        
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalToSystemSpacingBelow: loginView.bottomAnchor, multiplier: 2),
            signInButton.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
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
