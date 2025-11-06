import Foundation

/// Extension adding utility methods to the Decimal type.
///
/// Provides convenient conversion from Decimal to Double for use with
/// APIs and libraries that require Double values (like modf() for
/// currency formatting).
extension Decimal {

    /// Converts the Decimal value to a Double.
    ///
    /// This conversion is useful when working with currency formatting,
    /// as CurrencyFormatter uses modf() which requires Double input.
    ///
    /// Example usage:
    /// ```
    /// let balance = Decimal(929466.23)
    /// let doubleBalance = balance.doubleValue  // 929466.23 as Double
    /// ```
    ///
    /// Note: Double has limited precision compared to Decimal, so use this
    /// only for display purposes, not for financial calculations.
    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }

}
