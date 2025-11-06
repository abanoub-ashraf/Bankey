import UIKit

/// A container view controller that manages the onboarding flow using a UIPageViewController.
///
/// This controller presents a three-page onboarding experience with:
/// - Swipe-able pages showing different feature highlights
/// - Navigation buttons (Back/Next) that appear contextually
/// - A Done button on the final page to complete onboarding
/// - A Close button to skip onboarding at any time
///
/// The page controller uses a scroll transition style for smooth horizontal navigation.
class OnboardingContainerViewController: UIViewController {

    // MARK: - UI

    /// The page view controller that manages the swipe-able onboarding pages.
    /// Configured with horizontal scroll transition for a native feel.
    let pageViewController: UIPageViewController

    /// Button to skip/close the onboarding flow at any time (top-left)
    let closeButton = UIButton(type: .system)

    /// Button to navigate to the previous page (bottom-left, hidden on first page)
    let backButton  = UIButton(type: .system)

    /// Button to navigate to the next page (bottom-right, hidden on last page)
    let nextButton  = UIButton(type: .system)

    /// Button to complete onboarding (bottom-right, shown only on last page)
    let doneButton  = UIButton(type: .system)

    // MARK: - Properties

    /// Array of view controllers representing each onboarding page (3 pages total).
    ///
    /// Each page is an OnBoardingViewController with a hero image and descriptive text.
    /// Image requirements for best quality:
    /// - Preserved vector data (SVG/PDF in Assets)
    /// - Single scale (not @2x/@3x variants)
    var pages = [UIViewController]()

    /// The currently displayed view controller in the page view controller.
    ///
    /// This property has a didSet observer that automatically shows/hides navigation buttons
    /// based on the current page index:
    /// - First page (index 0): Hide Back button, show Next button
    /// - Middle pages: Show both Back and Next buttons
    /// - Last page: Hide Next button, show Done button instead
    ///
    /// This creates an intuitive navigation experience where users always see the right options.
    var currentVC: UIViewController {
        didSet {
            // Find the index of the current page in our pages array
            guard let index = pages.firstIndex(of: currentVC) else { return }

            // Hide Next button on last page, show Done instead
            nextButton.isHidden = index == pages.count - 1
            // Hide Back button on first page
            backButton.isHidden = index == 0
            // Show Done button only on last page
            doneButton.isHidden = !(index == pages.count - 1)
        }
    }

    /// Delegate to notify when onboarding is completed (via Done or Close buttons)
    weak var delgate: OnboardingContainerViewControllerDelegate?

    // MARK: - Initializer

    /// Initializes the onboarding container with a page view controller and three onboarding pages.
    ///
    /// This initializer:
    /// 1. Creates the page view controller with horizontal scroll transitions
    /// 2. Creates three onboarding pages with different hero images and messages
    /// 3. Sets up the pages array with these view controllers
    /// 4. Sets the first page as the initial current view controller
    ///
    /// - Parameters:
    ///   - nibNameOrNil: Optional nib name (not used, controller is code-based)
    ///   - nibBundleOrNil: Optional bundle (not used, controller is code-based)
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        // Create the page view controller with horizontal scrolling
        // .scroll provides a native, smooth page-turning experience
        self.pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )

        // Create the three onboarding pages, each with a unique hero image and message
        // Page 1: DeLorean - Represents speed/time (banking theme)
        let page1 = OnBoardingViewController(
            heroImageName: AppConstants.deloreanImageName,
            titleText: AppConstants.onboardingDeloreanLabel
        )

        // Page 2: World - Represents global access/reach
        let page2 = OnBoardingViewController(
            heroImageName: AppConstants.worldImageName,
            titleText: AppConstants.onboardingWorldLabel
        )

        // Page 3: Thumbs up - Represents approval/success
        let page3 = OnBoardingViewController(
            heroImageName: AppConstants.thumbsImageName,
            titleText: AppConstants.onboardingThumbsLabel
        )

        // Populate the pages array with our three onboarding pages
        // The order matters - this is the sequence users will see
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)

        // Set the first page as the initial current page
        // This triggers the didSet observer to configure button visibility
        currentVC = pages.first!

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    /// Required initializer for loading from Interface Builder.
    /// This controller is code-based, so this initializer is not supported.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle

    /// Called when the view controller's view is loaded into memory.
    ///
    /// Orchestrates the setup process in three stages:
    /// 1. setup() - Configures the page view controller and child relationships
    /// 2. style() - Applies visual styling to buttons and views
    /// 3. layout() - Positions all UI elements using Auto Layout
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        style()
        layout()
    }

    // MARK: - Helper Functions

    /// Sets up the page view controller hierarchy and data source.
    ///
    /// This method follows Apple's three-step process for adding child view controllers:
    /// 1. addChild() - Establishes parent-child relationship in the controller hierarchy
    /// 2. addSubview() - Adds the child's view to the parent's view hierarchy
    /// 3. didMove(toParent:) - Notifies the child that it has moved to a parent
    ///
    /// Also configures this controller as the page view controller's data source,
    /// allowing us to control page navigation and provide the initial page.
    private func setup() {
        // Step 1: Add page view controller as a child in the controller hierarchy
        addChild(pageViewController)
        // Step 2: Add its view to our view hierarchy
        view.addSubview(pageViewController.view)
        // Step 3: Notify it that the move is complete
        pageViewController.didMove(toParent: self)

        // Set this controller as the data source for page navigation
        // We implement UIPageViewControllerDataSource to provide prev/next pages
        pageViewController.dataSource = self

        // Set the initial page to display (the first onboarding page)
        // Direction: .forward (though doesn't matter for initial setup)
        // Animated: false (no animation on initial load)
        pageViewController.setViewControllers(
            [pages.first!],
            direction: .forward,
            animated: false,
            completion: nil
        )

        // Set currentVC to trigger button visibility logic via didSet observer
        currentVC = pages.first!
    }
    
    /// Applies visual styling to all UI elements.
    ///
    /// This method:
    /// 1. Sets the background color for the container view
    /// 2. Disables autoresizing masks to use Auto Layout
    /// 3. Configures button titles and actions
    ///
    /// All buttons use .primaryActionTriggered for accessibility support.
    private func style() {
        // Purple background provides visual distinction from other screens
        view.backgroundColor = .systemPurple

        // Disable autoresizing mask translation for Auto Layout
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false

        // Disable autoresizing masks for all navigation buttons
        [closeButton, nextButton, backButton, doneButton].forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
        }

        // Configure Close button (top-left, skips onboarding)
        closeButton.setTitle("Close", for: [])
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .primaryActionTriggered)

        // Configure Next button (bottom-right, advances to next page)
        nextButton.setTitle("Next", for: [])
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .primaryActionTriggered)

        // Configure Back button (bottom-left, returns to previous page)
        backButton.setTitle("Back", for: [])
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .primaryActionTriggered)

        // Configure Done button (bottom-right on last page, completes onboarding)
        doneButton.setTitle("Done", for: [])
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .primaryActionTriggered)
    }
    
    /// Positions all UI elements using Auto Layout constraints.
    ///
    /// Layout structure:
    /// ```
    /// ┌─────────────────────────────┐
    /// │ [Close]                     │ ← Top-left
    /// │                             │
    /// │    Page View Controller     │ ← Fills entire view
    /// │                             │
    /// │ [Back]          [Next/Done] │ ← Bottom corners
    /// └─────────────────────────────┘
    /// ```
    ///
    /// Uses system spacing multipliers for consistent margins:
    /// - Horizontal edges: 2x system spacing (~16pts)
    /// - Vertical edges: 4x system spacing (~32pts) for bottom buttons
    /// - Vertical edges: 2x system spacing (~16pts) for top close button
    private func layout() {
        // Add all buttons to the view hierarchy
        [closeButton, doneButton, backButton, nextButton].forEach { subView in
            view.addSubview(subView)
        }

        // Pin page view controller to fill the entire container view
        // This allows the onboarding pages to take up all available space
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: pageViewController.view.topAnchor),
            view.leadingAnchor.constraint(equalTo: pageViewController.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: pageViewController.view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: pageViewController.view.bottomAnchor)
        ])

        // Position Next button at bottom-right corner
        // System spacing multiplier: 2x horizontal, 4x vertical for comfortable tap area
        NSLayoutConstraint.activate([
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: nextButton.trailingAnchor, multiplier: 2),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: nextButton.bottomAnchor, multiplier: 4)
        ])

        // Position Back button at bottom-left corner
        // Mirrors Next button's spacing for visual balance
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: backButton.bottomAnchor, multiplier: 4)
        ])

        // Position Close button at top-left corner
        // Uses safe area to avoid notch/status bar on modern devices
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            closeButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2)
        ])

        // Position Done button at bottom-right corner (same as Next button)
        // Done button is shown/hidden based on page index via currentVC's didSet
        NSLayoutConstraint.activate([
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: doneButton.trailingAnchor, multiplier: 2),
            view.bottomAnchor.constraint(equalToSystemSpacingBelow: doneButton.bottomAnchor, multiplier: 4)
        ])
    }
    
}

// MARK: - UIPageViewControllerDataSource

/// Extension conforming to UIPageViewControllerDataSource protocol.
///
/// This protocol provides the page view controller with the view controllers to display
/// when the user swipes left/right. It also provides presentation count and index for
/// the page indicator dots at the bottom of the screen.
extension OnboardingContainerViewController: UIPageViewControllerDataSource {

    /// Called when the user swipes to go to the previous page (swipe right).
    ///
    /// This method is called by the page view controller when the user performs a
    /// right-to-left swipe gesture, requesting the view controller to show before
    /// the current one.
    ///
    /// - Parameters:
    ///   - pageViewController: The page view controller requesting the page
    ///   - viewController: The currently displayed view controller
    /// - Returns: The previous view controller, or nil if already at the first page
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        return getPreviousViewController(from: viewController)
    }

    /// Called when the user swipes to go to the next page (swipe left).
    ///
    /// This method is called by the page view controller when the user performs a
    /// right-to-left swipe gesture, requesting the view controller to show after
    /// the current one.
    ///
    /// - Parameters:
    ///   - pageViewController: The page view controller requesting the page
    ///   - viewController: The currently displayed view controller
    /// - Returns: The next view controller, or nil if already at the last page
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        return getNextViewController(from: viewController)
    }

    /// Returns the previous view controller in the pages array.
    ///
    /// Performs bounds checking to ensure we don't go before the first page.
    /// Updates currentVC when successful, which triggers button visibility updates.
    ///
    /// - Parameter viewController: The currently displayed view controller
    /// - Returns: The previous page, or nil if at the first page (index 0)
    private func getPreviousViewController(from viewController: UIViewController) -> UIViewController? {
        // Find the current page's index and verify we can go back
        guard
            let index = pages.firstIndex(of: viewController),
            index - 1 >= 0  // Ensure we're not already at the first page
        else {
            return nil
        }

        // Update currentVC which triggers button visibility logic via didSet
        self.currentVC = pages[index - 1]
        return pages[index - 1]
    }

    /// Returns the next view controller in the pages array.
    ///
    /// Performs bounds checking to ensure we don't go beyond the last page.
    /// Updates currentVC when successful, which triggers button visibility updates.
    ///
    /// - Parameter viewController: The currently displayed view controller
    /// - Returns: The next page, or nil if at the last page
    private func getNextViewController(from viewController: UIViewController) -> UIViewController? {
        // Find the current page's index and verify we can go forward
        guard
            let index = pages.firstIndex(of: viewController),
            index + 1 < pages.count  // Ensure we're not already at the last page
        else {
            return nil
        }

        // Update currentVC which triggers button visibility logic via didSet
        self.currentVC = pages[index + 1]
        return pages[index + 1]
    }

    /// Returns the total number of pages for the page indicator dots.
    ///
    /// This creates the small dot indicators at the bottom of the page view controller
    /// showing the total number of pages available.
    ///
    /// - Parameter pageViewController: The page view controller requesting the count
    /// - Returns: Total number of pages (3 in this case)
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    /// Returns the current page index for the page indicator dots.
    ///
    /// This highlights the appropriate dot in the page indicator to show which
    /// page is currently being displayed.
    ///
    /// - Parameter pageViewController: The page view controller requesting the index
    /// - Returns: The index of the currently displayed page (0-based)
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return pages.firstIndex(of: self.currentVC) ?? 0
    }
}

// MARK: - Selectors

/// Extension containing action handlers for button taps.
///
/// All methods are marked @objc to be compatible with UIButton's target-action pattern.
extension OnboardingContainerViewController {

    /// Handles Next button tap to advance to the next onboarding page.
    ///
    /// This method:
    /// 1. Gets the next view controller from the pages array
    /// 2. Tells the page view controller to display it with forward animation
    /// 3. Updates currentVC (via getNextViewController), triggering button visibility logic
    ///
    /// If already on the last page, getNextViewController returns nil and nothing happens
    /// (though the Next button should be hidden on the last page anyway).
    ///
    /// - Parameter sender: The Next button that was tapped
    @objc private func nextButtonTapped(sender: UIButton) {
        // Get the next page, bail out if we're already at the end
        guard let nextVC = getNextViewController(from: currentVC) else { return }

        // Animate to the next page with forward (left-to-right) transition
        pageViewController.setViewControllers(
            [nextVC],
            direction: .forward,
            animated: true,
            completion: nil
        )
    }

    /// Handles Back button tap to return to the previous onboarding page.
    ///
    /// This method:
    /// 1. Gets the previous view controller from the pages array
    /// 2. Tells the page view controller to display it with reverse animation
    /// 3. Updates currentVC (via getPreviousViewController), triggering button visibility logic
    ///
    /// If already on the first page, getPreviousViewController returns nil and nothing happens
    /// (though the Back button should be hidden on the first page anyway).
    ///
    /// - Parameter sender: The Back button that was tapped
    @objc private func backButtonTapped(sender: UIButton) {
        // Get the previous page, bail out if we're already at the beginning
        guard let previousVC = getPreviousViewController(from: currentVC) else { return }

        // Animate to the previous page with reverse (right-to-left) transition
        pageViewController.setViewControllers(
            [previousVC],
            direction: .reverse,
            animated: true,
            completion: nil
        )
    }

    /// Handles Close button tap to skip the onboarding flow.
    ///
    /// Notifies the delegate (AppDelegate) that onboarding is finished, even though
    /// the user didn't complete all pages. This allows users to skip onboarding and
    /// go directly to the main app interface.
    ///
    /// - Parameter sender: The Close button that was tapped
    @objc private func closeButtonTapped(sender: UIButton) {
        self.delgate?.didFinishOnboarding()
    }

    /// Handles Done button tap to complete the onboarding flow.
    ///
    /// Notifies the delegate (AppDelegate) that onboarding is finished. This button
    /// only appears on the last page, indicating the user has viewed all onboarding
    /// content and is ready to proceed to the main app.
    ///
    /// - Parameter sender: The Done button that was tapped
    @objc private func doneButtonTapped(sender: UIButton) {
        self.delgate?.didFinishOnboarding()
    }

}
