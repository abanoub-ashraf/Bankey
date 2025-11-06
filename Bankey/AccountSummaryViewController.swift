import UIKit

/// The main account summary view controller displaying all user accounts in a table view.
///
/// This controller shows:
/// - A custom header view with user greeting and date
/// - A list of accounts (savings, chequing, credit cards, investments)
/// - Each account displays its type, name, and current balance
///
/// Currently uses mock data. In production, this would fetch account data from an API.
class AccountSummaryViewController: UIViewController {

    // MARK: - UI

    /// Table view displaying the list of accounts
    var tableView = UITableView()

    // MARK: - Properties

    /// Array of account view models to display in the table
    /// Each ViewModel represents an account with type, name, and balance
    var accounts: [ViewModel] = []

    // MARK: - LifeCycle

    /// Called when the view controller's view is loaded into memory.
    ///
    /// Sets up the table view and loads account data.
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        fetchData()
    }

}

// MARK: - Helper Functions

extension AccountSummaryViewController {

    /// Configures the table view with delegate, data source, and styling.
    ///
    /// This method:
    /// 1. Sets up delegate and data source connections
    /// 2. Configures table view appearance
    /// 3. Sets up the custom header view
    /// 4. Registers the custom cell class
    private func setupTableView() {
        // Set this controller as the delegate and data source
        tableView.delegate          = self
        tableView.dataSource        = self

        // Remove extra separator lines below the last cell
        tableView.tableFooterView   = UIView()

        // Match the app's main teal color
        tableView.backgroundColor   = AppColors.mainColor

        // Disable autoresizing mask for Auto Layout
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)

        // Pin table view to all edges using safe area
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        setupTableViewHeader()
        setupTableViewCell()
    }

    /// Creates and configures the table view header.
    ///
    /// The header uses a custom XIB-based view (AccountSummaryHeaderView).
    ///
    /// Important sizing technique:
    /// - systemLayoutSizeFitting() calculates the header's intrinsic height
    /// - We manually set the width to match the screen width
    /// - This ensures the header displays correctly at its natural height
    ///   while spanning the full width of the screen
    private func setupTableViewHeader() {
        // Create header with zero frame (will be sized below)
        let header                  = AccountSummaryHeaderView(frame: .zero)

        // Calculate the header's natural height for its content
        // layoutFittingCompressedSize = smallest size that fits all content
        var size                    = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

        // Set width to screen width (height is already calculated above)
        // We do this here rather than in the header itself for flexibility
        size.width                  = UIScreen.main.bounds.width
        header.frame.size           = size

        // Assign the sized header to the table view
        tableView.tableHeaderView   = header
    }

    /// Registers the custom account cell class and sets row height.
    ///
    /// Uses a custom cell (AccountSummaryCell) with a fixed height
    /// for consistent row sizing throughout the table.
    private func setupTableViewCell() {
        tableView.register(AccountSummaryCell.self, forCellReuseIdentifier: AccountSummaryCell.reuseID)
        tableView.rowHeight = AccountSummaryCell.rowHeight
    }

    /// Fetches account data to display in the table.
    ///
    /// Currently creates mock data with various account types:
    /// - Banking accounts (savings, chequing)
    /// - Credit cards (Visa, Mastercard)
    /// - Investment accounts
    ///
    /// TODO: Replace with actual API call to fetch user's real account data
    private func fetchData() {
        // Create mock banking accounts
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

        // Create mock credit card accounts
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

        // Create mock investment accounts
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

        // Add all accounts to the data source array
        accounts.append(savings)
        accounts.append(chequing)
        accounts.append(visa)
        accounts.append(masterCard)
        accounts.append(investment1)
        accounts.append(investment2)
    }

}

// MARK: - UITableViewDataSource

/// Extension conforming to UITableViewDataSource protocol.
///
/// Provides the table view with data about what to display:
/// - Number of rows (accounts)
/// - Cell configuration for each row
extension AccountSummaryViewController: UITableViewDataSource {

    /// Creates and configures a cell for the specified row.
    ///
    /// Dequeues a reusable AccountSummaryCell and configures it with the
    /// account data for the given index path.
    ///
    /// - Parameters:
    ///   - tableView: The table view requesting the cell
    ///   - indexPath: The location of the row in the table
    /// - Returns: Configured AccountSummaryCell for the account
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Safety check: return empty cell if no accounts loaded
        guard !accounts.isEmpty else { return UITableViewCell() }

        // Dequeue a reusable cell (or create new if none available)
        let cell = tableView.dequeueReusableCell(
            withIdentifier: AccountSummaryCell.reuseID,
            for: indexPath
        ) as! AccountSummaryCell

        // Get the account data for this row
        let account = accounts[indexPath.row]

        // Configure the cell with the account data
        cell.configure(with: account)

        return cell
    }

    /// Returns the number of rows to display in the table.
    ///
    /// Each account gets its own row.
    ///
    /// - Parameters:
    ///   - tableView: The table view requesting the count
    ///   - section: The section index (not used, we only have one section)
    /// - Returns: Number of accounts to display
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }

}

// MARK: - UITableViewDelegate

/// Extension conforming to UITableViewDelegate protocol.
///
/// Handles user interactions with table rows (taps, selections, etc.).
extension AccountSummaryViewController: UITableViewDelegate {

    /// Called when the user taps on a row.
    ///
    /// Currently empty - could be used to navigate to account details screen.
    ///
    /// - Parameters:
    ///   - tableView: The table view containing the selected row
    ///   - indexPath: The location of the selected row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Navigate to account detail screen
    }

}
