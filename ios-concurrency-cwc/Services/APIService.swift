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
                               keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase) async throws -> T {
        guard let url = URL(string: urlString) else { throw APIError.invalidUrl }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200
            else {
                throw APIError.invalidResponseStatus
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                return decodedData
            } catch {
                throw APIError.decodingError(error.localizedDescription)
            }
            
        } catch {
            throw APIError.dataTaskError(error.localizedDescription)
        }
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
