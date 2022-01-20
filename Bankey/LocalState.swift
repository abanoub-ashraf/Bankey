import Foundation

///
/// this class will help us showing the onboarded screen only once
/// and that will be kept even after the app is terminated and did open again
///
public class LocalState {
    
    ///
    /// the key for the computed property down there
    ///
    private enum Keys: String {
        case hasOnboarded
    }
    
    ///
    /// this is a computed property that we can access it and set it using a key
    /// cause it's a userdefault value and that needs a key
    ///
    public static var hasOnboarded: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.hasOnboarded.rawValue)
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: Keys.hasOnboarded.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
}
