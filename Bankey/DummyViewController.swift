import UIKit

class DummyViewController: UIViewController {
    
    // MARK: - UI
    
    let stackView       = UIStackView()
    let label           = UILabel()
    let logoutButton    = UIButton(type: .system)
    
    // MARK: - Properties

    weak var logoutDelegate: LogoutDelegate?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        layout()
    }
    
}

// MARK: - Helper Functions

extension DummyViewController {
    
    private func style() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis      = .vertical
        stackView.spacing   = 20
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome"
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.configuration = .filled()
        logoutButton.setTitle("Logout", for: [])
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .primaryActionTriggered)
    }
    
    private func layout() {
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(logoutButton)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}

// MARK: - Selectors

extension DummyViewController {
    
    @objc private func logoutButtonTapped(sender: UIButton) {
        logoutDelegate?.didLogout()
    }
    
}
