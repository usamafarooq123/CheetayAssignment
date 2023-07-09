//  
//  MovieDetailViewController.swift
//  CheetayAssignment
//
//  Created by usama farooq on 08/07/2023.
//

import UIKit

final public class MovieDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var likeButton: UIBarButtonItem!
    
    var viewModel: MovieDetailViewModel!
    
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
            case .updateLikeButton(let state):
                updateLikeButton(with: state)
            default:
                break
            }
        }
    }

}

extension MovieDetailViewController {
    func configureAppearance() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: MovieDetailCell.self)
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        self.title = "Detail"
        likeButton = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(likeButtonTapped))
        navigationItem.rightBarButtonItem = likeButton
    }
    
    @objc func likeButtonTapped() {
        // Handle the like button tapped event
        viewModel.movieLike()
    }
    
    func updateLikeButton(with state: Bool) {
        let imageName = state ? "heart.fill" : "heart"
        likeButton.image = UIImage(systemName: imageName)
    }
    
}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
     
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: MovieDetailCell.self, for: indexPath)
        let item = viewModel.cellViewModel(forRow: indexPath.row)
        cell.configure(with: item)
        return cell
    }
    
}
