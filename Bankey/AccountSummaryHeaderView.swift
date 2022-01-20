import UIKit

class AccountSummaryHeaderView: UIView {
    
    // MARK: - UI

    @IBOutlet var contentView: UIView!
    
    // MARK: - Properties
    
    ///
    /// - this is a default size a view wants to give to itself
    ///
    /// - we give it height here, and the width will be set from the parent of this header
    ///
    override var intrinsicContentSize: CGSize {
        return CGSize(
            width: UIView.noIntrinsicMetric,
            height: 144
        )
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions
    
    private func commonInit() {
        ///
        /// connect the xib file with this file
        ///
        let bundle = Bundle(for: AccountSummaryHeaderView.self)
        
        bundle.loadNibNamed(
            String(describing: AccountSummaryHeaderView.self),
            owner: self,
            options: nil
        )
        
        style()
        layout()
    }
    
    private func style() {
        contentView.backgroundColor = AppColors.mainColor
    }
    
    private func layout() {
        addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
}
