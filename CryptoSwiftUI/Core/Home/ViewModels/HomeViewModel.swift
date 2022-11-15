//
//  HomeViewModel.swift
//  CryptoSwiftUI
//
//  Created by timur on 12.10.2022.
//

import Foundation
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistics: [Statistic] = []
    
    @Published var allCoins: [Coin] = []
    @Published var portfolioCoin: [Coin] = []
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""
    
    private let coinDataServices = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        addSubscriber()
    }
    
    func addSubscriber() {
        //  updates allCoins
        $searchText
            .combineLatest(coinDataServices.$allCoins)
//            .debounce(for: .second(0.5), scheduler: )
            .map(filterCoin)
            .sink { [weak self] (returnedCoin) in
                self?.allCoins = returnedCoin
            }
            .store(in: &cancellable)
        
        // update PortfolioCoins
        $allCoins
            .combineLatest(portfolioDataService.$saveEntities)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] (returnCoin) in
                self?.portfolioCoin = returnCoin
            }
            .store(in: &cancellable)
        
        marketDataService.$marketData
            .combineLatest($portfolioCoin)
            .map(mapGlobalMarketData)
            .sink { [weak self] (returnStats) in
                self?.statistics = returnStats
                self?.isLoading = false
            }
            .store(in: &cancellable)
    }
    
    func updatePortfolio(coin: Coin, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        isLoading = true
        coinDataServices.getCoin()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    
    private func filterCoin(text: String, coin: [Coin]) -> [Coin] {
        guard !text.isEmpty else{
            return coin
        }
        let lowercasedText = text.lowercased()
        return coin.filter { (coin) -> Bool in
           return coin.name.lowercased().contains(lowercasedText) ||
                coin.symbol.lowercased().contains(lowercasedText) ||
                coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func mapAllCoinsToPortfolioCoins(allCoins: [Coin], portfolioEntities: [PortfolioItem]) -> [Coin] {
        allCoins
            .compactMap { (coin) -> Coin? in
                guard let entity = portfolioEntities.first(where: {$0.coinID == coin.id}) else {
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }

    }
    
    private func mapGlobalMarketData(marketData: MarketData?, portfolioCoins: [Coin ]) -> [Statistic] {
        var stats: [Statistic] = []
        
        guard let data = marketData else {
            return stats
        }
        
        let marketCap = Statistic(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = Statistic(title: "24 Volume", value: data.volume)
        let btcDominance = Statistic(title: "BTC Dominance", value: data.btcDominance)
        let portfolioValue = portfolioCoins
                                .map( {$0.currentHoldingsValue})
                                .reduce(0, +)
        let previousValue = portfolioCoins
                                .map { (coin) -> Double in
                                    let currentValue = coin.currentHoldingsValue
                                    let percentChange = coin.priceChangePercentage24H! / 100
                                    let previousValue = currentValue / (1 + percentChange)
                                    return previousValue
                                }
                                .reduce(0, +)
        let percentageChange = ((portfolioValue - previousValue) / portfolioValue) * 100
        
        let portfolio = Statistic(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentageChange: percentageChange)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            portfolio
        ])
        
        return stats
    }
}
