//
//  ContentView.swift
//  hw9
//
//  Created by Charlie Pyle on 11/17/20.
//

import SwiftUI
import Foundation

struct StockList: View {
    @EnvironmentObject var userData: UserData
    @ObservedObject var searchBar: SearchBar = SearchBar()
    @ObservedObject var stockFetchModel = StockFetchModel()
    @State var searchResults:[StockSearch] = []
    
    var body: some View {
        NavigationView {
            if (!stockFetchModel.dataReceived) {
                ProgressView()
                Text("Fetching Data")
                    .font(.footnote)
                    .foregroundColor(Color.gray)
            }
            else {
                List {
                    if (searchBar.text.isEmpty) {
                        Text(getFormattedDate())
                            .fontWeight(.bold)
                            .font(.title2)
                            .foregroundColor(Color.gray)

                        Section(header: Text("Portfolio")) {
                            let defaults = UserDefaults.standard
                            VStack {
                                Text("Net Worth")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("\(defaults.float(forKey: "netWorth"), specifier: "%.2f")")
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
//                            let defaults = UserDefaults.standard
//                            let purchasedStockStrings = defaults.stringArray(forKey: "purchasedStrings") ?? [String]()

                            ForEach(
//                                userData.purchasedStocksStrings, id: \.self
                                stockFetchModel.stockRows, id: \.ticker
                            ) { stock in
                                let numShares: Float = userData.purchasedStocks[stock.ticker]!
                                NavigationLink(
                                    destination: StockDetail(stockString: stock.ticker)) {
                                    StockRow(stockString: stock.ticker, numShares: numShares, lastPrice: stock.lastPrice!, change: stock.change).environmentObject(userData)
                                }
                            }
                            .onMove(perform:moveStocks)
//                            .onDelete(perform:deleteStocks)
                        }

                        Section(header: Text("Favorites")) {
                            let defaults = UserDefaults.standard
                            let favorites = defaults.stringArray(forKey: "favorites") ?? [String]()
                            
                            ForEach(
//                                userData.favorites, id: \.self
                                favorites, id: \.self
                            ) { stock in
                                let numShares: Float = (userData.purchasedStocks[stock] == nil ? 0.0 : userData.purchasedStocks[stock])!

                                NavigationLink(
                                destination: StockDetail(stockString: stock).environmentObject(userData)) {
                                    StockRow(stockString: stock, numShares: numShares).environmentObject(userData)

                                }
                            }
                            .onMove(perform:moveFavoriteStocks)
                            .onDelete(perform:deleteFavoriteStocks)
                        }
//
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
        }.onAppear {
            
            let defaults = UserDefaults.standard
            defaults.set(20000, forKey: "netWorth")
            defaults.set(20000, forKey: "cash")
            let favoritesArray = defaults.stringArray(forKey: "favorites")
            let purchasedArray = defaults.stringArray(forKey: "purchasedStrings")
            let purchasedDictionary = fetch(key: "purchasedStocks")
            if (favoritesArray != nil) {
                userData.favorites = favoritesArray!
            }
            if (purchasedArray != nil) {
                userData.purchasedStocksStrings = purchasedArray!
            }
            if (purchasedDictionary != nil) {
                userData.purchasedStocks = purchasedDictionary!
            }
            
            var queryString = ""
            
            for string in userData.purchasedStocksStrings {
                let stringToAdd = string.uppercased() + ","
                queryString += stringToAdd
            }
            
            stockFetchModel.updateStockRows(stockString: queryString)
            
            var netWorth = defaults.float(forKey: "cash")
            
            for stockRow in stockFetchModel.stockRows {
                netWorth += Float(Double((stockRow.lastPrice! * userData.purchasedStocks[stockRow.ticker]!)))
            }
            
//            defaults.set(netWorth, forKey: "netWorth")
            
//            userData.netWorth = netWorth
//            defaults.set(userData.netWorth, forKey: "netWorth")
            
            
            
            
        }
        
        
    }
    
    func fetch(key: String) -> [String: Float]? {
        let decoder = JSONDecoder()
        do {
            
            if let storedData = UserDefaults.standard.data(forKey: key) {
                let newArray = try decoder.decode([String: Float].self, from: storedData)
                print("new array: \(newArray)")
                return newArray
            }
        } catch {
            print("couldn't decode array: \(error)")
        }
        return nil
    }
    
    func getFormattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let date = Date()
        dateFormatter.locale = Locale(identifier: "en_US")
        return dateFormatter.string(from: date)
    }
    
    
    func moveStocks(from source: IndexSet, to destination: Int) {
        withAnimation {
//            var stocks:[String] = userData.purchasedStocksStrings
            userData.purchasedStocksStrings.move(fromOffsets: source, toOffset: destination)
            stockFetchModel.stockRows.move(fromOffsets: source, toOffset: destination)
            let defaults = UserDefaults.standard
            defaults.set(userData.purchasedStocksStrings, forKey: "purchasedStrings")
        }
    }
    
    
    func moveFavoriteStocks(from source: IndexSet, to destination: Int) {
        withAnimation {
            userData.favorites.move(fromOffsets: source, toOffset: destination)
            let defaults = UserDefaults.standard
            defaults.set(userData.favorites, forKey: "favorites")
        }
    }
    
    func deleteFavoriteStocks(offsets: IndexSet) {
        withAnimation {
            userData.favorites.remove(atOffsets: offsets)
            let defaults = UserDefaults.standard
            defaults.set(userData.favorites, forKey: "favorites")
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
