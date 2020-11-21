/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The model for an individual landmark.
*/

import SwiftUI

struct Stock: Hashable, Codable, Identifiable {
    var id: Int
    var shares: Float
    var ticker: String
    var name: String
    var price: Float
    var change: Float
    var marketValue: Float
    var currentPrice: Float
    var low: Float
    var bidPrice: Float
    var openPrice: Float
    var mid: Float
    var high: Float
    var volume: Float
    var about: String
}


