import UIKit

/// A utility struct for formatting currency values with custom styling.
///
/// This formatter converts decimal currency amounts into styled strings suitable for display
/// in a banking app. It provides two main output formats:
/// 1. Standard formatted currency: "$929,466.00"
/// 2. Styled attributed string: Small "$" + BIG "929,466" + small ".23"
///
/// The conversion pipeline:
/// ```
/// Decimal(929466.23)
///   ↓ breakIntoDollarsAndCents()
/// ("929,466", "23")
///   ↓ makeBalanceAttributed()
/// NSMutableAttributedString with custom fonts/offsets
/// ```
struct CurrencyFormatter {

    /// Formats a double value as a currency string with grouping separators.
    ///
    /// Converts: 929466.00 → "$929,466.00"
    ///
    /// Uses the system's NumberFormatter with currency style and grouping
    /// (thousands separators). The currency symbol and format are localized
    /// based on the device's region settings.
    ///
    /// - Parameter dollars: The amount to format as currency
    /// - Returns: Formatted currency string, or empty string if formatting fails
    func dollarsFormatted(_ dollars: Double) -> String {
        let formatter = NumberFormatter()

        // Configure formatter for currency display
        formatter.numberStyle           = .currency         // Adds $ symbol
        formatter.usesGroupingSeparator = true              // Adds commas for thousands

        // Convert to string using the configured formatter
        if let result = formatter.string(from: dollars as NSNumber) {
            return result
        }

        return ""
    }

    /// Extracts the dollar portion from a formatted currency string.
    ///
    /// Converts: 929466.00 → "929,466"
    ///
    /// Process:
    /// 1. Formats the input as "$929,466.00"
    /// 2. Splits by decimal separator to get ["$929,466", "00"]
    /// 3. Takes the first part: "$929,466"
    /// 4. Removes the dollar sign: "929,466"
    ///
    /// - Parameter dollarPart: The dollar portion of the amount
    /// - Returns: Formatted dollar string without $ symbol or decimals
    private func convertDollar(_ dollarPart: Double) -> String {
        // Get fully formatted string: "$929,466.00"
        let dollarsWithDecimal  = dollarsFormatted(dollarPart)

        // Get the decimal separator for the current locale (usually ".")
        let formatter           = NumberFormatter()
        let decimalSeparator    = formatter.decimalSeparator!

        // Split into ["$929,466", "00"]
        let dollarComponents    = dollarsWithDecimal.components(separatedBy: decimalSeparator)

        // Get the dollar portion: "$929,466"
        var dollars             = dollarComponents.first!

        // Remove the "$" to get: "929,466"
        dollars.removeFirst()

        return dollars
    }

    /// Converts the fractional cent portion to a two-digit string.
    ///
    /// Converts: 0.23 → "23"
    ///           0.00 → "00"
    ///           0.9  → "90"
    ///
    /// The cents are multiplied by 100 to convert from fractional (0.23)
    /// to whole number (23) representation.
    ///
    /// - Parameter centPart: The fractional cent portion (0.0 to 0.99)
    /// - Returns: Two-digit cent string
    private func convertCents(_ centPart: Double) -> String {
        let cents: String

        if centPart == 0 {
            // Special case: exactly zero
            cents = "00"
        } else {
            // Convert fraction to whole number cents
            // 0.23 * 100 = 23.0 → "23"
            cents = String(format: "%.0f", centPart * 100)
        }

        return cents
    }

    /// Breaks a decimal amount into separate dollar and cent strings.
    ///
    /// Converts: 929466.23 → ("929,466", "23")
    ///
    /// This is the key method that splits a currency amount into two parts
    /// for custom styling. It uses modf() to separate the integral and
    /// fractional components, then formats each part appropriately.
    ///
    /// modf() explained:
    /// ```
    /// Input:  929466.23
    /// Output: (929466.0, 0.23)
    ///         ↑          ↑
    ///         integral   fractional
    /// ```
    ///
    /// - Parameter amount: The full currency amount as a Decimal
    /// - Returns: Tuple of (formatted dollars, formatted cents)
    func breakIntoDollarsAndCents(_ amount: Decimal) -> (String, String) {
        // modf() splits the number into integral and fractional parts
        // Example: modf(929466.23) → (929466.0, 0.23)
        // Both parts retain the original sign
        let tuple = modf(amount.doubleValue)

        // Convert integral part (929466.0) → "929,466"
        let dollars = convertDollar(tuple.0)

        // Convert fractional part (0.23) → "23"
        let cents   = convertCents(tuple.1)

        return (dollars, cents)
    }

    /// Creates a styled attributed string from dollar and cent strings.
    ///
    /// Applies three different text styles:
    /// - "$": Small font (callout), raised 8pt
    /// - "929,466": Large font (title1), normal baseline
    /// - "23": Small font (callout), raised 8pt
    ///
    /// The raised baseline for $ and cents creates a professional
    /// financial display where the dollar amount is visually dominant.
    ///
    /// - Parameters:
    ///   - dollars: The formatted dollar string (e.g., "929,466")
    ///   - cents: The formatted cent string (e.g., "23")
    /// - Returns: Styled attributed string ready for display
    private func makeBalanceAttributed(dollars: String, cents: String) -> NSMutableAttributedString {
        // Style for "$" - small and raised
        let dollarSignAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: .callout),
            .baselineOffset: 8  // Lifts text up 8 points
        ]

        // Style for dollar amount - large and prominent
        let dollarAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: .title1)
        ]

        // Style for cents - small and raised
        let centAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: .callout),
            .baselineOffset: 8  // Lifts text up 8 points
        ]

        // Build the complete attributed string
        let rootString      = NSMutableAttributedString(string: "$", attributes: dollarSignAttributes)
        let dollarString    = NSAttributedString(string: dollars, attributes: dollarAttributes)
        let centString      = NSAttributedString(string: cents, attributes: centAttributes)

        // Concatenate: $ + dollars + cents
        rootString.append(dollarString)
        rootString.append(centString)

        return rootString
    }

    /// Converts a decimal currency amount into a styled attributed string.
    ///
    /// This is the main public method that orchestrates the entire formatting process:
    /// 1. Breaks the amount into dollars and cents
    /// 2. Applies custom styling to each part
    /// 3. Returns the complete attributed string
    ///
    /// Example:
    /// ```
    /// let formatter = CurrencyFormatter()
    /// let styled = formatter.makeAttributedCurrency(Decimal(929466.23))
    /// // Result: Small "$" + BIG "929,466" + small "23"
    /// ```
    ///
    /// - Parameter amount: The currency amount to format
    /// - Returns: Styled attributed string with custom fonts and baseline offsets
    func makeAttributedCurrency(_ amount: Decimal) -> NSMutableAttributedString {
        // Step 1: Break into components
        let tuple = breakIntoDollarsAndCents(amount)

        // Step 2: Apply styling and return
        return makeBalanceAttributed(dollars: tuple.0, cents: tuple.1)
    }

}
