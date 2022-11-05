//
//  NetworkingManager .swift
//  CryptoSwiftUI
//
//  Created by timur on 15.10.2022.
//

import Foundation
import Combine

class NetworkingManager {
    
    enum NetworkingError: LocalizedError {
        case badURlResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .badURlResponse(url: let url):
                return "[😱]Bad response from URL: \(url)"
            case .unknown:
                return "[🖕]Unknown error occurred"
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap( {try handleURLResponse(output: $0, url: url)} )
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURlResponse(url: url)
        }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case let .failure(error):
            print(error.localizedDescription)
        }
    }
    
}
