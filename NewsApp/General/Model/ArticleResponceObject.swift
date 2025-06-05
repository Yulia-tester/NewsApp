//
//  ArticleResponceObject.swift
//  NewsApp
//
//  Created by Юлия Дегтярева on 2025-06-02.
//

import Foundation

struct ArticleResponceObject: Codable {
    let title: String
    let description: String
    let urlToImage: String
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case urlToImage
        case date = "publishedAt"
    }
}
