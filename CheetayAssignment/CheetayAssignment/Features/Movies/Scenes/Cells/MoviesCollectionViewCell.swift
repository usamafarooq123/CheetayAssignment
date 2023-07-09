//
//  MoviesCollectionViewCell.swift
//  CheetayAssignment
//
//  Created by usama farooq on 07/07/2023.
//

import UIKit
import Kingfisher

enum MovieActions {
    case like
}

protocol MoviesCellectionViewDelegate: AnyObject {
    func didTap(action: MovieActions, index: Int)
}

final class MoviesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var releaseLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    
    var index: Int = 0
    weak var delegate: MoviesCellectionViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func didTapLike(_ sender: UIButton) {
        likeButton.isSelected = !likeButton.isSelected
        delegate?.didTap(action: .like, index: index)
    }
    
    func configure(viewModel: MoviesCellViewModel, delegate: MoviesCellectionViewDelegate ) {
        self.delegate = delegate
        index = viewModel.index
        movieImageView.kf.setImage(with: viewModel.avatarURL, placeholder: UIImage.placeholderImage)
        movieNameLabel.text = viewModel.name
        releaseLabel.text = viewModel.releaseData
        likeButton.isSelected = viewModel.isLike
        print("is like \(viewModel.isLike)")
    }

}
