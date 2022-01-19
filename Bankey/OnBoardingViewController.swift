import UIKit

class OnBoardingViewController: UIViewController {
    
    // MARK: - UI

    let stackView   = UIStackView()
    let imageView   = UIImageView()
    let label       = UILabel()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        layout()
    }
    
}

extension OnBoardingViewController {
    
    private func style() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis      = .vertical
        stackView.spacing   = 20
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode   = .scaleAspectFit
        imageView.image         = UIImage(named: "delorean")
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment                     = .center
        label.font                              = UIFont.preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines                     = 0
        label.text                              = AppConstants.onboardingPageLabel
    }
    
    private func layout() {
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 1)
        ])
    }
    
}
