//
//  ApiManager.swift
//  NewsApp
//
//  Created by Юлия Дегтярева on 2025-06-04.
//

import Foundation

final class ApiManager {
    private static let apiKey = "cc75066b5ff548d3bda11f3b47612b88"
    private static let baseUrl = "https://newsapi.org/v2/"
    private static let path = "everything"
    
    // Create url path and make request
    static func getNews(completion: @escaping (Result<[ArticleResponceObject], Error>) -> ()) {
        let stringUrl = baseUrl + path + "?sources=bbc-news&language=en" + "&apiKey=\(apiKey)"
        
        guard let url = URL(string: stringUrl) else { return }
        
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            handleResponse(data: data,
                           error: error,
                           completion: completion)
        }
        
        session.resume()
    }
    
    // Handle responce
    private static func handleResponse(data: Data?,
                                       error: Error?,
                                       completion: @escaping (Result<[ArticleResponceObject], Error>) -> ()) {
        if let error = error {
            completion(.failure(NetworkingError.networkingError(error)))
        } else if let data = data {
            do {
                let model = try JSONDecoder().decode(NewsResponseObject.self,
                                                     from: data)
                completion(.success(model.articles))
            }
            catch let decodeError {
                completion(.failure(decodeError))
            }
        } else {
            completion(.failure(NetworkingError.unknown))
        }
    }
}
