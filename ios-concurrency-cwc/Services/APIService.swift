//
//  APIService.swift
//  ios-concurrency-cwc
//
//  Created by Leonardo de Oliveira on 09/07/23.
//

import Foundation

struct APIService {
    let urlString: String
    
    func getJSON<T: Decodable>(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                                keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase,
                                completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200
            else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponseStatus))
                }
                return
            }
            
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.dataTaskError(error!.localizedDescription)))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.corruptData))
                }
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError(error.localizedDescription)))
                }
                print(error)
            }
            
            
            
        }
        .resume()
    }
}

enum APIError: Error, LocalizedError {
    case invalidUrl
    case invalidResponseStatus
    case dataTaskError(String)
    case corruptData
    case decodingError(String)
    
    var errorDescription: String? {
        return switch self {
            case .invalidUrl:
                NSLocalizedString("The endpoint URL is invalid", comment: "")
            case .invalidResponseStatus:
                NSLocalizedString("The API failed to issue a valid response", comment: "")
            case .dataTaskError(let string):
                string
            case .corruptData:
                NSLocalizedString("The data provided appears to be corrupt", comment: "")
            case .decodingError(let string):
                string
        }
    }
}
