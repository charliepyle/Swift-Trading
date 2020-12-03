//
//  StockRow.swift
//  hw9
//
//  Created by Charlie Pyle on 12/2/20.
//

import Foundation

struct StockRowModel: Hashable, Codable {
    var ticker: String
    var companyName: String
    var lastPrice: Float?
    var change: String
}
