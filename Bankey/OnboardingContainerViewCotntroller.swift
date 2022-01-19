import UIKit

class OnboardingContainerViewController: UIViewController {
    
    // MARK: - UI

    ///
    /// this contains the whole onboarding experience
    ///
    let pageViewController: UIPageViewController

    // MARK: - Properties

    ///
    /// this is the pages that will be displayed in the page controller
    ///
    var pages = [UIViewController]()
    
    ///
    /// this is the current page controller that's being displayed
    ///
    var currentVC: UIViewController {
        didSet {
            
        }
    }

    // MARK: - Initializer

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        ///
        /// instantiate the page controller
        ///
        self.pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
                
        ///
        /// instantiate the pages that will go in the page controller
        ///
        let page1 = PageOneViewController()
        let page2 = PageTwoViewController()
        let page3 = PageThreeViewController()
        
        ///
        /// add the pages to the pages array of the page controller
        ///
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        ///
        /// set the first page as the current page
        ///
        currentVC = pages.first!
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemPurple
        
        ///
        /// - these three steps are for adding a child view controller
        ///   to a parent view controller
        ///
        /// - first add the child, then add its view, then move it to the parent
        ///
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        ///
        /// this means we are gonna be the source of data to this page controller
        ///
        pageViewController.dataSource = self
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: pageViewController.view.topAnchor),
            view.leadingAnchor.constraint(equalTo: pageViewController.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: pageViewController.view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: pageViewController.view.bottomAnchor)
        ])
        
        ///
        /// set the view controllers of the page controller
        ///
        pageViewController.setViewControllers(
            [pages.first!],
            direction: .forward,
            animated: false,
            completion: nil
        )
        
        ///
        /// set the first page as the current vc when this screen loads
        ///
        currentVC = pages.first!
    }
    
}

// MARK: - UIPageViewControllerDataSource

extension OnboardingContainerViewController: UIPageViewControllerDataSource {
    
    ///
    /// what should happen when we go to the previous page of the page controller
    ///
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        return getPreviousViewController(from: viewController)
    }
    
    ///
    /// what should happen when we go to the next page of the page controller
    ///
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        return getNextViewController(from: viewController)
    }
            
    ///
    /// get the previous page in the page controller
    ///
    private func getPreviousViewController(from viewController: UIViewController) -> UIViewController? {
        ///
        /// get the index of the current vc and if that index - 1 is less than 0 then stop
        /// else, get the page of that new index (the previous page)
        ///
        guard
            let index = pages.firstIndex(of: viewController),
            index - 1 >= 0
        else {
            return nil
        }
        
        currentVC = pages[index - 1]
        return pages[index - 1]
    }
    
    ///
    /// get the next page in the page controller
    ///
    private func getNextViewController(from viewController: UIViewController) -> UIViewController? {
        ///
        /// get the index of the current vc and if that index + 1 is less than the total pages count
        /// then stop, else, get the page of that new index (the next page)
        ///
        guard
            let index = pages.firstIndex(of: viewController),
            index + 1 < pages.count
        else {
            return nil
        }
        
        currentVC = pages[index + 1]
        return pages[index + 1]
    }
    
    ///
    /// get the count of the pages in the page controller
    ///
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    ///
    /// get the current index of the currently page controller displayed
    ///
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return pages.firstIndex(of: self.currentVC) ?? 0
    }
}
