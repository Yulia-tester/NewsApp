//
//  TableCollectionViewSection.swift
//  NewsApp
//
//  Created by Юлия Дегтярева on 2025-10-14.
//

import Foundation

protocol TableCollectionViewItemsProtocol { }

struct TableCollectionViewSection {
    var title: String?
    var items: [TableCollectionViewItemsProtocol]
}
