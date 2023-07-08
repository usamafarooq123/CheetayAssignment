//
//  MovieDetailCell.swift
//  CheetayAssignment
//
//  Created by usama farooq on 08/07/2023.
//

import UIKit
import Kingfisher

class MovieDetailCell: UITableViewCell {

    @IBOutlet weak var movieHeaderImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with viewModel: MovieDetailCellViewModel) {
        movieHeaderImage.kf.setImage(with: viewModel.posterImagePathURL, placeholder: UIImage.placeholderImage)
        posterImage.kf.setImage(with: viewModel.headerImagePathURL, placeholder: UIImage.placeholderImage)
        movieNameLabel.text = viewModel.name
        releaseDateLabel.text = viewModel.releaseData
        descriptionLabel.text = viewModel.description
    }
    
}
