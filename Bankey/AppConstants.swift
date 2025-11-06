import Foundation

/// Centralized constants for the Bankey app.
///
/// This struct provides a single source of truth for:
/// - Image asset names
/// - SF Symbols icon names
/// - Text strings used throughout the app
///
/// Benefits of centralization:
/// - Easy to find and update constants
/// - Prevents typos in string literals
/// - Type safety for accessing resources
struct AppConstants {

    // MARK: - Images Names

    /// Asset name for DeLorean car image (onboarding page 1)
    static let deloreanImageName        = "delorean"

    /// Asset name for world globe image (onboarding page 2)
    static let worldImageName           = "world"

    /// Asset name for thumbs up image (onboarding page 3)
    static let thumbsImageName          = "thumbs"

    // MARK: - SFSymbols

    /// SF Symbol for Summary tab icon (list with header)
    static let summaryImageName         = "list.dash.header.rectangle"

    /// SF Symbol for Move Money tab icon (bidirectional arrow)
    static let moneyImageName           = "arrow.left.arrow.right"

    /// SF Symbol for More tab icon (ellipsis circle)
    static let moreImageName            = "ellipsis.circle"

    /// SF Symbol for chevron right icon (used in account cells)
    static let chevronImageName         = "chevron.right"

    // MARK: - Strings

    /// Onboarding text for page 1 (DeLorean/speed theme)
    static let onboardingDeloreanLabel  = "Bankey is faster, easier to use, and has a brand new look and feel that will make you feel like you are back in 1989."

    /// Onboarding text for page 2 (world/global theme)
    static let onboardingWorldLabel     = "Move your money around the world quickly and securely."

    /// Onboarding text for page 3 (thumbs up/call to action)
    static let onboardingThumbsLabel    = "Learn more at www.bankey.com."
}
