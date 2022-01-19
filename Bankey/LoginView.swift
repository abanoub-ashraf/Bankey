import UIKit

class LoginView: UIView {
    
    // MARK: - UI

    let stackView           = UIStackView()
    let usernameTextField   = UITextField()
    let dividerView         = UIView()
    let passwordTextField   = UITextField()
    
    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Extensions

extension LoginView {
    
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor     = .secondarySystemBackground
        layer.cornerRadius  = 10
        clipsToBounds       = true
        
        let subViews = [
            stackView,
            usernameTextField,
            dividerView,
            passwordTextField
        ]
            
        subViews.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        stackView.axis                      = .vertical
        stackView.spacing                   = 8
        
        usernameTextField.placeholder       = "enter username..."
        usernameTextField.delegate          = self
        
        dividerView.backgroundColor         = .secondarySystemFill
        
        passwordTextField.placeholder       = "enter password..."
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate          = self
    }
    
    func layout() {
        let arrangedSubViews = [
            usernameTextField,
            dividerView,
            passwordTextField
        ]
            
        arrangedSubViews.forEach { view in
            stackView.addArrangedSubview(view)
        }
        
        addSubview(stackView)
        
        ///
        /// the views i put in the stack view doesn't need any constraints
        ///
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 1),
            bottomAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 1)
        ])
        
        dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
}

// MARK: - UITextFieldDelegate

extension LoginView: UITextFieldDelegate {
    
    ///
    /// this is called when the return key is pressed
    ///
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.endEditing(true)
        passwordTextField.endEditing(true)
        
        return true
    }
    
    ///
    /// return YES to allow editing to stop and to resign first responder status,
    /// return NO to disallow the editing session to end
    ///
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    ///
    /// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window)
    /// or endEditing:YES called
    ///
    func textFieldDidEndEditing(_ textField: UITextField) {
        //
    }
    
}
