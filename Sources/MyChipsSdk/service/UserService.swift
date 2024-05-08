
import Foundation

class UserService {
    private let userIdKey = "my_chips_sdk_user_id"
    
    func setId(userId: String) {
        UserDefaults.standard.set(userId, forKey: userIdKey)
    }
    
    func getOrCreateId() -> String {
        var userId = UserDefaults.standard.string(forKey: userIdKey)
        if (userId != nil) {
            return userId!
        }
        
        userId = UUID().uuidString
        setId(userId: userId!)
        return userId!
    }
}
