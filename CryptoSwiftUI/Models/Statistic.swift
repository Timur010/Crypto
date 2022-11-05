//
//  Statistic.swift
//  CryptoSwiftUI
//
//  Created by timur on 26.10.2022.
//

import Foundation

struct Statistic: Identifiable{
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}
