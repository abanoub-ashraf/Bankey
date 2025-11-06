import UIKit

/// A reusable login form view containing username and password text fields.
///
/// Layout:
/// ```
/// ┌──────────────────────┐
/// │ enter username...    │
/// ├──────────────────────┤ ← 1px divider
/// │ enter password...    │
/// └──────────────────────┘
/// ```
///
/// Features:
/// - Rounded corners with secondary background color
/// - Vertical stack layout with text fields separated by a divider
/// - Secure text entry for password field
/// - Return key handling to dismiss keyboard
class LoginView: UIView {

    // MARK: - UI

    /// Stack view containing the text fields and divider
    let stackView           = UIStackView()

    /// Text field for entering username
    let usernameTextField   = UITextField()

    /// 1-pixel divider line between the text fields
    let dividerView         = UIView()

    /// Secure text field for entering password
    let passwordTextField   = UITextField()

    // MARK: - Initializer

    /// Initializes the login view programmatically (not from XIB/Storyboard).
    ///
    /// - Parameter frame: The initial frame rectangle for the view
    override init(frame: CGRect) {
        super.init(frame: frame)

        style()
        layout()
    }

    /// Required initializer for Interface Builder (not supported).
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Extensions

extension LoginView {

    /// Applies visual styling to the login view and its subviews.
    ///
    /// Configures:
    /// - Container view with rounded corners and secondary background
    /// - Stack view with vertical layout
    /// - Text fields with placeholders and delegates
    /// - Divider line between fields
    func style() {
        // Style the container view
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor     = .secondarySystemBackground  // Light gray
        layer.cornerRadius  = 10
        clipsToBounds       = true  // Required for cornerRadius to work

        // Collect all subviews for batch configuration
        let subViews = [
            stackView,
            usernameTextField,
            dividerView,
            passwordTextField
        ]

        // Disable autoresizing masks for Auto Layout
        subViews.forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        // Configure stack view for vertical layout
        stackView.axis                      = .vertical
        stackView.spacing                   = 8

        // Configure username text field
        usernameTextField.placeholder       = "enter username..."
        usernameTextField.delegate          = self

        // Configure divider (thin horizontal line)
        dividerView.backgroundColor         = .secondarySystemFill

        // Configure password text field with secure entry
        passwordTextField.placeholder       = "enter password..."
        passwordTextField.isSecureTextEntry = true  // Hides password as user types
        passwordTextField.delegate          = self
    }

    /// Positions all UI elements using Auto Layout constraints.
    ///
    /// The stack view manages the vertical layout of text fields and divider,
    /// so those views don't need individual constraints. We only need to:
    /// 1. Add views to the stack view
    /// 2. Position the stack view within the container
    /// 3. Set the divider's height
    func layout() {
        // Add views to stack in vertical order
        let arrangedSubViews = [
            usernameTextField,
            dividerView,
            passwordTextField
        ]

        arrangedSubViews.forEach { view in
            stackView.addArrangedSubview(view)
        }

        // Add stack view to the container
        addSubview(stackView)

        // Pin stack view to container edges with 1x system spacing padding
        // Stack view automatically manages the layout of its arranged subviews
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 1),
            bottomAnchor.constraint(equalToSystemSpacingBelow: stackView.bottomAnchor, multiplier: 1)
        ])

        // Set fixed height for divider line (1 pixel)
        dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }

}

// MARK: - UITextFieldDelegate

/// Extension conforming to UITextFieldDelegate protocol.
///
/// Handles text field events, primarily for keyboard dismissal when the
/// Return key is tapped.
extension LoginView: UITextFieldDelegate {

    /// Called when the Return key is pressed in either text field.
    ///
    /// Dismisses the keyboard by ending editing on both text fields.
    /// This provides a clean way for users to finish entering their credentials.
    ///
    /// - Parameter textField: The text field where Return was pressed
    /// - Returns: true to allow default Return key behavior
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss keyboard for both text fields
        usernameTextField.endEditing(true)
        passwordTextField.endEditing(true)

        return true
    }

    /// Called to determine if editing should stop.
    ///
    /// Returns true to allow the text field to resign first responder status
    /// (lose focus and dismiss keyboard).
    ///
    /// - Parameter textField: The text field requesting to end editing
    /// - Returns: true to allow editing to end
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }

    /// Called after editing has ended.
    ///
    /// This method is called even if textFieldShouldEndEditing returns false,
    /// such as when the view is removed from the window or endEditing(true) is
    /// called forcefully.
    ///
    /// Currently empty - could be used for validation or cleanup.
    ///
    /// - Parameter textField: The text field that ended editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Optional: Add any cleanup or validation logic here
    }

}
