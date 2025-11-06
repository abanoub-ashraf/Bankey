import UIKit

/// Placeholder view controller for the "Move Money" tab.
///
/// This controller represents the second tab in the main tab bar interface,
/// intended for money transfer and transaction features.
///
/// Currently displays only a colored background as a placeholder.
/// In a full implementation, this would include:
/// - Transfer forms
/// - Recipient selection
/// - Transaction history
/// - Payment scheduling
class MoveMoneyViewController: UIViewController {

    // MARK: - LifeCycle

    /// Called when the view controller's view is loaded into memory.
    ///
    /// Sets the background color to orange to distinguish this tab
    /// from others during development.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Orange background matches this tab's navigation bar color
        view.backgroundColor = .systemOrange
    }

}
