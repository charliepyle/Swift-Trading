//
//  StockFetchModel.swift
//  hw9
//
//  Created by Charlie Pyle on 12/1/20.
//

import Foundation
import SwiftUI

class StockFetchModel: ObservableObject {
    var stockString: String = ""
    
    
    @Published var stock: Stock?
    @Published var stockRow: StockRowModel?
    @Published var dataReceived = false
    
    
    func updateStock(stockString: String) {
       
        guard let url = URL(string: "https://hw8-usc.wl.r.appspot.com/api/details/\(stockString)")
        else {
            print("Bad URL")
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                        if let response = try? JSONDecoder().decode(Stock.self, from: data) {
                            DispatchQueue.main.async {
                                self.stock = response
                                self.dataReceived = true
                            }
                            return
                        }
                    }
                }.resume()
        
    }
    
    func updateStockRow(stockString: String) {
        
        guard let url = URL(string: "https://hw8-usc.wl.r.appspot.com/api/tickers/\(stockString)")
        else {
            print("Bad URL")
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                        if let response = try? JSONDecoder().decode(StockRowModel.self, from: data) {
                            DispatchQueue.main.async {
                                self.stockRow = response
                                self.dataReceived = true
                            }
                            return
                        }
                    }
                }.resume()
        
    }
    
    
}
