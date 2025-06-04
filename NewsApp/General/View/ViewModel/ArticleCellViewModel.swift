//
//  ArticleCellViewModel.swift
//  NewsApp
//
//  Created by Юлия Дегтярева on 2025-06-03.
//

import Foundation

struct ArticleCellViewModel {
    let title: String
    let description: String
    let date: String
    
    init(article: ArticleResponceObject) {
        title = article.title
        description = article.description
        date = article.publishedAt
    }
}
