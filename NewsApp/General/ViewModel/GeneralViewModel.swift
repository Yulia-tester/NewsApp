//
//  GeneralViewModel.swift
//  NewsApp
//
//  Created by Юлия Дегтярева on 2025-06-01.
//

import Foundation

protocol GeneralViewModelProtocol {
    var reloadData: (() -> Void)? { get set }
    var showError: ((String) -> Void)? { get set }
    var reloadCell: ((Int) -> Void)? { get set }
    
    var numberOfCells: Int { get }
    
    func getArticle(for row: Int) -> ArticleCellViewModel
}

final class GeneralViewModel: GeneralViewModelProtocol {
    var reloadData: (() -> Void)?
    var reloadCell: ((Int) -> Void)?
    var showError: ((String) -> Void)?
    
    // MARK: - Properties
    var numberOfCells: Int {
        articles.count
    }
    private var articles: [ArticleCellViewModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.reloadData?()
            }
        }
    }
    
    init() {
        loadData()
    }
    
    func getArticle(for row: Int) -> ArticleCellViewModel {
        let article = articles[row]
        loadImage(for: row)
        return article
    }
    
    private func loadData() {
        ApiManager.getNews { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let articles):
                self.articles = self.convertToCellViewModel(articles)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showError?(error.localizedDescription)
                }
            }
        }
        
        //setupMockObjects()
    }
    
    private func loadImage(for row: Int) {
        // TODO: get imageData
        guard let url = URL(string: articles[row].imageUrl),
              let data = try? Data(contentsOf: url) else { return }
        
        articles[row].imageData = data
        reloadCell?(row)
    }
    
    private func convertToCellViewModel(_ articles: [ArticleResponseObject]) -> [ArticleCellViewModel] {
        return articles.map { ArticleCellViewModel(article: $0) }
    }
    
    private func setupMockObjects() {
        articles = [
            ArticleCellViewModel(article: ArticleResponseObject(title: "First object title",
                                                                description: "First object description in the mock object",
                                                                urlToImage: "...",
                                                                date: "04.06.2025"))
        ]
    }
}
