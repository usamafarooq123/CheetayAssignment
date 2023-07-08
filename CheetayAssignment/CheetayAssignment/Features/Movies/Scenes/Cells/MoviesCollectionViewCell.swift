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
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var releaseLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func didTapLike(_ sender: UIButton) {
        likeButton.isSelected = !likeButton.isSelected
    }
    
    func configure(viewModel: MoviesCellViewModel) {
        movieImageView.kf.setImage(with: viewModel.avatarURL, placeholder: UIImage.placeholderImage)
        movieNameLabel.text = viewModel.name
        releaseLabel.text = viewModel.releaseData
    }

}
