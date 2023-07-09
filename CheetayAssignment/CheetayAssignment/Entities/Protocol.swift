//
//  Protocol.swift
//  CheetayAssignment
//
//  Created by usama farooq on 09/07/2023.
//

import Foundation
protocol MovieProtocol: Codable {
    var backdropPath: String? {get set}
    var posterPath: String? {get set}
    var id: Int {get set}
    var title: String {get set}
    var releaseDate: String {get set}
    var overView: String {get set}
    var isLiked: Bool {get set}
}
