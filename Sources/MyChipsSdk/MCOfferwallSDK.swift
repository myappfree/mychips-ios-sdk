import Foundation

public class MCOfferwallSDK {
    private static var balanceService: BalanceService?
    private static var userService: UserService?
    
    let apiKey: String
    
    public init (apiKey: String) {
        self.apiKey = apiKey
        MCOfferwallSDK.balanceService = BalanceService()
        MCOfferwallSDK.userService = UserService()
    }
    
    public static func getUserId() -> String{
        return userService!.getOrCreateId()
    }
    
    public static func setUserId(userId: String) {
        userService!.setId(userId: userId)
    }
    
    public static func getReward(adunitId: String, onReward: @escaping (Reward) -> Void, onError: @escaping (Error) -> Void) {
        
        let userId = userService!.getOrCreateId()
        
        balanceService!.getBalance(
            userId: userId, 
            adunitId: adunitId,
            onReward: onReward,
            onError: onError
        )
    }
    
    
    
}
