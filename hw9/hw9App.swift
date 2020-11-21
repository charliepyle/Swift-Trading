//
//  hw9App.swift
//  hw9
//
//  Created by Charlie Pyle on 11/17/20.
//

import SwiftUI

@main
struct hw9App: App {
    var body: some Scene {
        WindowGroup {
            StockList()
                .environmentObject(UserData())
        }
    }
}
