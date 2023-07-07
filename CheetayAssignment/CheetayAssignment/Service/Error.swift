//
//  Error.swift
//  CheetayAssignment
//
//  Created by usama farooq on 07/07/2023.
//

import Foundation

enum ServiceError: Error {
    case noData
    case requestEncodingError(error: Error)
}
