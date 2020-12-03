//
//  TradeSheet.swift
//  hw9
//
//  Created by Charlie Pyle on 11/20/20.
//

import SwiftUI
import Combine

struct TradeSheet: View {
    @EnvironmentObject var userData: UserData
//    @State var numShares: String? = "0"
    @State var numShares: String = "0"
//    var onDismiss: () -> ()
    @Binding var isPresented: Bool
    @State var transactionMade: Bool = false
    @State var transactionString: String = ""
    
    var stock: Stock
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.isPresented = false
                }) {
                    Image(systemName: "xmark")
                        .padding([.top, .leading])
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                }
                
                
            }
            Text("Trade \(stock.companyName) shares")
                .font(.subheadline)
                .fontWeight(.bold)
            
            Spacer()
            
            HStack {
                TextField("", text: self.$numShares)
                    .padding()
                    .keyboardType(.numberPad)
                    .onReceive(Just(numShares)) { newValue in
                                    var filtered = newValue.filter { "0123456789".contains($0) }
                                    let numDots = newValue.filter { ".".contains($0)}

                                    if filtered != newValue {
                                        if (numDots.count > 1) {
                                            filtered = String(filtered.dropLast())
                                        }
                                        self.numShares = filtered
                                        
                                    }
                    }
                    .font(Font.system(size: 120, design: .default))
                
                VStack {
                    let share = Int(numShares) ?? 0 == 1 ? "Share" : "Shares"
                    Text(share)
                        .padding([.top, .trailing])
                        .font(.largeTitle)
                }
                  
            }
                
            HStack {
                
                Spacer()
                Group {
                    let floatShares = Float(self.numShares) ?? 0.0
                    let multipliedValue = stock.lastPrice * floatShares
                    Text("x \(stock.lastPrice, specifier: "%.2f")/share = $\(multipliedValue, specifier: "%.2f")")
                }
                .padding(.trailing)
                
            }
            
            Spacer()
            
            Text("$\(userData.netWorth, specifier: "%.2f") available to buy \(stock.ticker)")
                .font(.footnote)
                .padding()
                .foregroundColor(.gray)
            
            HStack {
                Button(action: {
                    let doubleNumShares = Float(numShares) ?? 0.0
                    let cost = Float(stock.lastPrice) * doubleNumShares
                    
                    
                
                    userData.purchasedStocks[stock.ticker]! += doubleNumShares
                    
                    userData.netWorth -= Double(cost)
                    
                    transactionMade = true
                    let share = Int(numShares) ?? 0 == 1 ? "share" : "shares"
                    transactionString = "You have successfully bought \(numShares) \(share) of \(stock.ticker)"
                }) {
                    Text("Buy")
                }
                .padding(EdgeInsets(top: 15, leading: 60, bottom: 15, trailing: 60))
                .background(Color.green)
                .foregroundColor(.white)
                .font(.headline).cornerRadius(40)
                .frame(maxWidth: .infinity, alignment: .center)
                
                
                Button(action: {
                    let doubleNumShares = Float(numShares) ?? 0.0
                    let cost = Float(stock.lastPrice) * doubleNumShares
                    
//                    let stock_info = ["purchasedlastPrice": stock.lastPrice, "quantity": Float(self.numShares) ?? 0.0]
                    
//                    var retrieved_stock = userData.purchasedStocks[stock.ticker]
                    userData.netWorth += Double(cost)
                    userData.purchasedStocks[stock.ticker]! -= doubleNumShares
                    
//                    userData.netWorth += cost
                    
                    transactionMade = true
                    let share = Int(numShares) ?? 0 == 1 ? "share" : "shares"
                    transactionString = "You have successfully sold \(numShares) \(share) of \(stock.ticker)"
                }) {
                    Text("Sell")
                }
                .padding(EdgeInsets(top: 15, leading: 60, bottom: 15, trailing: 60))
                .background(Color.green)
                .foregroundColor(.white)
                .font(.headline).cornerRadius(40)
                .frame(maxWidth: .infinity, alignment: .center)
            }
            
                
                
            
            
            Spacer()
                
        }
        .toast(isShowing: $transactionMade, text: Text(transactionString))
    }
    
}

struct TradeSheet_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        let stock = stockData[0]
        TradeSheet(isPresented: .constant(true), stock: stock).environmentObject(userData)
    }
    
}


struct Toast<Presenting>: View where Presenting: View {

    /// The binding that decides the appropriate drawing in the body.
    @Binding var isShowing: Bool
    /// The view that will be "presenting" this toast
    let presenting: () -> Presenting
    /// The text to show
    let text: Text

    var body: some View {

        GeometryReader { geometry in

            ZStack(alignment: .center) {

                self.presenting()
                    .blur(radius: self.isShowing ? 1 : 0)

                VStack {
                    Text("Congratulations!")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding([.top, .leading, .trailing])
                        
                    self.text
                        .font(.footnote)
                        .padding(.top)
                    
                    Spacer()
                    
                    Button(action: {
                        isShowing = false
                    }) {
                        Text("Done")
                    }
                    .padding(EdgeInsets(top: 15, leading: 120, bottom: 15, trailing: 120))
                    .background(Color.white)
                    .foregroundColor(.green)
                    .font(.headline)
                    .cornerRadius(40)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .frame(width: geometry.size.width / 2,
//                       height: geometry.size.height / 5)
                .background(Color.green)
                .foregroundColor(Color.white)
//                .cornerRadius(20)
                .transition(.slide)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                      withAnimation {
                        self.isShowing = false
                      }
                    }
                }
                .opacity(self.isShowing ? 1 : 0)

            }

        }

    }

}

extension View {

    func toast(isShowing: Binding<Bool>, text: Text) -> some View {
        Toast(isShowing: isShowing,
              presenting: { self },
              text: text)
    }

}
