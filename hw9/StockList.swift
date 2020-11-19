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
                
                List {
                    SearchBar(text: $searchText, placeholder: "Search cars")
                    
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
                    .onMove(perform:moveStocks)
                    .onDelete(perform:deleteStocks)
                }
                .navigationBarTitle(Text("Stocks"))
                .toolbar {
                    EditButton()
                }
            
            
        }
        
        
    }
    
    func addStock() {
        withAnimation {
            userData.stocks.append(Stock(id: 11,
                                         shares: 10,
                                   ticker: "fuck!",
            name: "fuck!!",
            price: 10,
            change: 78))
        }
    }
    
    func moveStocks(from: IndexSet, to: Int) {
        withAnimation {
            userData.stocks.move(fromOffsets: from, toOffset: to)
        }
    }
    
    func deleteStocks(offsets: IndexSet) {
        withAnimation {
            userData.stocks.remove(atOffsets: offsets)
        }
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
