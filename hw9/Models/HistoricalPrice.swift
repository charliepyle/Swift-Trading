//
//  HistoricalPrice.swift
//  hw9
//
//  Created by Charlie Pyle on 12/2/20.
//

import Foundation
import SwiftUI

struct HistoricalPrice: Hashable, Codable {
    var dateFormatted: Double
    var open: Float
    var high: Float
    var low: Float
    var close: Float
}
