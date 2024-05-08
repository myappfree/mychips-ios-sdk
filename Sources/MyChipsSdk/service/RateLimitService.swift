
import Foundation

class RateLimitService {
    
    private static let storagePrefix = "my_chips_sdk_rls"
    
    public static func canMakeRequest(
        methodName: String,
        dailyCap: Int,
        minutesBetweenRequests: Int,
        slidingWindowDays: Int
    ) -> Bool {
        let methodPrefix = storagePrefix + "_" + methodName
        
        var dailyCount: Int {
            get { UserDefaults.standard.integer(forKey: methodPrefix + "_daily_count") }
            set { UserDefaults.standard.set(newValue, forKey: methodPrefix  + "_daily_count") }
        }
        
        var lastRequestTime: Int {
            get { UserDefaults.standard.integer(forKey: methodPrefix + "_last_request_time") }
            set { UserDefaults.standard.set(newValue, forKey: methodPrefix + "_last_request_time") }
        }
        
        var slidingWindowStartTime: Int {
            get { UserDefaults.standard.integer(forKey: methodPrefix + "_sliding_window") }
            set { UserDefaults.standard.set(newValue, forKey: methodPrefix + "_sliding_window") }
        }
        
        let currentTime = Int(Date().timeIntervalSince1970 * 1000)
        if (slidingWindowStartTime == 0 || currentTime - slidingWindowStartTime > slidingWindowDays * 24 * 60 * 60 * 1000) {
            return false
        }
        
        if (!RateLimitService.isSameDay(time1: lastRequestTime, time2: currentTime)) {
            dailyCount = 0
        }
        
        if (dailyCount >= dailyCap) {
            return false
        }
        
        if (currentTime - lastRequestTime < minutesBetweenRequests * 60 * 1000) {
            return false
        }
        
        //all checks passed
        lastRequestTime = currentTime
        dailyCount = dailyCount + 1
        return true

    }
    
    public static func resetSlidingWindow(methodName: String) {
        let currentTime = Int(Date().timeIntervalSince1970 * 1000)
        let slidingWindowKey = storagePrefix + "_" + methodName + "_sliding_window"
        UserDefaults.standard.set(currentTime, forKey: slidingWindowKey)
    }
    
    private static func isSameDay(time1: Int, time2: Int) -> Bool {
        let date1 = Date(timeIntervalSince1970: TimeInterval(time1 / 1000))
        let date2 = Date(timeIntervalSince1970: TimeInterval(time2 / 1000))
        
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date1)
        let components2 = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date2)
        
        return components1.year == components2.year &&
               components1.month == components2.month &&
               components1.day == components2.day

    }

}
