//
//  UserData.swift
//  hw9
//
//  Created by Charlie Pyle on 11/17/20.
//

import Combine
import SwiftUI

final class UserData: ObservableObject {
    @Published var nnetWorth = 1000
    @Published var stockData = stocks
}

