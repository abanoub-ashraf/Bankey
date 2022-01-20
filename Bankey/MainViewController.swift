import UIKit

class MainViewController: UITabBarController {
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupTabBar()
    }
    
    // MARK: - Helper Functions

    private func setupViews() {
        ///
        /// the view controllers that will go in the tab bar controller
        ///
        let summaryVC   = AccountSummaryViewController()
        let moneyVC     = MoveMoneyViewController()
        let moreVC      = MoreViewController()
        
        ///
        /// configure the image tab bar item for each controller of them
        ///
        summaryVC.setTabBarImage(imageName: AppConstants.summaryImageName, title: "Summary")
        moneyVC.setTabBarImage(imageName: AppConstants.moneyImageName, title: "Move Money")
        moreVC.setTabBarImage(imageName: AppConstants.moreImageName, title: "More")
        
        ///
        /// put each controller of them inside a navigation controller
        ///
        let summaryNC   = UINavigationController(rootViewController: summaryVC)
        let moneyNC     = UINavigationController(rootViewController: moneyVC)
        let moreNC      = UINavigationController(rootViewController: moreVC)
        
        summaryNC.navigationBar.barTintColor    = AppColors.mainColor
        moneyNC.navigationBar.barTintColor      = .yellow
        moreNC.navigationBar.barTintColor       = .purple
        
        ///
        /// hide the horizontal border line of the navigation bar area that shows up by default
        /// but in the summary vc navigation bar only
        ///
        hideNavigationBarLine(summaryNC.navigationBar)
        
        ///
        /// set the 3 nav controllers above to be the controllers of the tab bar controller
        ///
        viewControllers = [summaryNC, moneyNC, moreNC]
    }
    
    ///
    /// hide the border line of the navigation bar area that shows up by default
    ///
    private func hideNavigationBarLine(_ navigationBar: UINavigationBar) {
        let image = UIImage()
        
        navigationBar.setBackgroundImage(image, for: .default)
        navigationBar.shadowImage   = image
        navigationBar.isTranslucent = false
    }
    
    ///
    /// configure the tab bar
    ///
    private func setupTabBar() {
        tabBar.tintColor        = AppColors.mainColor
        tabBar.isTranslucent    = false
    }
    
}
