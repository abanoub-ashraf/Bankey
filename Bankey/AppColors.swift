import UIKit

/// Centralized color definitions for the Bankey app.
///
/// This struct provides a single source of truth for app colors,
/// making it easy to:
/// - Maintain consistent branding
/// - Update colors app-wide from one location
/// - Support future theming or dark mode customization
///
/// Example usage:
/// ```
/// view.backgroundColor = AppColors.mainColor
/// ```
struct AppColors {
    /// The app's primary brand color (teal).
    ///
    /// Used for:
    /// - Navigation bars
    /// - Tab bar selected items
    /// - Banking account underlines
    /// - Status bar background
    static let mainColor: UIColor = .systemTeal
}
