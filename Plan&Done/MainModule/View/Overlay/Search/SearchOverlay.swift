//
//  SearchOverlay.swift
//  Plan&Done
//
//  Created by Alexander Senin on 13.11.2022.
//

import UIKit

class SearchOverlay: UIViewController, MainViewProtocol {
    
    var presenter: MainViewPresenterProtocol!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var items = presenter.searchItems
    var filteredItems: [SearchItems]!
    
    init() {
        super.init(nibName: "SearchOverlay", bundle: nil)
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredItems = items
        
        configureView()
        configureSearchBar()
        configureTableView()
    }
    
    func appear(sender: UIViewController) {
        sender.present(self, animated: false) { [self] in
            show()
        }
    }
    
    @IBAction func backViewTapped(_ sender: UIControl) {
        hide()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        hide()
    }
    
    private func configureView() {
        view.backgroundColor = .clear
        
        backView.backgroundColor = .black.withAlphaComponent(0.3)
        backView.alpha = 0
        
        contentView.alpha = 0
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: -20, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
    }
    
    private func show() {
        contentView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       animations: { [self] in
            backView.alpha = 1
            contentView.alpha = 1
            contentView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    private func hide() {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       animations: { [self] in
            backView.alpha = 0
            contentView.alpha = 0
            contentView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { [self] _ in
            dismiss(animated: true)
        })
    }

}

extension SearchOverlay: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filterItems = items.filter({ item in
            item.title.lowercased().contains(searchText.lowercased())
        })
        filteredItems = searchText.isEmpty ? items : filterItems
        tableView.reloadData()
    }
}

extension SearchOverlay: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        hide()
        presenter.goToItem(with: filteredItems[indexPath.row].id)
    }
}

extension SearchOverlay: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        
        cell.textLabel?.text = filteredItems[indexPath.row].title
        cell.imageView?.image = UIImage(systemName: filteredItems[indexPath.row].image ?? "square")
        cell.imageView?.tintColor = UIColor.colorWith(name: filteredItems[indexPath.row].color ?? "systemGray")
        cell.backgroundColor = .clear
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        return cell
    }
}
