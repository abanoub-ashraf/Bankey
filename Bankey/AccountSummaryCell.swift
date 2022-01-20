import UIKit

class AccountSummaryCell: UITableViewCell {
    
    // MARK: - UI

    let typeLabel           = UILabel()
    let underlineView       = UIView()
    let nameLabel           = UILabel()
    let balanceStackView    = UIStackView()
    let balanceLabel        = UILabel()
    let balanceAmountLabel  = UILabel()
    let chevronImageView    = UIImageView()
    
    // MARK: - Properties

    static let reuseID              = String(describing: AccountSummaryCell.self)
    static let rowHeight: CGFloat   = 112
    let viewModel: ViewModel?       = nil
    
    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Helper Functions

extension AccountSummaryCell {
    
    ///
    /// - a given string like this $929,466.63, we wanna give a different style each part of it
    ///
    /// - 929,466 is the dollar parameter and 63 is the cent one
    ///
    /// - we wanna give the $ part of the string a style as well but it doesn't have to be
    ///   given as a parameter
    ///
    private func makeFormattedBalance(dollars: String, cents: String) -> NSMutableAttributedString {
        ///
        /// - style the dollar sign part of the given string
        ///
        /// - we wanna left it up 8 points from the ground
        ///
        let dollarSignAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: .callout),
            .baselineOffset: 8
        ]
        
        ///
        /// - style the dollar amount string of the given string
        ///
        /// - we want it to be title1
        ///
        let dollarAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: .title1)
        ]
        
        ///
        /// - style the cent amount string of the given string
        ///
        /// - we want it to to be left up 8 points from the ground
        ///
        let centAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: .footnote),
            .baselineOffset: 8
        ]
        
        ///
        /// - create the string that will be returned from this function
        ///
        /// - start it off with the dollar sign and the custom attributes we made for it
        ///
        /// - create a dollar string for the dollar param with its custom attrubutes we made
        ///
        /// - create a cent string for the cent param with its custom attrubutes we made
        ///
        let rootString      = NSMutableAttributedString(string: "$", attributes: dollarSignAttributes)
        let dollarString    = NSAttributedString(string: dollars, attributes: dollarAttributes)
        let centString      = NSAttributedString(string: cents, attributes: centAttributes)
        
        ///
        /// then append the dollar string and the cent string to the root string
        /// and then return it
        ///
        rootString.append(dollarString)
        rootString.append(centString)
        
        return rootString
    }
    
    private func setup() {
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
        
        [
            typeLabel,
            balanceLabel,
            nameLabel
        ].forEach { subView in
            ///
            /// A Boolean that indicates whether the object automatically updates its font
            /// when the device's content size category changes
            ///
            subView.adjustsFontForContentSizeCategory = true
        }
        
        ///
        /// preferredFont() returns an instance of the system font for the specified text style
        /// with scaling for the user's selected content size category
        ///
        typeLabel.font                                      = UIFont.preferredFont(forTextStyle: .caption1)
        typeLabel.text                                      = "Account Type"
        
        underlineView.backgroundColor                       = AppColors.mainColor
        
        nameLabel.font                                      = UIFont.preferredFont(forTextStyle: .body)
        nameLabel.text                                      = "Account Name"
        
        balanceStackView.axis                               = .vertical
        balanceStackView.spacing                            = 0
        
        balanceLabel.font                                   = UIFont.preferredFont(forTextStyle: .body)
        balanceLabel.textAlignment                          = .right
        balanceLabel.text                                   = "Some Balance"
        
        balanceAmountLabel.textAlignment                    = .right
        balanceAmountLabel.attributedText                   = makeFormattedBalance(dollars: "XXX,XXX", cents: "XX")
        
        ///
        /// this is how to set tint color on sfsymbol images
        ///
        chevronImageView.image = UIImage(systemName: AppConstants.chevronImageName)?
            .withTintColor(
                AppColors.mainColor,
                renderingMode: .alwaysOriginal
            )
    }
    
    private func layout() {
        balanceStackView.addArrangedSubview(balanceLabel)
        balanceStackView.addArrangedSubview(balanceAmountLabel)
        
        [
            typeLabel,
            underlineView,
            nameLabel,
            balanceStackView,
            chevronImageView
        ].forEach { subView in
            contentView.addSubview(subView)
        }
        
        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            typeLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2)
        ])
        
        NSLayoutConstraint.activate([
            underlineView.topAnchor.constraint(equalToSystemSpacingBelow: typeLabel.bottomAnchor, multiplier: 1),
            underlineView.leadingAnchor.constraint(equalTo: typeLabel.leadingAnchor),
            underlineView.widthAnchor.constraint(equalToConstant: 60),
            underlineView.heightAnchor.constraint(equalToConstant: 4)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalToSystemSpacingBelow: underlineView.bottomAnchor, multiplier: 2),
            nameLabel.leadingAnchor.constraint(equalTo: typeLabel.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            balanceStackView.topAnchor.constraint(equalToSystemSpacingBelow: underlineView.bottomAnchor, multiplier: 0),
            balanceStackView.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 4),
            trailingAnchor.constraint(equalToSystemSpacingAfter: balanceStackView.trailingAnchor, multiplier: 4)
        ])
        
        NSLayoutConstraint.activate([
            chevronImageView.topAnchor.constraint(equalToSystemSpacingBelow: underlineView.bottomAnchor, multiplier: 1),
            trailingAnchor.constraint(lessThanOrEqualToSystemSpacingAfter: chevronImageView.trailingAnchor, multiplier: 1)
        ])
    }
    
    func configure(with vm: ViewModel) {
        typeLabel.text                      = vm.accountType.rawValue.capitalized
        nameLabel.text                      = vm.accountName
        balanceAmountLabel.attributedText   = vm.balanceAsAttributedString
        
        switch vm.accountType {
            case .banking:
                underlineView.backgroundColor   = AppColors.mainColor
                balanceLabel.text               = "Current Balance"
            case .creditCard:
                underlineView.backgroundColor   = .systemOrange
                balanceLabel.text               = "Current Balance"
            case .investment:
                underlineView.backgroundColor   = .systemPurple
                balanceLabel.text               = "Value"
        }
    }
    
}
