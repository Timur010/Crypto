//
//  CoinImageService.swift
//  CryptoSwiftUI
//
//  Created by timur on 18.10.2022.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    
    @Published var  image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    private let coin: Coin
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String
    
    init(coin: Coin) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
       
    }
    
    private func  getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
             image = savedImage
            print("Retrieved image from file Manager")
        } else {
            downloadCoinImage()
            print("загрузка")
        }
    }
    
    private func downloadCoinImage() {
        
        guard let url = URL(string: coin.image) else {return}
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnImage) in
                guard let self = self, let downloadImage = returnImage else {return}
                self.image = downloadImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadImage, imageName: self.imageName, foldName: self.folderName)
            })
    }
}
