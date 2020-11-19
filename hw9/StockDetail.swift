//
//  StockView.swift
//  hw9
//
//  Created by Charlie Pyle on 11/17/20.
//

import SwiftUI

struct StockDetail: View {
    @EnvironmentObject var userData: UserData
    var stock: Stock
    
    var body: some View {
        Text(stock.ticker)
    }
}

struct StockDetail_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        StockDetail(stock: userData.stocks[0])
            .environmentObject(userData)
    }
}
