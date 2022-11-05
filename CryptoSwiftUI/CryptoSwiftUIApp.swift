//
//  CryptoSwiftUIApp.swift
//  CryptoSwiftUI
//
//  Created by timur on 11.10.2022.
//

import SwiftUI

@main
struct CryptoSwiftUIApp: App {
    
    @StateObject private var vm = HomeViewModel()
    
    init () {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]

    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }
}
