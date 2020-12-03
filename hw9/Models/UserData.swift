//
//  UserData.swift
//  hw9
//
//  Created by Charlie Pyle on 11/17/20.
//

import Combine
import SwiftUI

final class UserData: ObservableObject {
//    @Published var netWorth: Float
//    @Published var cash: Float
    @Published var favorites:[String] = []
    @Published var purchasedStocks: [String:Float] = [:]
    @Published var purchasedStocksStrings: [String] = []
}

