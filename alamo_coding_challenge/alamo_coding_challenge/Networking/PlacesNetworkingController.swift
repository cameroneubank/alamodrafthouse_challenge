//
//  PlacesNetworkingController.swift
//  alamo_coding_challenge
//
//  Created by Cameron Eubank on 6/15/20.
//  Copyright © 2020 Cameron Eubank. All rights reserved.
//

import Foundation
import os.log

/// The `Error` types that may occur in `PlacesNetworkingController`.
enum PlacesNetworkingControllerError: Error {
    case invalidUrl
    case missingResponseData
}

/// Object responsible for network requests and interactions to the places API.
///
/// https://opencagedata.com/api
///
struct PlacesNetworkingController {
    
    private enum APIConstant {
        static let key: String = "f1aa9576517049738b2411404c71c6ca"
        static let url: String = "https://api.opencagedata.com/geocode/v1/json"
    }
    
    private enum QueryItemKey: String {
        case query = "q" // The key of the query parameter for the "query". The value will be a `String` keyword.
        case apiKey = "key" // The key of the query parameter for the API key.
        case language
    }
    
    // MARK: - Initialization
    
    /// The instance of `URLSession` used to make requests with.
    private let urlSession: URLSession
    
    /// Initialize an instance of `PlacesNetworkingController`.
    ///
    /// - parameter urlSession: The instance of `URLSession` that makes the requests.
    ///                         The default value is `URLSession.shared`.
    ///
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    // MARK: - Public API
    
    /// Executes a request to fetch places for a given keyword.
    ///
    /// - parameter keyword: The `String` keyword provided with the request.
    /// - parameter completion: The completion block providing a `Result` object called when the network request finishes.
    ///
    func getPlaces(keyword: String, completion: @escaping (Result<[Place], Error>) -> Void) {
        
        /// Decodable object which wraps the array of `Place` objects we care about.
        struct Response: Decodable {
            let results: [Place]
        }
        
        do {
            let url = try apiUrl(with: keyword)
            urlSession.dataTask(with: url) { data, response, error in
                
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
    
    /// Returns the constructed `URL` object for a given keyword.
    ///
    /// - parameter keyword: The `String` keyword used in the request.
    ///
    private func apiUrl(with keyword: String) throws -> URL {
        
        // Ensure we can construct a `URLComponents` object from the base URL of the API.
        guard var urlComponents = URLComponents(string: APIConstant.url) else {
            throw PlacesNetworkingControllerError.invalidUrl
        }
        
        // Construct the URL with the necessary query items.
        urlComponents.queryItems = [
            URLQueryItem(name: QueryItemKey.query.rawValue, value: keyword),
            URLQueryItem(name: QueryItemKey.apiKey.rawValue, value: APIConstant.key),
            URLQueryItem(name: QueryItemKey.language.rawValue, value: Locale.current.languageCode)
        ]
        
        // Try and return a URL from `urlComponents`.
        guard let url = urlComponents.url else {
            throw PlacesNetworkingControllerError.invalidUrl
        }
        return url
    }
}
