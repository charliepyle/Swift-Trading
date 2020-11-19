//
//  StockRow.swift
//  hw9
//
//  Created by Charlie Pyle on 11/17/20.
//

import SwiftUI

struct StockRow: View {
    var stock: Stock
    
//    @State var negative:Bool = self.stock.change < 0
    
    var body: some View {
        HStack {
            
            VStack {
                Text(stock.ticker)
                if (stock.shares.isZero) {
                    Text(stock.name)
                        .multilineTextAlignment(.leading)
                }
                else {
                    Text(String(describing: stock.shares))
                        .multilineTextAlignment(.leading)
                }
            }
            .padding()
            
            Spacer()
            
            VStack {
                Text(String(describing: stock.price))
                    .multilineTextAlignment(.trailing)
                    
                HStack {
//                    let image: UIImage? = UIImage(named: "diagonal")
//                    UIImageView(UIImage(named:"diagonal"))
//                    image
//                    Image(systemName: ')
                    if (stock.change < 0) {
                        Image(systemName: "arrow.down.right")
                        .foregroundColor(Color.red)
                    }
                    if (stock.change > 0) {
                        Image(systemName: "arrow.up.right")
                        .foregroundColor(Color.green)
                    }
                    
                    Text(String(describing: stock.change))
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
                
//                    .multilineTextAlignment(.trailing)
                    
            }
            .padding()
            
        }
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
