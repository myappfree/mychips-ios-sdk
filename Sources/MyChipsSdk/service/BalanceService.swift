import Foundation

enum BalanceError : Error {
    case RateLimitExceeded
    case ApiError
}

class BalanceService {
    let dailyCap = 20
    let minutesBetweenRequests = 5
    let slidingWindowDays = 60
    
    init () {
        
    }
        
    private var isRequestAllowed: Bool {
        return RateLimitService.canMakeRequest(
            methodName: "getBalance",
            dailyCap: dailyCap,
            minutesBetweenRequests: minutesBetweenRequests,
            slidingWindowDays: slidingWindowDays
        )
    }
    
    func getBalance(
        userId: String,
        adunitId: String,
        onReward: @escaping (Reward) -> Void,
        onError: @escaping (Error) -> Void
    ) {
        guard isRequestAllowed else {
            onError(BalanceError.RateLimitExceeded)
            return
        }
        
        let url = Constants.apiBaseURL
            .appendingQueryItems([
                URLQueryItem(name: "adunit_id", value: adunitId)
            ])!
        
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                onError(error)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                onError(BalanceError.ApiError)
                return
            }

            do {
                let balance = try JSONDecoder().decode(Balance.self, from: data!)
                let delta = balance.userLTVInVirtualCurrency - balance.lastSyncUserLTVInVirtualCurrency
                if (delta > 0) {
                    
                    RateLimitService.resetSlidingWindow(
                        methodName: Constants.balanceMethodName
                    )
                    
                    let reward = Reward(
                        totalRevenue: balance.userLTV - balance.lastSyncUserLTV,
                        virtualCurrencyReward: delta
                    )
                    
                    onReward(reward)
                }

            } catch {
                onError(error)
            }
        }.resume()
    }
}
