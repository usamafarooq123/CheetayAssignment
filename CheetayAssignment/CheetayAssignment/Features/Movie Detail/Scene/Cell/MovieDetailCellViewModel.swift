//
//  MovieDetailCellViewModel.swift
//  CheetayAssignment
//
//  Created by usama farooq on 08/07/2023.
//

import Foundation

struct MovieDetailCellViewModel {
    let name: String
    let releaseData: String
    let headerImagePath: String?
    let posterImagePath: String?
    let description: String
    
    var headerImagePathURL: URL? {
        guard let path = headerImagePath else {return nil}
        let imageUrl: String = "https://image.tmdb.org/t/p/w92/\(path)"
        guard let urlPath = URL.init(string: imageUrl) else { return nil }
        return urlPath
    }
    
    var posterImagePathURL: URL? {
        guard let path = posterImagePath else {return nil}
        let imageUrl: String = "https://image.tmdb.org/t/p/w92/\(path)"
        guard let urlPath = URL.init(string: imageUrl) else { return nil }
        return urlPath
    }
}
