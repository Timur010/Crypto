//
//  LocalFileManager.swift
//  CryptoSwiftUI
//
//  Created by timur on 18.10.2022.
//

import Foundation
import SwiftUI

class LocalFileManager {
    
    static let instance = LocalFileManager()
    private init() {}
    
    func saveImage(image: UIImage, imageName: String, foldName: String) {
        //create folder
        createFolderIfNeeded(foldName:  foldName)
        // get path for image
        guard
            let data = image.pngData(),
            let url = getURLForImage(imageName: imageName, folderName: foldName)
        else {return}
        // save image to path
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving Image. ImageName: \(imageName). \(error)")
        }
        
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
        
        guard
            let url  = getURLForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
        
    }
    
    
    private func createFolderIfNeeded(foldName: String) {
        guard let url = getURLForFolder(folderName: foldName) else { return }
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("error creating directory. FoldName: \(foldName), \(error)")
            }
        }
    }
    
    private func getURLForFolder(folderName: String) -> URL? {
        
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathExtension(folderName)
    }
    
    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName ) else {
            return nil
        }
        return folderURL.appendingPathComponent(imageName + ".png")
    }
}
