//
//  StockRow.swift
//  hw9
//
//  Created by Charlie Pyle on 11/17/20.
//

import SwiftUI

struct StockRow: View {
//    var stockString: String
    var numShares: Float
//    var lastPrice: Float?
//    var change: String?
    var stockRowModel: StockRowModel
    @ObservedObject var stockFetchModel = StockFetchModel()
    @EnvironmentObject var userData: UserData
    
    
    init(stockRowModel: StockRowModel, numShares: Float) {
        self.stockRowModel = stockRowModel
//        self.stockString = stockRowModel.ticker
        self.numShares = numShares
//        self.lastPrice = lastPrice
//        self.change = change
//        stockFetchModel.dataReceived = true
//        stockFetchModel.updateStockRow(stockString: stockString)
    }
    
    var body: some View {
        if (!userData.dataReceived) {
            ProgressView()
            Text("Fetching Data...")
                .font(.footnote)
                .foregroundColor(Color.gray)
        }
        else {
            HStack {

                VStack(spacing:0) {
//                    Text(stockFetchModel.stockRow!.ticker)
                    Text(self.stockRowModel.ticker)
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
    //                if (stock.shares.isZero) {
                    if (numShares == 0) {
                        Text(self.stockRowModel.companyName)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.subheadline)
                            .foregroundColor(Color.gray)
                    }
                    else {
                        Text("\(self.numShares, specifier: "%.2f") shares")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.subheadline)
                            .foregroundColor(Color.gray)
                    }
                }
                .padding()
                
                Spacer()
                
                VStack(spacing:0) {
//                    let lastPrice = (self.lastPrice == nil ? stockFetchModel.stockRow!.lastPrice! : self.lastPrice)
//                    let change = (self.change == nil ? stockFetchModel.stockRow!.change : self.change)
                    Text("\(self.stockRowModel.lastPrice!, specifier: "%.2f")")
                        .fontWeight(.bold)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        
                    HStack {
                        if (Float(self.stockRowModel.change)! < 0) {
                            Image(systemName: "arrow.down.right")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            .foregroundColor(Color.red)
                        }
                        if (Float(self.stockRowModel.change)! > 0) {
                            Image(systemName: "arrow.up.right")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .foregroundColor(Color.green)
                        }
                        
                        Text("\(Float(self.stockRowModel.change)!, specifier: "%.2f")")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.subheadline)
                            .if(Float(self.stockRowModel.change)! < 0) {
                                $0.foregroundColor(Color.red)
                            }
                            .if(Float(self.stockRowModel.change)! == 0) {
                                $0.foregroundColor(Color.black)
                            }
                            .if(Float(self.stockRowModel.change)! > 0) {
                                $0.foregroundColor(Color.green)
                            }
                    }
                             
                }
                .padding()
                
            }
        }
        
    }
}

extension View {
  @ViewBuilder
  func `if`<Transform: View>(
    _ condition: Bool,
    transform: (Self) -> Transform
  ) -> some View {
    if condition {
      transform(self)
    } else {
      self
    }
  }
}

struct StockRow_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        Group {
            StockRow(stockRowModel: userData.stockRows[0], numShares: 0)
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
    
}
