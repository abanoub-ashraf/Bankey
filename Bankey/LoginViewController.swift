import UIKit

/// The login screen view controller that handles user authentication.
///
/// This controller presents a login form with:
/// - App title and subtitle
/// - Username and password text fields (via LoginView)
/// - Sign In button
/// - Error message label for invalid credentials
///
/// Currently uses hardcoded credentials (Kevin/123) for demo purposes.
/// In production, this would integrate with a real authentication service.
class LoginViewController: UIViewController {

    // MARK: - UI

    /// App title label displaying "Bankey"
    let titleLabel          = UILabel()

    /// Subtitle describing the app's purpose
    let subtitleLabel       = UILabel()

    /// Custom login view containing username and password text fields
    let loginView           = LoginView()

    /// Button to submit login credentials
    let signInButton        = UIButton(type: .system)

    /// Label to display error messages (hidden by default)
    let errorMessageLabel   = UILabel()

    // MARK: - Properties

    /// Delegate to notify when login is successful.
    /// The AppDelegate implements this to handle post-login navigation.
    weak var delegate: LoginViewControllerDelegate?

    /// Computed property to access the username text field value
    var username: String? {
        return loginView.usernameTextField.text
    }

    /// Computed property to access the password text field value
    var password: String? {
        return loginView.passwordTextField.text
    }

    // MARK: - LifeCycle

    /// Called when the view controller's view is loaded into memory.
    ///
    /// Sets up styling and layout for all UI elements.
    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        layout()
    }

    /// Called when the view disappears from the screen.
    ///
    /// Resets the login form to its initial state:
    /// - Stops the activity indicator on the sign-in button
    /// - Clears the username and password fields
    ///
    /// - Parameter animated: Whether the disappearance is animated
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        // Hide loading indicator and clear form fields
        signInButton.configuration?.showsActivityIndicator = false
        loginView.usernameTextField.text = ""
        loginView.passwordTextField.text = ""
    }

}

// MARK: - Extensions

extension LoginViewController {

    /// Applies visual styling to all UI elements.
    ///
    /// Configures:
    /// - Title and subtitle labels with dynamic type support
    /// - Sign-in button with filled style
    /// - Error message label (hidden by default)
    private func style() {
        // Disable autoresizing masks for Auto Layout
        [
            titleLabel,
            subtitleLabel,
            loginView,
            signInButton,
            errorMessageLabel
        ].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        // Configure title label with large, bold text
        titleLabel.adjustsFontForContentSizeCategory = true  // Supports accessibility text sizes
        titleLabel.textAlignment    = .center
        titleLabel.font             = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleLabel.text             = "Bankey"

        // Configure subtitle label with multi-line support
        subtitleLabel.adjustsFontForContentSizeCategory = true
        subtitleLabel.textAlignment = .center
        subtitleLabel.font          = UIFont.preferredFont(forTextStyle: .title3)
        subtitleLabel.numberOfLines = 0  // Allow multiple lines if needed
        subtitleLabel.text          = "Your premium source for all things banking!"

        // Configure sign-in button with filled style and action
        signInButton.configuration                  = .filled()
        signInButton.configuration?.imagePadding    = 8
        signInButton.setTitle("Sign In", for: [])
        signInButton.addTarget(self, action: #selector(signInTapped), for: .primaryActionTriggered)

        // Configure error message label (initially hidden)
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.textColor     = .systemRed
        errorMessageLabel.numberOfLines = 0  // Allow wrapping for longer error messages
        errorMessageLabel.isHidden      = true
    }

    /// Positions all UI elements using Auto Layout constraints.
    ///
    /// Layout structure (vertical stack):
    /// ```
    ///      [Title]
    ///      [Subtitle]
    ///      [LoginView]  ← Centered vertically
    ///      [Sign In Button]
    ///      [Error Message]
    /// ```
    ///
    /// The login view is anchored to the vertical center of the screen,
    /// with other elements positioned relative to it.
    private func layout() {
        // Add all views to the view hierarchy
        [
            titleLabel,
            subtitleLabel,
            loginView,
            signInButton,
            errorMessageLabel
        ].forEach { subView in
            view.addSubview(subView)
        }

        // Position title label at the top, centered horizontally
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 3),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        // Position subtitle below title, aligned with login view width
        NSLayoutConstraint.activate([
            loginView.topAnchor.constraint(equalToSystemSpacingBelow: subtitleLabel.bottomAnchor, multiplier: 3),
            subtitleLabel.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
        ])

        // Center login view vertically on screen with horizontal padding
        NSLayoutConstraint.activate([
            loginView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: loginView.trailingAnchor, multiplier: 2),
            view.centerYAnchor.constraint(equalTo: loginView.centerYAnchor)
        ])

        // Position sign-in button below login view
        NSLayoutConstraint.activate([
            signInButton.topAnchor.constraint(equalToSystemSpacingBelow: loginView.bottomAnchor, multiplier: 2),
            signInButton.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
        ])

        // Position error message label below sign-in button
        NSLayoutConstraint.activate([
            errorMessageLabel.topAnchor.constraint(equalToSystemSpacingBelow: signInButton.bottomAnchor, multiplier: 2),
            errorMessageLabel.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
            errorMessageLabel.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
        ])
    }
}

// MARK: - Selectors

extension LoginViewController {

    /// Handles sign-in button tap.
    ///
    /// Hides any existing error message and initiates the login process.
    ///
    /// - Parameter sender: The sign-in button that was tapped
    @objc func signInTapped(sender: UIButton) {
        // Hide any previous error messages
        errorMessageLabel.isHidden = true

        login()
    }

    /// Performs login validation and authentication.
    ///
    /// Validation steps:
    /// 1. Ensures username and password fields are not nil (assertion)
    /// 2. Checks that both fields are not empty
    /// 3. Validates credentials against hardcoded values (Kevin/123)
    ///
    /// On successful login:
    /// - Shows activity indicator on button
    /// - Notifies delegate to proceed to next screen
    ///
    /// On failure:
    /// - Displays appropriate error message
    ///
    /// TODO: Replace hardcoded credentials with real authentication service
    private func login() {
        // Ensure text fields exist (should never fail)
        guard
            let username = username,
            let password = password
        else {
            // This is a programming error, not a user error
            // Should never happen - indicates text fields weren't properly initialized
            assertionFailure("username / password should never be nil")
            return
        }

        // Check for empty fields
        if username.isEmpty || password.isEmpty {
            configureView(withMessage: "username / password cannot be blank")
            return
        }

        // Validate credentials (hardcoded for demo)
        // TODO: Replace with actual authentication API call
        if username == "Kevin" && password == "123" {
            // Show loading indicator during navigation
            signInButton.configuration?.showsActivityIndicator = true

            // Notify delegate (AppDelegate) that login succeeded
            // This triggers navigation to onboarding or main screen
            delegate?.didFinishLogIn()
        } else {
            // Show error message for invalid credentials
            configureView(withMessage: "incorrect username / password")
        }
    }

    /// Displays an error message to the user.
    ///
    /// Shows the error message label with the provided message text.
    ///
    /// - Parameter message: The error message to display
    private func configureView(withMessage message: String) {
        errorMessageLabel.isHidden  = false
        errorMessageLabel.text      = message
    }

}
