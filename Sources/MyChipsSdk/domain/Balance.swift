import Foundation

struct Balance: Decodable {
    let userLTV: Double
    let lastSyncUserLTV: Double
    let publisherLTV: Double
    let lastSyncPublisherLTV: Double
    let userLTVInVirtualCurrency: Double
    let lastSyncUserLTVInVirtualCurrency: Double

    enum CodingKeys: String, CodingKey {
        case userLTV
        case lastSyncUserLTV
        case publisherLTV
        case lastSyncPublisherLTV
        case userLTVInVirtualCurrency
        case lastSyncUserLTVInVirtualCurrency
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userLTV = try container.decodeIfPresent(Double.self, forKey: .userLTV) ?? 0
        lastSyncUserLTV = try container.decodeIfPresent(Double.self, forKey: .lastSyncUserLTV) ?? 0
        publisherLTV = try container.decodeIfPresent(Double.self, forKey: .publisherLTV) ?? 0
        lastSyncPublisherLTV = try container.decodeIfPresent(Double.self, forKey: .lastSyncPublisherLTV) ?? 0
        userLTVInVirtualCurrency = try container.decodeIfPresent(Double.self, forKey: .userLTVInVirtualCurrency) ?? 0
        lastSyncUserLTVInVirtualCurrency = try container.decodeIfPresent(Double.self, forKey: .lastSyncUserLTVInVirtualCurrency) ?? 0
    }
}
