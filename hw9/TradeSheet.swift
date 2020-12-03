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
            let defaults = UserDefaults.standard
            let cash = defaults.float(forKey: "cash")
            Text("$\(cash, specifier: "%.2f") available to buy \(stock.ticker)")
                .font(.footnote)
                .padding()
                .foregroundColor(.gray)
            
            HStack {
                Button(action: {
                    let doubleNumShares = Float(numShares) ?? 0.0
                    let cost = Float(stock.lastPrice) * doubleNumShares
                    
//                    let checkArray = fetch(key: stock.ticker)
//
//
                    let defaults = UserDefaults.standard
                    userData.purchasedStocks = fetch(key: "purchasedStocks")!
                    
                    if (userData.purchasedStocks[stock.ticker] == nil) {
                        userData.purchasedStocks[stock.ticker] = doubleNumShares
                        userData.stockRows.append(StockRowModel(ticker: stock.ticker, companyName: stock.companyName, lastPrice: stock.lastPrice, change: stock.change))
                    }
                    else {
                        userData.purchasedStocks[stock.ticker]! += doubleNumShares
                    }
                    
                    var cash = defaults.float(forKey: "cash")
                    cash -= Float(cost)
                    

                    defaults.set(cash, forKey: "cash")
                    
                    if !userData.purchasedStocksStrings.contains(stock.ticker) {
                        userData.purchasedStocksStrings.append(stock.ticker)
                    }
                    defaults.set(userData.purchasedStocksStrings, forKey: "purchasedStrings")
                    
                    store(dictionary: userData.purchasedStocks, key: "purchasedStocks")
                    
                    
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
                    
                    let defaults = UserDefaults.standard
                    
                    userData.purchasedStocks = fetch(key: "purchasedStocks")!
                    
                    userData.purchasedStocks[stock.ticker]! -= doubleNumShares
                    
                    

                    var cash = defaults.float(forKey: "cash")
                    cash += Float(cost)
                    

                    defaults.set(cash, forKey: "cash")
                    print(userData.purchasedStocks[stock.ticker]!)
                    if Int(userData.purchasedStocks[stock.ticker]!) == 0 {
                        if let index = userData.purchasedStocksStrings.firstIndex(of: stock.ticker) {
                            userData.purchasedStocksStrings.remove(at: index)
                        }
                        
                        defaults.set(userData.purchasedStocksStrings, forKey: "purchasedStrings")
                        
                        userData.purchasedStocks.removeValue(forKey: stock.ticker)
                        
                        store(dictionary: userData.purchasedStocks, key: "purchasedStocks")
                    }
                    else {
                        store(dictionary: userData.purchasedStocks, key: "purchasedStocks")
                    }
                    
                    
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
    
    func store(dictionary: [String: Float], key: String) {
        var data: Data?
        let encoder = JSONEncoder()
        do {
            data = try encoder.encode(dictionary)
        } catch {
            print("failed to get data")
        }
        UserDefaults.standard.set(data, forKey: key)
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
