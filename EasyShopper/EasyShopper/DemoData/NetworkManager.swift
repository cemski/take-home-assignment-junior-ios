//
//  NetworkServiceMock.swift
//  EasyShopper
//
//  Created by Cem Lapovski on 2020-06-30.
//

import Foundation
import Alamofire

let demoDataURL = URL(string: "https://run.mocky.io/v3/4e23865c-b464-4259-83a3-061aaee400ba")!

enum NetworkError: Error {
    case networkError
    case parsingError
}

class NetworkManager {
    
    func fetchOnlineStock(completion: @escaping (Swift.Result<[Product], NetworkError>) -> Void) {
        
        Alamofire.request(demoDataURL).responseJSON { response in
            switch response.result {
            case .success:
                guard let products = response.value as? [String: [String: Any]] else { completion(.failure(.parsingError)); return}
                
                var _products: [Product] = []
                
                for product in products {
                    guard let product = Product(value: product.value) else { continue }
                    _products.append(product)
                }
                completion(.success(_products))
                
            case .failure:
                completion(.failure(.networkError))
            }
        }
    }
}
