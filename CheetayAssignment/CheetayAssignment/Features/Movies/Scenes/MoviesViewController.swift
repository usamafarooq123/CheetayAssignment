//  
//  MoviesViewController.swift
//  CheetayAssignment
//
//  Created by usama farooq on 07/07/2023.
//

import UIKit

public class MoviesViewController: UIViewController {

    var viewModel: MoviesViewModel!
    
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
            default:
                break
            }
        }
    }
}

extension MoviesViewController {
    func configureAppearance() {

    }
}
