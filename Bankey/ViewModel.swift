import Foundation

/// View model representing an account with its type, name, and balance.
///
/// This struct encapsulates account data and provides formatted balance display
/// using the CurrencyFormatter. It's used by AccountSummaryCell to configure
/// account rows in the table view.
///
/// Example usage:
/// ```
/// let account = ViewModel(
///     accountType: .banking,
///     accountName: "Basic Savings",
///     balance: 929466.23
/// )
/// cell.configure(with: account)
/// ```
struct ViewModel {
    /// The type of account (banking, credit card, or investment)
    let accountType: AccountType

    /// The display name of the account (e.g., "Basic Savings", "Visa Avion Card")
    let accountName: String

    /// The current balance as a Decimal for precise currency calculations
    let balance: Decimal

    /// Provides the balance formatted as a styled attributed string.
    ///
    /// Converts the balance using CurrencyFormatter to create a multi-font
    /// display with small $ and cents, large dollar amount.
    ///
    /// Example: 929466.23 → Small "$" + BIG "929,466" + small "23"
    var balanceAsAttributedString: NSAttributedString {
        return CurrencyFormatter()
            .makeAttributedCurrency(balance)
    }
}
