import UIKit

/// A custom table view cell that displays account information with styled currency formatting.
///
/// Cell layout:
/// ```
/// ┌─────────────────────────────────────┐
/// │ Account Type                        │
/// │ ────                       $XXX,XXX.XX →
/// │ Account Name                        │
/// │                     Current Balance │
/// └─────────────────────────────────────┘
/// ```
///
/// Features:
/// - Color-coded underline based on account type
/// - Multi-font styled balance (large dollars, small cents)
/// - Chevron indicator for row selection
/// - Supports dynamic type for accessibility
class AccountSummaryCell: UITableViewCell {

    // MARK: - UI

    /// Label displaying the account type (Banking, Credit Card, Investment)
    let typeLabel           = UILabel()

    /// Colored underline view below the type label (color varies by account type)
    let underlineView       = UIView()

    /// Label displaying the account name (e.g., "Basic Savings")
    let nameLabel           = UILabel()

    /// Stack view containing balance label and formatted amount
    let balanceStackView    = UIStackView()

    /// Label showing "Current Balance" or "Value" depending on account type
    let balanceLabel        = UILabel()

    /// Label displaying the formatted balance amount with custom styling
    let balanceAmountLabel  = UILabel()

    /// Chevron icon indicating the row is tappable
    let chevronImageView    = UIImageView()

    // MARK: - Properties

    /// Reuse identifier for dequeueing cells from the table view
    static let reuseID              = String(describing: AccountSummaryCell.self)

    /// Fixed height for all account summary cells
    static let rowHeight: CGFloat   = 112

    /// Optional view model (not currently used, cells are configured directly)
    let viewModel: ViewModel?       = nil

    // MARK: - Initializer

    /// Initializes the cell with programmatic layout (not from XIB/Storyboard).
    ///
    /// - Parameters:
    ///   - style: The cell style (not used with custom layout)
    ///   - reuseIdentifier: The reuse identifier for the cell
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
        layout()
    }

    /// Required initializer for Interface Builder (not supported).
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Helper Functions

extension AccountSummaryCell {

    /// Creates a styled attributed string for currency display.
    ///
    /// Takes a currency amount like "$929,466.63" and applies different text styles:
    /// - "$" symbol: Small, raised above baseline
    /// - "929,466": Large (title1) for emphasis
    /// - ".63": Small, raised above baseline
    ///
    /// Visual result: Small "$" + BIG DOLLARS + small ".cents"
    ///
    /// The baselineOffset of 8 points lifts the $ and cents up, creating a
    /// professional financial app aesthetic where the dollar amount is most prominent.
    ///
    /// - Parameters:
    ///   - dollars: The dollar portion as a string (e.g., "929,466")
    ///   - cents: The cents portion as a string (e.g., ".63")
    /// - Returns: NSMutableAttributedString with custom styling applied
    private func makeFormattedBalance(dollars: String, cents: String) -> NSMutableAttributedString {
        // Style for the dollar sign ($)
        // - Small font (callout size)
        // - Raised 8 points above normal baseline
        let dollarSignAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: .callout),
            .baselineOffset: 8  // Lifts text up 8 points
        ]

        // Style for the dollar amount (e.g., 929,466)
        // - Large font (title1 size) for maximum visibility
        // - Normal baseline (no offset)
        let dollarAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: .title1)
        ]

        // Style for the cents portion (e.g., .63)
        // - Small font (footnote size)
        // - Raised 8 points to align with dollar sign
        let centAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: .footnote),
            .baselineOffset: 8  // Lifts text up 8 points
        ]

        // Build the attributed string piece by piece
        // 1. Start with the dollar sign
        let rootString      = NSMutableAttributedString(string: "$", attributes: dollarSignAttributes)

        // 2. Create the dollar amount string
        let dollarString    = NSAttributedString(string: dollars, attributes: dollarAttributes)

        // 3. Create the cents string
        let centString      = NSAttributedString(string: cents, attributes: centAttributes)

        // 4. Concatenate all three parts: $ + dollars + cents
        rootString.append(dollarString)
        rootString.append(centString)

        return rootString
    }

    /// Configures the styling and properties of all UI elements.
    ///
    /// Sets up:
    /// - Dynamic type support for accessibility
    /// - Font styles for labels
    /// - Stack view configuration
    /// - Chevron icon with tint color
    private func setup() {
        // Disable autoresizing masks for all views to use Auto Layout
        [
            typeLabel,
            underlineView,
            nameLabel,
            balanceStackView,
            balanceLabel,
            balanceAmountLabel,
            chevronImageView
        ].forEach { subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
        }

        // Enable dynamic type (font scaling) for text labels
        // This allows text to resize based on user's accessibility settings
        [
            typeLabel,
            balanceLabel,
            nameLabel
        ].forEach { subView in
            subView.adjustsFontForContentSizeCategory = true
        }

        // Configure account type label (top-left)
        // preferredFont() provides system fonts that scale with accessibility settings
        typeLabel.font                                      = UIFont.preferredFont(forTextStyle: .caption1)
        typeLabel.text                                      = "Account Type"

        // Configure colored underline (changes based on account type)
        underlineView.backgroundColor                       = AppColors.mainColor

        // Configure account name label (left side, below underline)
        nameLabel.font                                      = UIFont.preferredFont(forTextStyle: .body)
        nameLabel.text                                      = "Account Name"

        // Configure balance stack view (right side)
        // Vertical stack with two labels: description + amount
        balanceStackView.axis                               = .vertical
        balanceStackView.spacing                            = 0

        // Configure balance description label ("Current Balance" or "Value")
        balanceLabel.font                                   = UIFont.preferredFont(forTextStyle: .body)
        balanceLabel.textAlignment                          = .right
        balanceLabel.text                                   = "Some Balance"

        // Configure balance amount label with styled placeholder text
        balanceAmountLabel.textAlignment                    = .right
        balanceAmountLabel.attributedText                   = makeFormattedBalance(dollars: "XXX,XXX", cents: "XX")

        // Configure chevron icon (right arrow)
        // withTintColor + alwaysOriginal ensures the custom color is used
        chevronImageView.image = UIImage(systemName: AppConstants.chevronImageName)?
            .withTintColor(
                AppColors.mainColor,
                renderingMode: .alwaysOriginal  // Prevents tint color override
            )
    }

    /// Positions all UI elements using Auto Layout constraints.
    ///
    /// Layout hierarchy:
    /// ```
    /// contentView
    /// ├─ typeLabel (top-left)
    /// ├─ underlineView (below typeLabel, 60pt wide)
    /// ├─ nameLabel (left side, below underline)
    /// ├─ balanceStackView (right side)
    /// │  ├─ balanceLabel
    /// │  └─ balanceAmountLabel
    /// └─ chevronImageView (far right)
    /// ```
    private func layout() {
        // Add balance labels to vertical stack
        balanceStackView.addArrangedSubview(balanceLabel)
        balanceStackView.addArrangedSubview(balanceAmountLabel)

        // Add all views to the cell's content view
        [
            typeLabel,
            underlineView,
            nameLabel,
            balanceStackView,
            chevronImageView
        ].forEach { subView in
            contentView.addSubview(subView)
        }

        // Position type label at top-left with padding
        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            typeLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2)
        ])

        // Position underline below type label (60pt wide, 4pt tall)
        NSLayoutConstraint.activate([
            underlineView.topAnchor.constraint(equalToSystemSpacingBelow: typeLabel.bottomAnchor, multiplier: 1),
            underlineView.leadingAnchor.constraint(equalTo: typeLabel.leadingAnchor),
            underlineView.widthAnchor.constraint(equalToConstant: 60),
            underlineView.heightAnchor.constraint(equalToConstant: 4)
        ])

        // Position account name label on left side, below underline
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: underlineView.bottomAnchor, multiplier: 2),
            nameLabel.leadingAnchor.constraint(equalTo: typeLabel.leadingAnchor)
        ])

        // Position balance stack view on right side
        // Multiplier 0 for topAnchor aligns it precisely with underline
        NSLayoutConstraint.activate([
            balanceStackView.topAnchor.constraint(equalToSystemSpacingBelow: underlineView.bottomAnchor, multiplier: 0),
            balanceStackView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 4),
            trailingAnchor.constraint(equalToSystemSpacingAfter: balanceStackView.trailingAnchor, multiplier: 4)
        ])

        // Position chevron icon on far right
        // lessThanOrEqualTo allows chevron to compress if balance text is very long
        NSLayoutConstraint.activate([
            chevronImageView.topAnchor.constraint(equalToSystemSpacingBelow: underlineView.bottomAnchor, multiplier: 1),
            trailingAnchor.constraint(lessThanOrEqualToSystemSpacingAfter: chevronImageView.trailingAnchor, multiplier: 1)
        ])
    }

    /// Configures the cell with account data from a ViewModel.
    ///
    /// Updates all labels and colors based on the account type:
    /// - Banking: Teal underline, "Current Balance" label
    /// - Credit Card: Orange underline, "Current Balance" label
    /// - Investment: Purple underline, "Value" label
    ///
    /// The balance is displayed using the pre-formatted attributed string from the ViewModel.
    ///
    /// - Parameter vm: ViewModel containing account type, name, and formatted balance
    func configure(with vm: ViewModel) {
        // Set basic account info
        typeLabel.text                      = vm.accountType.rawValue.capitalized
        nameLabel.text                      = vm.accountName
        balanceAmountLabel.attributedText   = vm.balanceAsAttributedString

        // Customize appearance based on account type
        switch vm.accountType {
            case .banking:
                underlineView.backgroundColor   = AppColors.mainColor  // Teal
                balanceLabel.text               = "Current Balance"
            case .creditCard:
                underlineView.backgroundColor   = .systemOrange        // Orange
                balanceLabel.text               = "Current Balance"
            case .investment:
                underlineView.backgroundColor   = .systemPurple        // Purple
                balanceLabel.text               = "Value"
        }
    }

}
