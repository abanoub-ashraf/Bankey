import UIKit

/// A single onboarding page view controller displaying a hero image and descriptive text.
///
/// This controller is reused three times in the onboarding flow, each with different
/// content (image and text). The pages are managed by OnboardingContainerViewController
/// using a UIPageViewController.
///
/// Layout:
/// ```
/// ┌────────────────────┐
/// │                    │
/// │   [Hero Image]     │ ← Centered vertically
/// │                    │
/// │   Descriptive      │
/// │   Text Label       │
/// │                    │
/// └────────────────────┘
/// ```
class OnBoardingViewController: UIViewController {

    // MARK: - UI

    /// Stack view containing the image and label in vertical layout
    let stackView   = UIStackView()

    /// Image view displaying the onboarding hero image
    let imageView   = UIImageView()

    /// Label displaying the onboarding message/description
    let label       = UILabel()

    // MARK: - Properties

    /// Name of the hero image asset to display
    let heroImageName: String

    /// Text message to display below the image
    let titleText: String

    // MARK: - Initializer

    /// Initializes the onboarding page with specific content.
    ///
    /// Image requirements for best quality:
    /// - Assets should preserve vector data (SVG/PDF format)
    /// - Assets should be single scale (not @2x/@3x variants)
    ///
    /// - Parameters:
    ///   - heroImageName: The asset name for the hero image
    ///   - titleText: The descriptive text to display
    init(heroImageName: String, titleText: String) {
        self.heroImageName  = heroImageName
        self.titleText      = titleText

        super.init(nibName: nil, bundle: nil)
    }

    /// Required initializer for Interface Builder (not supported).
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    /// Called when the view controller's view is loaded into memory.
    ///
    /// Sets up styling and layout for the onboarding page.
    override func viewDidLoad() {
        super.viewDidLoad()

        style()
        layout()
    }

}

extension OnBoardingViewController {

    /// Applies visual styling to all UI elements.
    ///
    /// Configures:
    /// - System background color (adapts to light/dark mode)
    /// - Vertical stack layout with spacing
    /// - Image view with aspect-fit scaling
    /// - Multi-line label with dynamic type support
    private func style() {
        // Use system background to support light/dark mode
        view.backgroundColor = .systemBackground

        // Configure stack view for vertical layout
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis      = .vertical
        stackView.spacing   = 20  // Space between image and text

        // Configure hero image view
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode   = .scaleAspectFit  // Maintains aspect ratio
        imageView.image         = UIImage(named: heroImageName)

        // Configure descriptive text label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment                     = .center
        label.font                              = UIFont.preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true  // Supports accessibility text sizes
        label.numberOfLines                     = 0     // Allow text wrapping
        label.text                              = titleText
    }

    /// Positions all UI elements using Auto Layout constraints.
    ///
    /// The stack view is centered both horizontally and vertically,
    /// with horizontal margins for padding. The stack view automatically
    /// manages the layout of the image and label.
    private func layout() {
        // Add image and label to stack in vertical order
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)

        // Add stack view to the view hierarchy
        view.addSubview(stackView)

        // Center stack view and add horizontal padding
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 1)
        ])
    }

}
