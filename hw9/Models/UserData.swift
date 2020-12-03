//
//  UserData.swift
//  hw9
//
//  Created by Charlie Pyle on 11/17/20.
//

import Combine
import SwiftUI

final class UserData: ObservableObject {
    @Published var netWorth: Float = 0
    @Published var cash: Float = 0
    @Published var favorites:[String] = []
    @Published var purchasedStocks: [String:Float] = [:]
    @Published var purchasedStocksStrings: [String] = []
    @Published var stockRows: [StockRowModel] = []
    @Published var stockRowFavorites: [StockRowModel] = []
    @Published var dataReceived = false
    
    func updateStockRows() {
        self.dataReceived = false
        var stockString = ""
        for string in self.purchasedStocksStrings {
            stockString += (string + ",")
        }
        guard let url = URL(string: "https://hw8-usc.wl.r.appspot.com/api/tickers/\(stockString)")
        else {
            print("Bad URL")
            return
        }
//        let defaults = UserDefaults.standard
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                        if let response = try? JSONDecoder().decode([StockRowModel].self, from: data) {
                            DispatchQueue.main.async {
                                self.stockRows = response
//                                eventually plan to put global var here for stocks to render
                                self.dataReceived = true
                                self.calculateNetWorth()
                            }
                            return
                        }
                    }
                }.resume()
        
    }
    
    func updateStockRowFavorites() {
        self.dataReceived = false
        self.stockRowFavorites.removeAll()
//        let defaults = UserDefaults.standard
//        let stringArray = defaults.stringArray(forKey: "favorites")
        for stockString in self.favorites {
            guard let url = URL(string: "https://hw8-usc.wl.r.appspot.com/api/ticker/\(stockString)")
            else {
                print("Bad URL")
                return
            }
    //        let defaults = UserDefaults.standard
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                            if let response = try? JSONDecoder().decode(StockRowModel.self, from: data) {
                                DispatchQueue.main.async {
                                    self.stockRowFavorites.append(response)
    //                                eventually plan to put global var here for stocks to render
                                    self.dataReceived = true
                                    self.calculateNetWorth()
                                }
                                return
                            }
                        }
                    }.resume()
        }
        
        
    }
    
    func calculateNetWorth() {
        var netWorth = self.cash
        for stock in self.stockRows {
            let price = stock.lastPrice!
            let quantity = self.purchasedStocks[stock.ticker]
            netWorth += (price * quantity!)
        }
        self.netWorth = netWorth
        let defaults = UserDefaults.standard
        defaults.set(netWorth, forKey: "netWorth")
    }
    
    func store(dictionary: [String: Float], key: String) {
        var data: Data?
        let encoder = JSONEncoder()
        do {
            data = try encoder.encode(dictionary)
        } catch {
            print("failed to get data")
        }
        UserDefaults.standard.set(data, forKey: key)
    }
}

