//
//  ContentView.swift
//  hw9
//
//  Created by Charlie Pyle on 11/17/20.
//

import SwiftUI

struct StockList: View {
    @State var searchText: String = ""
    @EnvironmentObject private var userData: UserData
//    var stockString = userData.stocks.map { $0.ticker }
//    @State var searchString: String
    
    
    // Search action. Called when search key pressed on keyboard
//        func search() {
//            searchString = ""
//        }
//
//        // Cancel action. Called when cancel button of search bar pressed
//        func cancel() {
//            searchString = ""
//        }
    
    var body: some View {
        NavigationView {
            VStack() {
                SearchBar(text: $searchText, placeholder: "Search cars")
                List {
//                    let stockString = userData.stocks.map { $0.ticker }
                    ForEach(
                        userData.stocks
                            .filter
                        {stock in
                            searchText.isEmpty ||
                                stock.ticker.lowercased().contains(searchText.lowercased())
                        }
                    ) { stock in
                        NavigationLink(
                            destination: StockDetail(stock: stock).environmentObject(self.userData)) {
                            StockRow(stock: stock)
                        }
                    }
                }
                .padding(0.0)
                .navigationBarTitle(Text("Stocks"))
            }
            
        }
//        Text(userData.stocks[1].ticker)
//            .padding()
    }
}

struct StockList_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StockList()
        }
        .environmentObject(UserData())
    }
}
