//
//  ContentView.swift
//  hw9
//
//  Created by Charlie Pyle on 11/17/20.
//

import SwiftUI

struct StockList: View {
    @State var searchText: String = ""
//    @ObservedObject var userData: UserData = UserData()
    @EnvironmentObject var userData: UserData
    @ObservedObject var searchBar: SearchBar = SearchBar()
    
    var body: some View {
        NavigationView {
                
                List {
                    
                    
                    Text(getFormattedDate())
                        .fontWeight(.bold)
                        .font(.title2)
                        .foregroundColor(Color.gray)
                    
                    Section(header: Text("Portfolio")) {
                        VStack {
                            Text("Net Worth")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("\(userData.netWorth, specifier: "%.2f")")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        ForEach(
                            userData.stocks
                                .filter
                            {stock in
                                    searchBar.text.isEmpty ||
                                        stock.ticker.lowercased().contains(searchBar.text.lowercased())
                            }
                        ) { stock in
                            NavigationLink(
                            destination: StockDetail(stock: stock)) {
                                StockRow(stock: stock)
                            }
                        }
                        .onMove(perform:moveStocks)
                        .onDelete(perform:deleteStocks)
                    }
                    
                    Section(header: Text("Favorites")) {
                        ForEach(
                            userData.favorites
                                .filter
                            {stock in
                                    searchBar.text.isEmpty ||
                                        stock.ticker.lowercased().contains(searchBar.text.lowercased())
                            }
                        ) { stock in
                            NavigationLink(
                            destination: StockDetail(stock: stock).environmentObject(userData)) {
                                StockRow(stock: stock)
                                    
                            }
                        }
                        .onMove(perform:moveStocks)
                        .onDelete(perform:deleteStocks)
                    }
                    
                    Link("Powered by Tiingo", destination: URL(string: "https://www.tiingo.com")!)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .font(.footnote)
                        .foregroundColor(Color.gray)

                }
                .navigationBarTitle(Text("Stocks"))
                .add(self.searchBar)
                .toolbar {
                    EditButton()
                }
        }
        
        
    }
    
    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let date = Date()
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
    
    func addStock() {
        withAnimation {
            userData.stocks.append(Stock(id: 11,
                                         shares: 10,
                                   ticker: "fuck!",
            name: "fuck!!",
            price: 10,
            change: 78,
            marketValue: 10000,
            currentPrice: 100000,
            low: 100000,
            bidPrice: 100000,
            openPrice: 100000,
            mid: 100000,
            high: 10,
            volume: 10,
            about: "about"))
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
            StockList().environmentObject(UserData())
        }
    }
}
