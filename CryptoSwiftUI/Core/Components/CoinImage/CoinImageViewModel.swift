//
//  CoinImageViewModel.swift
//  CryptoSwiftUI
//
//  Created by timur on 18.10.2022.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private let coin: Coin
    private let dataService: CoinImageService
    private var cancellable = Set<AnyCancellable>()
    
    init(coin: Coin) {
        self.coin = coin
        self.dataService = CoinImageService(coin: coin)
        self.addSubscription()
        self.isLoading = true
    }
    
    private func addSubscription() {
        dataService.$image
            .sink { [weak self] (_) in
                self?.isLoading = false
            } receiveValue: { [weak self] returnImage in
                self?.image = returnImage
            }
            .store(in: &cancellable)

    }
}
