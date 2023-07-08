//
//  MoviesCollectionViewCell.swift
//  CheetayAssignment
//
//  Created by usama farooq on 07/07/2023.
//

import UIKit
import Kingfisher

final class MoviesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var movieImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(viewModel: MoviesCellViewModel) {
        movieImageView.kf.setImage(with: viewModel.avatarURL, placeholder: UIImage.placeholderImage)
    }

}
