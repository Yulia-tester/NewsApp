//
//  NewsResponseObject.swift
//  NewsApp
//
//  Created by Юлия Дегтярева on 2025-06-02.
//

import Foundation

struct NewsResponseObject: Codable {
    let totalResults: Int
    let articles: [ArticleResponseObject]
    
    enum CodingKeys: CodingKey {
        case totalResults
        case articles
    }
}
