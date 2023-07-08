//
//  SearchSuggestionsView.swift
//  CheetayAssignment
//
//  Created by usama farooq on 08/07/2023.
//

import UIKit

protocol SearchSuggestionsDelegate: AnyObject {
    func selection(text: String)
}

class SearchSuggestionsView: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private var list: [String] = []
    
    weak var delegate: SearchSuggestionsDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("SearchSuggestionsView", owner: self)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        configure()
    }
    
    private func configure() {
        tableView.register(cellType: SuggestionCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    public func setData(_ list: [String]) {
        self.list = list
        tableView.reloadData()
    }
    
    
}

extension SearchSuggestionsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: SuggestionCell.self, for: indexPath)
        let text = list[indexPath.row]
        cell.configure(with: text)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SuggestionCell,
        let delegate = delegate else {return}
        delegate.selection(text: cell.getText())
    }
}
