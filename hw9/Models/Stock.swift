

import SwiftUI

struct Stock: Hashable, Codable {
//    var id: Int
    var ticker: String
    var companyName: String
    var description: String
    var startDate: String
    var date: String
    var lastPrice: Float
    var exchangeCode: String
    var change: String
    var changePercent: String
    var highPrice: Float
    var lowPrice: Float
    var openPrice: Float
    var closePrice: Float
    var volume: Float
    var midPrice: Float?
    var askPrice: Float?
    var askSize: Float?
    var bidPrice: Float?
    var bidSize: Float?
    var news:[News] = []
//    var historicalStockClose:[HistoricalPrice] = []
    var historicalStockClose:[[Float]] = [[]]
//    var historicalStockVolume:[Volume] = []
    var historicalStockVolume:[[Float]] = [[]]
//    var lastDayStockClose:[DayPrice] = []
    var lastDayStockClose:[[Float]] = [[]]
//    var lastDayStockVolume:[Volume] = []
    var lastDayStockVolume:[[Float]] = [[]]
    var stockOpen: Bool
//
//    
//    var shares: Float
//    var name: String
//    var price: Float
//    var change: Float
//    var marketValue: Float
//    var currentPrice: Float
//    var low: Float
//    var bidPrice: Float
//    var openPrice: Float
//    var mid: Float
//    var high: Float
//    var volume: Float
//    var about: String
//    var news:[News] = []
}
