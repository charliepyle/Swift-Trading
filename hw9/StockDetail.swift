//
//  StockView.swift
//  hw9
//
//  Created by Charlie Pyle on 11/17/20.
//

import SwiftUI

struct StockDetail: View {
    @EnvironmentObject var userData: UserData
    @State private var showMore = false
    var rows: [GridItem] =
        Array(repeating: .init(.flexible()), count: 3)
    var stock: Stock
    
    var body: some View {
        VStack {
            Text(stock.ticker)
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            Text(stock.name)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.subheadline)
                .foregroundColor(Color.gray)
                .padding(.leading)
            HStack(alignment: .lastTextBaseline) {
                Text("$\(stock.price, specifier: "%.2f")")
                    .fontWeight(.bold)
                    .font(.title)
                    .padding(.leading)
                Text("($\(stock.change, specifier: "%.2f"))")
                    .font(.subheadline)
                    .if(stock.change < 0) {
                        $0.foregroundColor(Color.red)
                    }
                    .if(stock.change == 0) {
                        $0.foregroundColor(Color.black)
                    }
                    .if(stock.change > 0) {
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
                if (stock.shares == 0) {
                    VStack {
                        Text("You have 0 shares of \(stock.ticker).")
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
                        Text("Shares Owned: \(stock.shares, specifier: "%.2f")")
                            .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                        
                        Text("Market Value: \(stock.marketValue, specifier: "%.2f")")
                            .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                    }
                }
                
                Button(action: {
                        showMore = !showMore

                }) {
                    Text("Trade!")
                        
                }
                .padding(.all, 27.0)
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
                        Text("Current Price: \(stock.currentPrice, specifier: "%.2f")")
                            .font(.caption2)
                            .padding(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Open Price: \(stock.openPrice, specifier: "%.2f")")
                            .font(.caption2)
                            .padding(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("High Price: \(stock.high, specifier: "%.2f")")
                            .font(.caption2)
                            .padding(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Low: \(stock.low, specifier: "%.2f")")
                            .font(.caption2)
                            .padding(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Mid: \(stock.mid, specifier: "%.2f")")
                            .font(.caption2)
                            .padding(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Volume: \(stock.volume, specifier: "%.2f")")
                            .font(.caption2)
                            .padding(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Bid Price: \(stock.bidPrice, specifier: "%.2f")")
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
                    Text(stock.about)
                        .font(.caption2)
                        .padding([.leading, .trailing])
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                    Button(action: {
                            showMore = !showMore

                    }) {
                        Text("Show more...")
                            .foregroundColor(.gray)
                            .padding([.trailing])
                            .font(.caption2)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                else {
                    Text(stock.about)
                        .font(.caption2)
                        .padding([.leading, .trailing])
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Button(action: {
                            showMore = !showMore

                    }) {
                        Text("Show less")
                            .foregroundColor(.gray)
                            .padding([.trailing])
                            .font(.caption2)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }

                }
                
            }
            
            
            Spacer()
        }
    }
}

struct StockDetail_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        StockDetail(stock: userData.stocks[0])
            .environmentObject(userData)
    }
}
