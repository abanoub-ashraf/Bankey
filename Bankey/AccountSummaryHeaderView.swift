import UIKit

/// A custom header view for the account summary table, loaded from a XIB file.
///
/// This view displays user information, date, and greeting at the top of the
/// account list. The layout and content are defined in AccountSummaryHeaderView.xib.
///
/// Key features:
/// - XIB-based design for visual editing
/// - Custom intrinsic height (144pt)
/// - Width determined by parent (table view)
class AccountSummaryHeaderView: UIView {

    // MARK: - UI

    /// The content view loaded from the XIB file
    /// Connected via Interface Builder outlet
    @IBOutlet var contentView: UIView!

    // MARK: - Properties

    /// The natural size for the header view.
    ///
    /// - Width: UIView.noIntrinsicMetric (parent determines width)
    /// - Height: 144pt (fixed height for consistent appearance)
    ///
    /// This allows the parent (AccountSummaryViewController) to set the width
    /// while the header controls its own height. Used in conjunction with
    /// systemLayoutSizeFitting() for proper sizing.
    override var intrinsicContentSize: CGSize {
        return CGSize(
            width: UIView.noIntrinsicMetric,  // Parent determines width
            height: 144                       // Fixed height
        )
    }

    // MARK: - Initializer

    /// Initializes the header view programmatically.
    ///
    /// Loads the XIB file and sets up the view hierarchy.
    ///
    /// - Parameter frame: The initial frame rectangle
    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    /// Required initializer for Interface Builder (not supported).
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Helper Functions

    /// Loads the XIB file and initializes the view.
    ///
    /// This method:
    /// 1. Locates the XIB file in the bundle
    /// 2. Loads the XIB with this view as the owner
    /// 3. Applies styling and layout
    ///
    /// The XIB file must be named "AccountSummaryHeaderView.xib" and must
    /// have its File's Owner set to AccountSummaryHeaderView class.
    private func commonInit() {
        // Get the bundle containing this class
        let bundle = Bundle(for: AccountSummaryHeaderView.self)

        // Load the XIB file
        // - owner: self means this view is the File's Owner in the XIB
        // - This connects the @IBOutlet contentView property
        bundle.loadNibNamed(
            String(describing: AccountSummaryHeaderView.self),
            owner: self,
            options: nil
        )

        style()
        layout()
    }

    /// Applies visual styling to the content view.
    ///
    /// Sets the background color to match the app's main teal color.
    private func style() {
        contentView.backgroundColor = AppColors.mainColor
    }

    /// Positions the content view to fill the entire header view.
    ///
    /// Pins all edges of the content view to the header view's edges,
    /// ensuring the XIB content fills the entire header area.
    private func layout() {
        addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false

        // Pin content view to all edges
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

}
