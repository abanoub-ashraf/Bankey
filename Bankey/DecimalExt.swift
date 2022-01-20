import Foundation

extension Decimal {
    
    ///
    /// get a double value out of a decimal one
    ///
    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
    
}
