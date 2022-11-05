//
//  CoinDataService.swift
//  CryptoSwiftUI
//
//  Created by timur on 15.10.2022.
//u

import Combine
import Foundation

class CoinDataService {
    @Published var allCoins: [Coin] = []
    var coinSubscription: AnyCancellable?

    init() {
        getCoin()
    }

    private func getCoin() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }

        coinSubscription = NetworkingManager.download(url: url)
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self]returnCoins in
                self?.allCoins = returnCoins
                self?.coinSubscription?.cancel()
            })
    }
}
