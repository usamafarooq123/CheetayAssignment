//
//  Movies.swift
//  CheetayAssignment
//
//  Created by usama farooq on 07/07/2023.
//

import Foundation
import UIKit

protocol MovieProtocol: Codable {
    var backdropPath: String? {get set}
    var posterPath: String? {get set}
    var id: Int {get set}
    var title: String {get set}
    var releaseDate: String {get set}
    var overView: String {get set}
    var isLiked: Bool {get set}
}

struct MoviesResponse: Codable {
    let page: Int
    let movies: [MovieModel]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MovieModel: MovieProtocol {
    var backdropPath: String?
    var posterPath: String?
    var id: Int
    var title: String
    var releaseDate: String
    var overView: String
    var isLiked: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case id
        case releaseDate = "release_date"
        case title
        case overView = "overview"
    }
    
}
