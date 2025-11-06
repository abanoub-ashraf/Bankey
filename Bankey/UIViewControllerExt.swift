import UIKit

/// Extension adding utility methods to UIViewController.
///
/// Provides reusable methods for common view controller tasks:
/// - Configuring the status bar appearance
/// - Setting up tab bar items with SF Symbols
extension UIViewController {

    /// Adds a colored status bar view at the top of the screen.
    ///
    /// This creates a view matching the status bar's size and adds it to
    /// the view hierarchy with the app's main color. This is useful for
    /// maintaining consistent color across the status bar area.
    ///
    /// Note: In modern iOS, this approach may be replaced by UINavigationBar
    /// styling or other appearance APIs depending on your needs.
    func setStatusBar() {
        // Get the current status bar frame (includes notch on modern devices)
        let statusBarSize   = UIApplication.shared.statusBarFrame.size
        let frame           = CGRect(origin: .zero, size: statusBarSize)
        let statusBarView   = UIView(frame: frame)

        // Apply main app color to status bar area
        statusBarView.backgroundColor = AppColors.mainColor
        view.addSubview(statusBarView)
    }

    /// Configures the tab bar item with an SF Symbol icon and title.
    ///
    /// Creates a tab bar item with:
    /// - Large-scale SF Symbol icon
    /// - Title text
    /// - Default tag of 0
    ///
    /// This provides a convenient way to set up tab bar items without
    /// manually creating UIImage and UITabBarItem instances.
    ///
    /// Example usage:
    /// ```
    /// summaryVC.setTabBarImage(imageName: "list.dash", title: "Summary")
    /// ```
    ///
    /// - Parameters:
    ///   - imageName: The SF Symbol name (e.g., "list.dash.header.rectangle")
    ///   - title: The text to display below the icon
    func setTabBarImage(imageName: String, title: String) {
        // Create large-scale configuration for prominent icons
        let configuration   = UIImage.SymbolConfiguration(scale: .large)
        let image           = UIImage(systemName: imageName, withConfiguration: configuration)

        // Create and assign the tab bar item
        tabBarItem          = UITabBarItem(title: title, image: image, tag: 0)
    }
}
