//
//  NetworkingError.swift
//  NewsApp
//
//  Created by Юлия Дегтярева on 2025-06-04.
//

import Foundation

enum NetworkingError: Error {
    case networkingError(_ error: Error)
    case unknown
}
