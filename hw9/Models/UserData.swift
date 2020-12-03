//
//  UserData.swift
//  hw9
//
//  Created by Charlie Pyle on 11/17/20.
//

import Combine
import SwiftUI

final class UserData: ObservableObject {
    @Published var netWorth = 20000.00
//    @Published var stocks = stockData
    @Published var favorites:[String] = ["msft", "nvda"]
//    @Published var purchasedStocks: [PurchasedStock] = [PurchasedStock(id: "aapl", numShares: 1), PurchasedStock(id: "tsla", numShares: 1)]
    @Published var purchasedStocks: [String:Float] = ["aapl": 1,
                                                       "tsla": 1]
    @Published var purchasedStocksStrings: [String] = ["aapl", "tsla"]
    @Published var shares = 10
}

