
import Foundation

public class Reward {
    let totalRevenue: Double
    let virtualCurrencyReward: Double
    
    init(totalRevenue: Double, virtualCurrencyReward: Double) {
        self.totalRevenue = totalRevenue
        self.virtualCurrencyReward = virtualCurrencyReward
    }
}
