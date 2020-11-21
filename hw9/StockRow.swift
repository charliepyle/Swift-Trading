//
//  StockRow.swift
//  hw9
//
//  Created by Charlie Pyle on 11/17/20.
//

import SwiftUI

struct StockRow: View {
    var stock: Stock
    
    
    var body: some View {
        HStack {
            
            VStack(spacing:0) {
                Text(stock.ticker)
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if (stock.shares.isZero) {
                    Text(stock.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                }
                else {
                    Text("\(stock.shares, specifier: "%.2f") shares")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                }
            }
            .padding()
            
            Spacer()
            
            VStack(spacing:0) {
                Text("\(stock.price, specifier: "%.2f")")
                    .fontWeight(.bold)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                HStack {
                    if (stock.change < 0) {
                        Image(systemName: "arrow.down.right")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        .foregroundColor(Color.red)
                    }
                    if (stock.change > 0) {
                        Image(systemName: "arrow.up.right")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .foregroundColor(Color.green)
                    }
                    
                    Text("\(stock.change, specifier: "%.2f")")
                        .frame(maxWidth: .infinity, alignment: .trailing)
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
                
                
                    
            }
            .padding()
            
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
        Group {
            StockRow(stock: stockData[0])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
    
}
