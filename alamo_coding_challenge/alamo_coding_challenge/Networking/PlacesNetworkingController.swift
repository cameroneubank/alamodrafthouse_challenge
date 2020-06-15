//
//  PlacesNetworkingController.swift
//  alamo_coding_challenge
//
//  Created by Cameron Eubank on 6/15/20.
//  Copyright © 2020 Cameron Eubank. All rights reserved.
//

import Foundation
import os.log

enum PlacesNetworkingControllerError: Error {
    case invalidUrl
    case missingResponseData
}

class PlacesNetworkingController {
    
    private enum APIConstant {
        static let key: String = "f1aa9576517049738b2411404c71c6ca"
        static let url: String = "https://api.opencagedata.com/geocode/v1/json"
    }
    
    // MARK: - Public API
    
    func getPlaces(keyword: String, completion: @escaping (Result<[Place], Error>) -> Void) {
        
        /// Decodable object which wraps the array of `Place` objects we care about.
        struct Response: Decodable {
            let results: [Place]
        }
        
        do {
            let url = try apiUrl(with: keyword)
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                // If we encounter an error, log the error and call completion with the error.
                if let error = error {
                    os_log(.error, "Failed to retrieve places for keyword with error: %@", error.localizedDescription)
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
                
                // Ensure we have data in the response.
                // Without data, we can't decode our response object.
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(PlacesNetworkingControllerError.missingResponseData))
                    }
                    return
                }
                
                // Attempt to decode an instance `Response` with `data`.
                // If successful, call completion with the array of `Place` objects.
                // If unsuccessful, call completion with the thrown `error`.
                do {
                    let decodedResponse: Response = try JSONDecoder().decode(Response.self, from: data)
                    let places = decodedResponse.results
                    DispatchQueue.main.async {
                        completion(.success(places))
                    }
                } catch {
                    os_log(.error, "Failed to retrieve places for keyword with error: %@", error.localizedDescription)
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }.resume()
        } catch {
            os_log(.error, "Failed to retrieve places for keyword with error: %@", error.localizedDescription)
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Private
    
    private func apiUrl(with keyword: String) throws -> URL {
        guard var urlComponents = URLComponents(string: APIConstant.url) else {
            throw PlacesNetworkingControllerError.invalidUrl
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: keyword),
            URLQueryItem(name: "key", value: APIConstant.key)
        ]
        
        guard let url = urlComponents.url else {
            throw PlacesNetworkingControllerError.invalidUrl
        }
        
        // https://api.opencagedata.com/geocode/v1/json?q=PLACENAME&key=f1aa9576517049738b2411404c71c6ca
        return url
    }
}
