import UIKit

/// Placeholder view controller for the "More" tab.
///
/// This controller represents the third tab in the main tab bar interface,
/// intended for additional features and settings.
///
/// Currently displays only a colored background as a placeholder.
/// In a full implementation, this would include:
/// - User settings
/// - Account preferences
/// - Help and support
/// - About information
/// - Additional banking features
class MoreViewController: UIViewController {

    // MARK: - LifeCycle

    /// Called when the view controller's view is loaded into memory.
    ///
    /// Sets the background color to purple to distinguish this tab
    /// from others during development.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Purple background matches this tab's navigation bar color
        view.backgroundColor = .systemPurple
    }

}
