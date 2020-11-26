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
    @Published var stocks = stockData
    @Published var favorites:[Stock] = []
    @Published var purchasedStocks: [String:Double] = [:]
}

