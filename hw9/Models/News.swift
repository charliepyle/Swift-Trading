//
//  News.swift
//  hw9
//
//  Created by Charlie Pyle on 12/1/20.
//

import Foundation
import SwiftUI

struct News: Hashable, Codable {
    var url: String
    var title: String
    var description: String
    var source: String
    var urlToImage: String
    var publishedAt: String
}
