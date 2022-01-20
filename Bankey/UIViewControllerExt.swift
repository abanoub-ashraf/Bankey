import UIKit

extension UIViewController {
    
    func setStatusBar() {
        let statusBarSize   = UIApplication.shared.statusBarFrame.size
        let frame           = CGRect(origin: .zero, size: statusBarSize)
        let statusBarView   = UIView(frame: frame)
        
        statusBarView.backgroundColor = AppColors.mainColor
        view.addSubview(statusBarView)
    }
    
    ///
    /// configure the image of each tab bar item
    ///
    func setTabBarImage(imageName: String, title: String) {
        let configuration   = UIImage.SymbolConfiguration(scale: .large)
        let image           = UIImage(systemName: imageName, withConfiguration: configuration)
        tabBarItem          = UITabBarItem(title: title, image: image, tag: 0)
    }
}
