//
//  Price.swift
//  hw9
//
//  Created by Charlie Pyle on 12/2/20.
//

import Foundation
import SwiftUI

struct DayPrice: Hashable, Codable {
    var dateFormatted: Double
    var close: Float
}
