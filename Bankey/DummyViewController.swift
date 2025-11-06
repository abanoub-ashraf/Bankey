import UIKit

/// A placeholder view controller with a welcome message and logout button.
///
/// This controller serves as a simple landing screen after login, providing
/// a logout option to return to the login screen. In a full app, this would
/// be replaced with actual content.
///
/// Currently used for testing the logout functionality and app navigation flow.
class DummyViewController: UIViewController {

    // MARK: - UI

    /// Stack view containing the label and button in vertical layout
    let stackView       = UIStackView()

    /// Label displaying welcome message
    let label           = UILabel()

    /// Button to trigger logout
    let logoutButton    = UIButton(type: .system)

    // MARK: - Properties

    /// Delegate to handle logout action (AppDelegate implements this)
    weak var logoutDelegate: LogoutDelegate?

    // MARK: - LifeCycle

    /// Called when the view controller's view is loaded into memory.
    ///
    /// Sets up styling and layout for the welcome screen.
    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        layout()
    }

}

// MARK: - Helper Functions

extension DummyViewController {

    /// Applies visual styling to all UI elements.
    ///
    /// Configures:
    /// - Vertical stack layout
    /// - Welcome label with large title font
    /// - Filled logout button with action
    private func style() {
        // Configure stack view for vertical layout
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis      = .vertical
        stackView.spacing   = 20

        // Configure welcome label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome"
        label.font = UIFont.preferredFont(forTextStyle: .title1)

        // Configure logout button
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.configuration = .filled()
        logoutButton.setTitle("Logout", for: [])
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .primaryActionTriggered)
    }

    /// Positions all UI elements using Auto Layout constraints.
    ///
    /// Centers the stack view (containing label and button) on the screen.
    private func layout() {
        // Add label and button to stack
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(logoutButton)

        view.addSubview(stackView)

        // Center the stack view on the screen
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

}

// MARK: - Selectors

extension DummyViewController {

    /// Handles logout button tap.
    ///
    /// Notifies the delegate (AppDelegate) to perform logout and return to login screen.
    ///
    /// - Parameter sender: The logout button that was tapped
    @objc private func logoutButtonTapped(sender: UIButton) {
        logoutDelegate?.didLogout()
    }

}
