//
//  UserData.swift
//  hw9
//
//  Created by Charlie Pyle on 11/17/20.
//

import Combine
import SwiftUI

final class UserData: ObservableObject {
    @Published var netWorth = 1000
    @Published var stocks = stockData
    
//    init(stocks: [Stock]) {
//        self.stocks = stockData
//    }
}

