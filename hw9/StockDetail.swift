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
    @Environment(\.openURL) var openURL
    @State var stock: Stock = stockData[0]
    
    var rows: [GridItem] =
        Array(repeating: .init(.flexible()), count: 3)
    var stockString: String
    
    init(stockString: String) {
        self.stockString = stockString
        
        stockFetchModel.updateStock(stockString: stockString)
//        print(stockFetchModel.stock)
    }
    
    var body: some View {
        if (!stockFetchModel.dataReceived) {
            Text("Fuck!")
        }
        else {
            ScrollView(.vertical) {
                VStack {
                    Text(stockFetchModel.stock!.ticker)
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
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
                        if (true) {
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
                                Text("Shares Owned: \(userData.shares, specifier: "%.4f")")
                                    .font(.footnote)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading)

                                Text("Market Value: \(stockFetchModel.stock!.lastPrice, specifier: "%.2f")")
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
                                Text("Bid Price: \(stockFetchModel.stock!.bidPrice, specifier: "%.2f")")
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
//
//                        let n:News =  News(
//                            url: "Google.com",
//                            title: "Microsoft will reported allow employees to work from home permanently, the latest tech giant to ",
//                            description: "desc",
//                            source: "google.com",
//                            urlToImage: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/93/Golden_Retriever_Carlos_%2810581910556%29.jpg/440px-Golden_Retriever_Carlos_%2810581910556%29.jpg",
//                            publishedAt: "today"
//                        )
                       
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
                                        let shareString = "Check out this link:".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
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
                        Button(action: {
                            userData.favorites.append(stockFetchModel.stock!)
                        }) {
                            Image(systemName: "plus.circle")
                        }
                    }




                    Spacer()

                }
            }
        }
            
        
        
    }
}

struct StockDetail_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        StockDetail(stockString: userData.stocks[0].ticker)
            .environmentObject(userData)
    }
}
