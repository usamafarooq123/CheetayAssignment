//  
//  MoviesViewController.swift
//  CheetayAssignment
//
//  Created by usama farooq on 07/07/2023.
//

import UIKit

final public class MoviesViewController: UIViewController {

    //MARK: Outlet
    @IBOutlet weak var searchSuggestionView: SearchSuggestionsView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: MoviesViewModel!
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRectMake(0, 0, UIScreen.main.bounds.width - 40, 20))
    
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
                reloadCollectionView()
            case .setEmptyView(let error):
                collectionView.setEmptyMessage(error)
            case .setHistory(let history):
               hideShowSearchView(state: false)
                
                searchSuggestionView.setData(history)
            case .reloadCell(let row):
                let indexPath = IndexPath(row: row, section: 0)
                collectionView.reloadItems(at: [indexPath])
            case .showSuggestionView(let status):
                hideShowSearchView(state: status)
            }
        }
    }
    private func reloadCollectionView() {
        collectionView.restore()
        collectionView.reloadData()
    }
    
    private func hideShowSearchView(state: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.searchSuggestionView.isHidden = state
        }
    }
}

extension MoviesViewController {
    private func configureAppearance() {
        configureNavigationBar()
        searchBar.placeholder = "Search movie here"
        searchBar.delegate = self
        searchSuggestionView.isHidden = true
        searchSuggestionView.delegate = self
        registerCell()
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    private func configureNavigationBar() {
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
    }
    
    private func registerCell() {
        collectionView.register(cellType: MoviesCollectionViewCell.self)
    }
}

extension MoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height {
            viewModel.fetchMovies(text: searchBar.text)
        }
    }
    
}


extension MoviesViewController: UISearchBarDelegate {
    
    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if searchBar.text?.isEmpty ?? true {
            viewModel.fetchSearchHistory()
        }
        return true
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        hideShowSearchView(state: true)
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchTextDidChange(text: searchText)
        
    }
}


extension MoviesViewController: SearchSuggestionsDelegate {
    func selection(text: String) {
        searchBar.text = text
        viewModel.fetchMovies(text: text)
        hideShowSearchView(state: true)
    }
}

extension MoviesViewController: MoviesCellectionViewDelegate {
    func didTap(action: MovieActions, index: Int) {
        switch action {
        case .like:
            viewModel.likeMovie(index: index, state: true)
        case .unlike:
            viewModel.likeMovie(index: index, state: false)
        }
    }
    
    
}
