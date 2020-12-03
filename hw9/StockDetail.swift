//
//  StockView.swift
//  hw9
//
//  Created by Charlie Pyle on 11/17/20.
//

import SwiftUI

struct StockDetail: View {
    @EnvironmentObject var userData: UserData
    @ObservedObject var stockFetchModel = StockFetchModel()
    @State private var showMore = false
    @State var showingTrade = false
    @State var changedFavorite: Bool = false
//    @State var removedFavorite: Bool = false
    @State var transactionString: String = ""
    @Environment(\.openURL) var openURL
    @State var stock: Stock = stockData[0]
    
    var rows: [GridItem] =
        Array(repeating: .init(.flexible()), count: 3)
    var stockString: String
    
    init(stockString: String) {
        self.stockString = stockString

        stockFetchModel.updateStock(stockString: stockString)
    }
    
    var body: some View {
        if (!stockFetchModel.dataReceived) {
            ProgressView()
            Text("Fetching Data...")
                .font(.footnote)
                .foregroundColor(Color.gray)
        }
        else {
            ScrollView(.vertical) {
                VStack {
                    Text(stockFetchModel.stock!.companyName)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                        .padding(.leading)
                    HStack(alignment: .lastTextBaseline) {
                        Text("$\(stockFetchModel.stock!.lastPrice, specifier: "%.2f")")
                            .fontWeight(.bold)
                            .font(.title)
                            .padding(.leading)
                        Text("($\(Float(stockFetchModel.stock!.change)!, specifier: "%.2f"))")
                            .font(.subheadline)
                            .if(Float(stockFetchModel.stock!.change)! < 0) {
                                $0.foregroundColor(Color.red)
                            }
                            .if(Float(stockFetchModel.stock!.change)! == 0) {
                                $0.foregroundColor(Color.black)
                            }
                            .if(Float(stockFetchModel.stock!.change)! > 0) {
                                $0.foregroundColor(Color.green)
                            }
                    }
                        .frame(maxWidth: .infinity, alignment: .leading)

        //            Chart will go here

                    Text("Portfolio")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding([.leading, .bottom, .top])

                    HStack {
//                        if (userData.purchasedStocks[stock.ticker] == 0) {
//                        let hasStock = userData.purchasedStocks[stock.ticker]
                        let dictionary = fetch(key: "purchasedStocks")
                        let hasStock: Float = (userData.purchasedStocks[stockFetchModel.stock!.ticker] == nil ? 0.0 : userData.purchasedStocks[stockFetchModel.stock!.ticker])!
//                        let hasStock = ((dictionary == nil || dictionary![stock.ticker] == nil) ? 0 : dictionary![stock.ticker])
//                        if dictionary != nil {
//                            hasStock = dictionary[stock.ticker]
//                        }
                       
//                        let netWorth = (hasStock == nil ? 0 : hasStock! * stockFetchModel.stock!.lastPrice)
                        
                        let netWorth = hasStock * stockFetchModel.stock!.lastPrice
                        if (dictionary == nil || hasStock == 0) {
                            VStack {
                                Text("You have 0 shares of \(stockFetchModel.stock!.ticker).")
                                    .font(.footnote)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading)

                                Text("Start trading!")
                                    .font(.footnote)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading)
                            }
                        }

                        else {
                            VStack {
                                Text("Shares Owned: \(hasStock, specifier: "%.4f")")
                                    .font(.footnote)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading)

                                Text("Market Value: \(netWorth, specifier: "%.2f")")
                                    .font(.footnote)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading)
                            }
                        }

                        Spacer()

                        Button(action: {
                            showingTrade = true
                        }) {
                            Text("Trade!")
                        }.sheet(isPresented: $showingTrade) {
                            TradeSheet(isPresented: self.$showingTrade,
        //                    isPresented: self.$showingTrade,
                                       stock: stockFetchModel.stock!).environmentObject(userData)
                        }
                        .padding(EdgeInsets(top: 15, leading: 50, bottom: 15, trailing: 50))
                        .background(Color.green)
                        .foregroundColor(.white)
                        .font(.headline).cornerRadius(40)
                        .frame(maxWidth: .infinity, alignment: .center)


                    }




                    Group {
                        Text("Stats")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.top, .leading, .bottom])

                        ScrollView(.horizontal) {
                            LazyHGrid(rows: rows) {
                                Text("Current Price: \(stockFetchModel.stock!.lastPrice, specifier: "%.2f")")
                                    .font(.caption2)
                                    .padding(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Open Price: \(stockFetchModel.stock!.openPrice, specifier: "%.2f")")
                                    .font(.caption2)
                                    .padding(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("High Price: \(stockFetchModel.stock!.highPrice, specifier: "%.2f")")
                                    .font(.caption2)
                                    .padding(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Low: \(stockFetchModel.stock!.lowPrice, specifier: "%.2f")")
                                    .font(.caption2)
                                    .padding(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Mid: \(stockFetchModel.stock!.midPrice ?? 0, specifier: "%.2f")")
                                    .font(.caption2)
                                    .padding(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Volume: \(stockFetchModel.stock!.volume, specifier: "%.2f")")
                                    .font(.caption2)
                                    .padding(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("Bid Price: \(stockFetchModel.stock!.bidPrice ?? 0, specifier: "%.2f")")
                                    .font(.caption2)
                                    .padding(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }


                    }


                    Group {
                        Text("About")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.top, .bottom, .leading])

                        if showMore == false {
                            Text(stockFetchModel.stock!.description)
                                .font(.caption2)
                                .padding([.leading, .trailing])
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                            Button(action: {
                                showMore.toggle()

                            }) {
                                Text("Show more...")
                                    .foregroundColor(.gray)
                                    .padding([.trailing])
                                    .font(.caption2)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                        else {
                            Text(stockFetchModel.stock!.description)
                                .font(.caption2)
                                .padding([.leading, .trailing])
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Button(action: {
                                showMore.toggle()

                            }) {
                                Text("Show less")
                                    .foregroundColor(.gray)
                                    .padding([.trailing])
                                    .font(.caption2)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }

                        }

                    }

                    Group {
                        Text("News")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding([.top, .leading])

                        ForEach(stockFetchModel.stock!.news, id: \.url) { n in
                            NewsRow(news: n)
                                .contextMenu {
                                    Button(action: {
                                        let escapedShareString = n.url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

                                        let url = URL(string: escapedShareString)
                                        UIApplication.shared.open(url!)

                                    }) {
                                        Label("Open in Safari", systemImage: "safari")
                                    }
                                    Button(action: {
                                        let shareString = "Check out this link:"
                                        let twitterURL = n.url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                                        let hashtags = "CSCI571StockApp".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                                        let stringToOpen = "https://twitter.com/intent/tweet?text=\(shareString)&url=\(twitterURL)&hashtags=\(hashtags)"

                                        let escapedShareString = stringToOpen.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!

                                        let url = URL(string: escapedShareString)
                                        UIApplication.shared.open(url!)
                                    }) {
                                        Label("Share on Twitter", systemImage: "square.and.arrow.up")
                                    }
                                }.background(Color.white)
                        }
                        
                        
                        
                    }

                    .toolbar {
                        if userData.favorites.contains(stockFetchModel.stock!.ticker) {
                            Button(action: {
                                if let index = userData.favorites.firstIndex(of: stockFetchModel.stock!.ticker) {
                                    userData.favorites.remove(at: index)
                                    userData.updateStockRowFavorites()
                                }
                                
                                changedFavorite = true
                                
                                self.transactionString = "Removing \(stockFetchModel.stock!.ticker) from favorites"
//                                self.removedFavorite = true
                                
                                
                                let defaults = UserDefaults.standard
                                defaults.set(userData.favorites, forKey: "favorites")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                  withAnimation {
                                    changedFavorite = false
                                  }
                                }
                            }) {
                                    Image(systemName: "plus.circle.fill")
                            }
                        }
                        else {
                            Button(action: {
                                userData.favorites.append(stockFetchModel.stock!.ticker)
                                
                                changedFavorite = true
                                self.transactionString = "Adding \(stockFetchModel.stock!.ticker) to favorites"
//                                self.addedFavorite = true
                                
                                let defaults = UserDefaults.standard
                                defaults.set(userData.favorites, forKey: "favorites")
                                userData.updateStockRowFavorites()
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                  withAnimation {
                                    changedFavorite = false
                                  }
                                }
                                
                            }) {
                                Image(systemName: "plus.circle")
                            }
                        }
                    }

                    .navigationBarTitle(Text(stockFetchModel.stock!.ticker))


                    Spacer()

                }
//                .toast(isShowing: Constant.false, text: Text(transactionString), successToast: true)
                
//                .toast(isShowing: $removedFavorite, text: Text(transactionString), successToast: false)
            }.toast(isShowing: $changedFavorite, text: Text(transactionString), successToast: false)
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
}

struct StockDetail_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        StockDetail(stockString: stockData[0].ticker)
            .environmentObject(userData)
    }
}

