import UIKit

struct CurrencyFormatter {
    
    ///
    /// format a double value format into a string format using number formatter
    ///
    /// Converts 929466 > $929,466.00
    ///
    func dollarsFormatted(_ dollars: Double) -> String {
        let formatter = NumberFormatter()
        
        formatter.numberStyle           = .currency
        formatter.usesGroupingSeparator = true
        
        ///
        /// the string output we want from this function
        ///
        if let result = formatter.string(from: dollars as NSNumber) {
            return result
        }
        
        return ""
    }
    
    ///
    /// convert 929466 > 929,466
    ///
    private func convertDollar(_ dollarPart: Double) -> String {
        ///
        /// gives us the "$929,466.00"
        ///
        let dollarsWithDecimal  = dollarsFormatted(dollarPart)
        let formatter           = NumberFormatter()
        ///
        /// the "." separator
        ///
        let decimalSeparator    = formatter.decimalSeparator!
        ///
        /// "$929,466" "00"
        ///
        let dollarComponents    = dollarsWithDecimal.components(separatedBy: decimalSeparator)
        ///
        /// "$929,466"
        ///
        var dollars             = dollarComponents.first!
        
        ///
        /// "929,466"
        ///
        dollars.removeFirst()
        
        return dollars
    }
    
    ///
    /// Convert 0.23 > 23
    ///
    private func convertCents(_ centPart: Double) -> String {
        let cents: String
        
        if centPart == 0 {
            cents = "00"
        } else {
            cents = String(format: "%.0f", centPart * 100)
        }
        
        return cents
    }
    
    ///
    /// this method will recieve the decimal and gives us a tuple
    ///
    /// Converts 929466.23 > "929,466" "23"
    ///
    func breakIntoDollarsAndCents(_ amount: Decimal) -> (String, String) {
        ///
        /// modf() is used to break the decimal amount input into an integral and a fractional part and returns it
        /// Both parts have the same sign as the decimal
        ///
        let tuple = modf(amount.doubleValue)
        
        ///
        /// convert the first part of the tuple which is the integral part to a string
        ///
        let dollars = convertDollar(tuple.0)
        ///
        /// convert the second part of the tuple which is the fractional part to a string
        ///
        let cents   = convertCents(tuple.1)
        
        ///
        /// output the tuple to be used in other functions
        ///
        return (dollars, cents)
    }
    
    ///
    /// take the dollar part and the cents part of the tuple and convert them into
    /// nsmutableattributedstring
    ///
    private func makeBalanceAttributed(dollars: String, cents: String) -> NSMutableAttributedString {
        let dollarSignAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: .callout),
            .baselineOffset: 8
        ]
        
        let dollarAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: .title1)
        ]
        
        let centAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: .callout),
            .baselineOffset: 8
        ]
        
        let rootString      = NSMutableAttributedString(string: "$", attributes: dollarSignAttributes)
        let dollarString    = NSAttributedString(string: dollars, attributes: dollarAttributes)
        let centString      = NSAttributedString(string: cents, attributes: centAttributes)
        
        rootString.append(dollarString)
        rootString.append(centString)
        
        return rootString
    }
    
    ///
    /// this function will take the decimal amount of balance and convert it into attributed string
    ///
    func makeAttributedCurrency(_ amount: Decimal) -> NSMutableAttributedString {
        ///
        /// this method will recieve the decimal and gives us a tuple
        ///
        let tuple = breakIntoDollarsAndCents(amount)
        ///
        /// takes the tuple and convert it into nsmutableattributedstring
        ///
        return makeBalanceAttributed(dollars: tuple.0, cents: tuple.1)
    }
    
}
