//
//  SearchRow.swift
//  hw9
//
//  Created by Charlie Pyle on 12/1/20.
//

import SwiftUI

struct SearchRow: View {
    var stockSearch: StockSearch
    
    var body: some View {
        VStack {
            Text(stockSearch.ticker)
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(stockSearch.companyName)
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(Color.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct SearchRow_Previews: PreviewProvider {
    static var previews: some View {
        let stockSearch = StockSearch(ticker: "fuck", companyName: "fuck!")
        SearchRow(stockSearch: stockSearch)
    }
}
