//
//  BusinessViewModel.swift
//  NewsApp
//
//  Created by Юлия Дегтярева on 2025-10-14.
//

import Foundation

protocol BusinessViewModelProtocol {
    var reloadData: (() -> Void)? { get set }
    var showError: ((String) -> Void)? { get set }
    var reloadCell: ((IndexPath) -> Void)? { get set }
    var sections: [TableCollectionViewSection] { get }
    
    func loadData()
}

final class BusinessViewModel: BusinessViewModelProtocol {
    var reloadData: (() -> Void)?
    var reloadCell: ((IndexPath) -> Void)?
    var showError: ((String) -> Void)?
    
    // MARK: - Properties
    private(set) var sections: [TableCollectionViewSection] = [] {
        didSet {
            DispatchQueue.main.async {
                self.reloadData?()
            }
        }
    }
    
    private var page = 0
    
    func loadData() {
        print(#function)
        page += 1
        
        ApiManager.getNews(from: .business, page: page) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let articles):
                self.convertToCellViewModel(articles)
                self.loadImage()
            case .failure(let error):
                DispatchQueue.main.async {
                    self.showError?(error.localizedDescription)
                }
            }
        }
        
        // setupMockObjects()
    }
    
    private func loadImage() {
        for (i, section) in sections.enumerated() {
            for (index, item) in section.items.enumerated() {
                guard let article = item as? ArticleCellViewModel else { continue }

                // если imageUrl — optional, разворачиваем; если нет — просто используем
                //guard let url = article.imageUrl, !url.isEmpty else { continue }
                let url = article.imageUrl
                if url.isEmpty { continue }
                
                ApiManager.getImageData(url: url) { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let data):
                            if let article = self?.sections[i].items[index] as? ArticleCellViewModel {
                                article.imageData = data
                            }
                            self?.reloadCell?(IndexPath(row: index, section: i))
                        case .failure(let error):
                            self?.showError?(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }

    private func convertToCellViewModel(_ responses: [ArticleResponseObject]) {
        var viewModels = responses.map { ArticleCellViewModel(article: $0) }
        
        guard !viewModels.isEmpty else { return }
        
        if sections.isEmpty {
            // создаём 2 секции: первая — один главный элемент, вторая — остальные
            let firstSection = TableCollectionViewSection(items: [viewModels.removeFirst()])
            let secondSection = TableCollectionViewSection(items: viewModels)
            sections = [firstSection, secondSection]
        } else if sections.count > 1 {
            // добавляем новые элементы в существующую вторую секцию
            sections[1].items.append(contentsOf: viewModels)
        }
    }
    
    private func setupMockObjects() {
        sections = [
            TableCollectionViewSection(items: [
                ArticleCellViewModel(article: ArticleResponseObject(
                    title: "First object title",
                    description: "First object description in the mock object",
                    urlToImage: "...",
                    date: "04.06.2025"
                ))
            ])
        ]
    }
}
