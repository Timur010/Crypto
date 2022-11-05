//
//  ContentView.swift
//  CryptoSwiftUI
//
//  Created by timur on 11.10.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            
            Color.theme.background
                .ignoresSafeArea()
            VStack {
                Text("Hello, world!")
                    .foregroundColor(Color.theme.green)
                Text("Hello, world!")
                    .foregroundColor(Color.theme.accent)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}
