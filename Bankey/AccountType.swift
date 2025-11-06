import Foundation

/// Enum representing the different types of accounts in the banking app.
///
/// Each account type has its own visual styling (color) and display properties:
/// - banking: Teal color, shows "Current Balance"
/// - creditCard: Orange color, shows "Current Balance"
/// - investment: Purple color, shows "Value"
///
/// The raw value (String) is used for display purposes and can be capitalized
/// for UI presentation.
///
/// Example usage:
/// ```
/// let account = ViewModel(
///     accountType: .banking,
///     accountName: "Savings",
///     balance: 1000.00
/// )
/// ```
enum AccountType: String {
    /// Banking accounts (savings, chequing)
    case banking

    /// Credit card accounts
    case creditCard

    /// Investment accounts
    case investment
}
