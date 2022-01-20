import UIKit

class AccountSummaryViewController: UIViewController {
    
    // MARK: - UI

    var tableView = UITableView()
    
    // MARK: - Properties

    var accounts: [ViewModel] = []
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        fetchData()
    }
    
}

// MARK: - Helper Functions

extension AccountSummaryViewController {
    
    private func setupTableView() {
        tableView.delegate          = self
        tableView.dataSource        = self
        tableView.tableFooterView   = UIView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        setupTableViewHeader()
        setupTableViewCell()
    }
    
    private func setupTableViewHeader() {
        let header                  = AccountSummaryHeaderView(frame: .zero)
        ///
        /// tell the header to lay itself out in a smallest form possible
        ///
        var size                    = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        ///
        /// set the width of the header in here not inside the header file itself
        ///
        size.width                  = UIScreen.main.bounds.width
        header.frame.size           = size
        tableView.tableHeaderView   = header
    }
    
    private func setupTableViewCell() {
        tableView.register(AccountSummaryCell.self, forCellReuseIdentifier: AccountSummaryCell.reuseID)
        tableView.rowHeight = AccountSummaryCell.rowHeight
    }
    
    private func fetchData() {
        let savings = ViewModel(
            accountType: .banking,
            accountName: "Basic Savings",
            balance: 929466.23
        )
        let chequing = ViewModel(
            accountType: .banking,
            accountName: "No-Fee All-In Chequing",
            balance: 17562.44
        )
        let visa = ViewModel(
            accountType: .creditCard,
            accountName: "Visa Avion Card",
            balance: 412.83
        )
        let masterCard = ViewModel(
            accountType: .creditCard,
            accountName: "Student Mastercard",
            balance: 50.83
        )
        let investment1 = ViewModel(
            accountType: .investment,
            accountName: "Tax-Fee Saver",
            balance: 2000.00
        )
        let investment2 = ViewModel(
            accountType: .investment,
            accountName: "Growth Fund",
            balance: 15000.00
        )
        
        accounts.append(savings)
        accounts.append(chequing)
        accounts.append(visa)
        accounts.append(masterCard)
        accounts.append(investment1)
        accounts.append(investment2)
    }
    
}

// MARK: - UITableViewDataSource

extension AccountSummaryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !accounts.isEmpty else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: AccountSummaryCell.reuseID,
            for: indexPath
        ) as! AccountSummaryCell
        
        let account = accounts[indexPath.row]
        cell.configure(with: account)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
}

// MARK: - UITableViewDelegate

extension AccountSummaryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
