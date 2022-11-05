//
//  PortfolioDataService.swift
//  CryptoSwiftUI
//
//  Created by timur on 31.10.2022.
//

import Foundation
import CoreData

class PortfolioDataService {
     
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioItem"
    
    @Published var saveEntities: [PortfolioItem] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _ , error in
            if let error = error {
                print("Error loading Core Data \(error)")
            }
        }
    }
    
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioItem>(entityName: entityName)
        do {
            saveEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Portfolio Entities. \(error)")
        }
    }
    
    func updatePortfolio(coin: Coin, amount: Double) {
        
        if let entity = saveEntities.first(where: {$0.coinID == coin.id}) {
            
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                    
            }
            
        }
            
        
    }
    
    private func add(coin: Coin, amount: Double) {
        
        let entity = PortfolioItem(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(entity: PortfolioItem, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    private func remove(entity: PortfolioItem) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func save() {
        
        do {
            try container.viewContext.save()
        } catch let error  {
            print("Error saving to Core Data. \(error)")
        }
        
    }
    
    private func applyChanges() {
        save()
        getPortfolio()
    }
    
}
