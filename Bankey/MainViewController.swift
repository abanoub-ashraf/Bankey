import UIKit

/// The main tab bar controller that hosts the app's primary interface.
///
/// This controller manages three tabs:
/// 1. Account Summary (Teal) - Shows user's accounts and balances
/// 2. Move Money (Yellow) - For transferring funds between accounts
/// 3. More (Purple) - Additional features and settings
///
/// Each tab is wrapped in its own UINavigationController for independent navigation.
class MainViewController: UITabBarController {

    // MARK: - LifeCycle

    /// Called when the view controller's view is loaded into memory.
    ///
    /// Sets up the tab bar structure and configures the tab bar appearance.
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupTabBar()
    }
    
    // MARK: - Helper Functions

    /// Sets up the three main tab bar view controllers and configures their appearance.
    ///
    /// This method:
    /// 1. Creates the three main view controllers for each tab
    /// 2. Configures their tab bar items (icons and titles)
    /// 3. Wraps each in a UINavigationController for navigation support
    /// 4. Customizes navigation bar colors for each tab
    /// 5. Hides the navigation bar border line on the summary tab
    private func setupViews() {
        // Create the three main view controllers that will be displayed in tabs
        let summaryVC   = AccountSummaryViewController()
        let moneyVC     = MoveMoneyViewController()
        let moreVC      = MoreViewController()

        // Configure the tab bar item (icon and title) for each view controller
        // Uses centralized image names from AppConstants for consistency
        summaryVC.setTabBarImage(imageName: AppConstants.summaryImageName, title: "Summary")
        moneyVC.setTabBarImage(imageName: AppConstants.moneyImageName, title: "Move Money")
        moreVC.setTabBarImage(imageName: AppConstants.moreImageName, title: "More")

        // Wrap each view controller in a navigation controller
        // This allows each tab to have its own navigation stack for pushing/popping screens
        let summaryNC   = UINavigationController(rootViewController: summaryVC)
        let moneyNC     = UINavigationController(rootViewController: moneyVC)
        let moreNC      = UINavigationController(rootViewController: moreVC)

        // Color-code the navigation bars to visually distinguish each tab
        summaryNC.navigationBar.barTintColor    = AppColors.mainColor  // Teal - main app color
        moneyNC.navigationBar.barTintColor      = .yellow              // Yellow - money/financial
        moreNC.navigationBar.barTintColor       = .purple              // Purple - additional features

        // Remove the default navigation bar border line on the summary tab
        // This creates a cleaner, more seamless look for the main screen
        hideNavigationBarLine(summaryNC.navigationBar)

        // Set the navigation controllers as the tab bar's view controllers
        // The order here determines the tab order: Summary, Move Money, More
        viewControllers = [summaryNC, moneyNC, moreNC]
    }
    
    /// Removes the default border line from the navigation bar.
    ///
    /// iOS displays a subtle shadow line at the bottom of navigation bars by default.
    /// This method removes that line for a cleaner, more modern appearance.
    ///
    /// The technique works by:
    /// 1. Creating an empty UIImage
    /// 2. Setting it as both the background and shadow image
    /// 3. Disabling translucency to ensure solid colors
    ///
    /// - Parameter navigationBar: The navigation bar to modify
    private func hideNavigationBarLine(_ navigationBar: UINavigationBar) {
        // Create an empty image to use as a placeholder
        let image = UIImage()

        // Replace the default background and shadow with empty images
        navigationBar.setBackgroundImage(image, for: .default)
        navigationBar.shadowImage   = image
        navigationBar.isTranslucent = false
    }

    /// Configures the appearance of the tab bar at the bottom of the screen.
    ///
    /// Sets the tint color (color of selected tab icons) to match the app's
    /// main color and disables translucency for a solid appearance.
    private func setupTabBar() {
        tabBar.tintColor        = AppColors.mainColor  // Selected tab color
        tabBar.isTranslucent    = false                // Solid background, not transparent
    }
    
}
