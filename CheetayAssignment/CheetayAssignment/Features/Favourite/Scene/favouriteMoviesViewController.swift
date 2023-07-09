//  
//  FavouriteMoviesViewController.swift
//  CheetayAssignment
//
//  Created by usama farooq on 09/07/2023.
//

import UIKit

public class FavouriteMoviesViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: FavouriteMoviesViewModel!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        bindViewModel()
        viewModel.viewModelDidLoad()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewModelWillAppear()
    }
    
    fileprivate func bindViewModel() {

        viewModel.output = { [unowned self] output in
            //handle all your bindings here
            switch output {
            case .reload:
                collectionView.reloadData()
            default:
                break
            }
        }
    }
}

extension FavouriteMoviesViewController {
    func configureAppearance() {
        self.title = "Favourite Movies"
        collectionView.delegate = self
        collectionView.dataSource = self
        registerCell()
    }
    
    private func registerCell() {
        collectionView.register(cellType: MoviesCollectionViewCell.self)
    }
}

extension FavouriteMoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: MoviesCollectionViewCell.self, for: indexPath)
        let item = viewModel.cellViewModel(forRow: indexPath.row)
        cell.configure(viewModel: item, delegate: self)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.size.width - 2) / 2
        let cellHeight = cellWidth * 1.5
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelect(with: indexPath.row)
    }
    
}



extension FavouriteMoviesViewController: MoviesCellectionViewDelegate {
    func didTap(action: MovieActions, index: Int) {
        viewModel.likeMovie(index: index, state: false)
    }
    
    
}
