//
//  ContentView.swift
//  hw9
//
//  Created by Charlie Pyle on 11/17/20.
//

import SwiftUI

struct StockList: View {
    @EnvironmentObject var userData: UserData
    @ObservedObject var searchBar: SearchBar = SearchBar()
    @State var searchResults:[StockSearch] = []
    
    var body: some View {
        NavigationView {
                
                List {
                    
                    if (searchBar.text.isEmpty) {
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
                                userData.stocks, id: \.ticker
                            ) { stock in
                                NavigationLink(
                                    destination: StockDetail(stockString: stock.ticker)) {
                                    StockRow(stock: stock).environmentObject(userData)
                                }
                            }
                            .onMove(perform:moveStocks)
                            .onDelete(perform:deleteStocks)
                        }
                        
                        Section(header: Text("Favorites")) {
                            ForEach(
                                userData.favorites, id: \.ticker
                            ) { stock in
                                NavigationLink(
                                destination: StockDetail(stockString: stock.ticker).environmentObject(userData)) {
                                    StockRow(stock: stock).environmentObject(userData)
                                        
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
                    
                    else {
                        Section {
                            ForEach(
                                searchBar.searchResults, id: \.ticker) { stock in
                                
                                NavigationLink(
                                    
                                    destination: StockDetail(stockString: stock.ticker).environmentObject(userData)) {
                                    SearchRow(stockSearch: stock)
                                }
                            }
                        }
                    }

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
