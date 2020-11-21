//
//  TradeSheet.swift
//  hw9
//
//  Created by Charlie Pyle on 11/20/20.
//

import SwiftUI

struct TradeSheet: View {
    @EnvironmentObject var userData: UserData
    @State var numShares = ""
    @Binding var isPresented: Bool
    var stock: Stock
    var body: some View {
        VStack {
            Button(action: {
                isPresented = false
            }) {
                Image(systemName: "xmark")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            
            Text("Trade \(stock.name) shares")
                .font(.subheadline)
                .fontWeight(.bold)
            
            HStack {
                TextField("0", text: $numShares)
                    .padding()
                    .keyboardType(.decimalPad)
                if (Int(numShares)! <= 1) {
                    Text("Share")
                }
                else {
                    Text("Shares")
                }
            }
            Spacer()
        }
    }
}

struct TradeSheet_Previews: PreviewProvider {
    static var previews: some View {
        let userData = UserData()
        TradeSheet(isPresented: .constant(true), stock: userData.stocks[0]).environmentObject(userData)
    }
}
