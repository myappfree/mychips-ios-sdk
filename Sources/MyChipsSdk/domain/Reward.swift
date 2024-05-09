
import Foundation

public class Reward {
    public let totalRevenue: Double
    public let virtualCurrencyReward: Double
    
    public init(totalRevenue: Double, virtualCurrencyReward: Double) {
        self.totalRevenue = totalRevenue
        self.virtualCurrencyReward = virtualCurrencyReward
    }
}
