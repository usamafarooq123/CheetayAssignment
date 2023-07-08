//
//  SuggestionCell.swift
//  CheetayAssignment
//
//  Created by usama farooq on 08/07/2023.
//

import UIKit

class SuggestionCell: UITableViewCell {

    @IBOutlet private weak var suggestionLabel: UILabel!
    

    func configure(with text: String) {
        suggestionLabel.text = text
    }
    public func getText() -> String {
        return suggestionLabel.text ?? ""
    }
}
