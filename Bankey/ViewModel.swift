import Foundation

struct ViewModel {
    let accountType: AccountType
    let accountName: String
    let balance: Decimal
    
    var balanceAsAttributedString: NSAttributedString {
        return CurrencyFormatter()
            .makeAttributedCurrency(balance)
    }
}
