//
//  Model.swift
//  CryptoTradeSimulator
//
//  Created by Kuba on 24/05/2020.
//  Copyright © 2020 Kuba. All rights reserved.
//

import Foundation

struct Pocket {
    var name: String
    var value: Float
    var number: Double
    
    init(name: String, value: Float, number: Double) {
        self.name = name
        self.value = value
        self.number = number
    }
}
