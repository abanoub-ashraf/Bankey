import Foundation

/// A utility class for managing app state that persists across app launches.
///
/// Currently stores whether the user has completed onboarding. This ensures
/// the onboarding flow is only shown once per installation.
///
/// Uses UserDefaults for simple key-value persistence. The data survives app
/// termination and device restarts.
///
/// Example usage:
/// ```
/// // Check if user has onboarded
/// if LocalState.hasOnboarded {
///     // Show main app
/// } else {
///     // Show onboarding
/// }
///
/// // Mark onboarding as complete
/// LocalState.hasOnboarded = true
/// ```
public class LocalState {

    /// Private enum defining UserDefaults keys.
    ///
    /// Using an enum ensures type safety and prevents typos in key strings.
    /// All keys are in one place for easy management.
    private enum Keys: String {
        case hasOnboarded
    }

    /// Indicates whether the user has completed the onboarding flow.
    ///
    /// This computed property provides a clean interface to UserDefaults:
    /// - get: Retrieves the stored boolean value (defaults to false if not set)
    /// - set: Stores the new value and synchronizes to disk
    ///
    /// The synchronize() call ensures the value is immediately written to disk,
    /// though in modern iOS this is usually automatic.
    public static var hasOnboarded: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.hasOnboarded.rawValue)
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: Keys.hasOnboarded.rawValue)
            UserDefaults.standard.synchronize()  // Force immediate save
        }
    }

}
