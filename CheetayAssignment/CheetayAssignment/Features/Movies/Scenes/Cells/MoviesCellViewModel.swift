//
//  MoviesCellViewModel.swift
//  CheetayAssignment
//
//  Created by usama farooq on 07/07/2023.
//

import Foundation

struct MoviesCellViewModel {
    
    //MARK: Public Properties
    let name: String
    let releaseData: String
    let imagePath: String
    let isLike: Bool
    let index: Int
    
    var avatarURL: URL? {
        let imageUrl: String = "https://image.tmdb.org/t/p/w92/\(imagePath)"
        guard let urlPath = URL.init(string: imageUrl) else { return nil }
        return urlPath
    }
}
