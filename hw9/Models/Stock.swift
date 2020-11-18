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
}


