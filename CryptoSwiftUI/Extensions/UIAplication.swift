//
//  UIAplication.swift
//  CryptoSwiftUI
//
//  Created by timur on 26.10.2022.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
