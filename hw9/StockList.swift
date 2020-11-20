//
//  ContentView.swift
//  hw9
//
//  Created by Charlie Pyle on 11/17/20.
//

import SwiftUI

struct StockList: View {
    @State var searchText: String = ""
    @ObservedObject var userData: UserData = UserData()
    @ObservedObject var searchBar: SearchBar = SearchBar()
//    var stockString = userData.stocks.map { $0.ticker }
//    @State var searchString: String
    
    var body: some View {
        NavigationView {
                
                List {
//                    SearchBar(text: $searchText)
                    
                    
                    Text(getFormattedDate())
                    
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
    //                            destination: StockDetail(stock: stock).environmentObject(self.userData)) {
                            destination: StockDetail(stock: stock)) {
                                StockRow(stock: stock)
                            }
                        }
                        .onMove(perform:moveStocks)
                        .onDelete(perform:deleteStocks)
                    }
                    
                    Section(header: Text("Favorites")) {
                        
                    }
                    
                   
//                    .environmentObject(self.userData)
                    
//                    Text("Favorites")
//                        .multilineTextAlignment(.leading)
//                        .padding([.top, .leading, .bottom], 10)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .background(Color(red: 0.8, green: 0.8, blue: 0.8, opacity: 1.0))
//                        .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.3, opacity: 1.0))
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
//        .environmentObject(UserData())
    }
}
