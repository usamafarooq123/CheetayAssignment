//
//  String+Extension.swift
//  CheetayAssignment
//
//  Created by usama farooq on 09/07/2023.
//

import Foundation

extension String {
    func filterParams() -> String {
        return self.replacingOccurrences(of: " ", with: "%20")
    }
}
