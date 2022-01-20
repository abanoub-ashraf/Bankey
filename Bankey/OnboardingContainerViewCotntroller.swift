import UIKit

class OnboardingContainerViewController: UIViewController {
    
    // MARK: - UI

    ///
    /// this contains the whole onboarding experience
    ///
    let pageViewController: UIPageViewController
    let closeButton = UIButton(type: .system)
    let backButton  = UIButton(type: .system)
    let nextButton  = UIButton(type: .system)
    let doneButton  = UIButton(type: .system)

    // MARK: - Properties

    ///
    /// this is the pages that will be displayed in the page controller
    ///
    /// the images that will go inside each page should be:
    ///     - preserved vector data (the right panel of the assets)
    ///     - single scale (the right panel of the assets)
    ///
    var pages = [UIViewController]()
    
    ///
    /// this is the current page controller that's being displayed
    ///
    /// - when the index is page - 1 which is the last page
    ///   we wanna hide the next button and show the done one
    ///
    /// - hide the back button when the index is zero
    ///
    var currentVC: UIViewController {
        didSet {
            guard let index = pages.firstIndex(of: currentVC) else { return }
            
            nextButton.isHidden = index == pages.count - 1
            backButton.isHidden = index == 0
            doneButton.isHidden = !(index == pages.count - 1)
        }
    }
    
    weak var delgate: OnboardingContainerViewControllerDelegate?

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
        let page1 = OnBoardingViewController(
            heroImageName: AppConstants.deloreanImageName,
            titleText: AppConstants.onboardingDeloreanLabel
        )
        
        let page2 = OnBoardingViewController(
            heroImageName: AppConstants.worldImageName,
            titleText: AppConstants.onboardingWorldLabel
        )
        
        let page3 = OnBoardingViewController(
            heroImageName: AppConstants.thumbsImageName,
            titleText: AppConstants.onboardingThumbsLabel
        )
        
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
        
        setup()
        style()
        layout()
    }
    
    // MARK: - Helper Functions

    private func setup() {
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
    
    private func style() {
        view.backgroundColor = .systemPurple
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        [closeButton, nextButton, backButton, doneButton].forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        closeButton.setTitle("Close", for: [])
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .primaryActionTriggered)
        
        nextButton.setTitle("Next", for: [])
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .primaryActionTriggered)
        
        backButton.setTitle("Back", for: [])
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .primaryActionTriggered)
        
        doneButton.setTitle("Done", for: [])
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .primaryActionTriggered)
    }
    
    private func layout() {
        [closeButton, doneButton, backButton, nextButton].forEach { subView in
            view.addSubview(subView)
        }
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: pageViewController.view.topAnchor),
            view.leadingAnchor.constraint(equalTo: pageViewController.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: pageViewController.view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: pageViewController.view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: nextButton.trailingAnchor, multiplier: 2),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: nextButton.bottomAnchor, multiplier: 4)
        ])
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: backButton.bottomAnchor, multiplier: 4)
        ])
        
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            closeButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2)
        ])
        
        NSLayoutConstraint.activate([
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: doneButton.trailingAnchor, multiplier: 2),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: doneButton.bottomAnchor, multiplier: 4)
        ])
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
        
        self.currentVC = pages[index - 1]
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
        
        self.currentVC = pages[index + 1]
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

// MARK: - Selectors

extension OnboardingContainerViewController {
    
    @objc private func nextButtonTapped(sender: UIButton) {
        guard let nextVC = getNextViewController(from: currentVC) else { return }

        pageViewController.setViewControllers(
            [nextVC],
            direction: .forward,
            animated: true,
            completion: nil
        )
    }
    
    @objc private func backButtonTapped(sender: UIButton) {
        guard let previousVC = getPreviousViewController(from: currentVC) else { return }

        pageViewController.setViewControllers(
            [previousVC],
            direction: .reverse,
            animated: true,
            completion: nil
        )
    }
    
    @objc private func closeButtonTapped(sender: UIButton) {
        self.delgate?.didFinishOnboarding()
    }
    
    @objc private func doneButtonTapped(sender: UIButton) {
        self.delgate?.didFinishOnboarding()
    }
    
}
