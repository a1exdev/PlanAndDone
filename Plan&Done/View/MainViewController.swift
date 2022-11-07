//
//  MainViewController.swift
//  Plan&Done
//
//  Created by Alexander Senin on 28.10.2022.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    private let searchController = UISearchController()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.sectionHeaderHeight = 8
        table.sectionFooterHeight = 8
        table.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.isScrollEnabled = false
        return table
    }()
    
    private var tableViewHeight: CGFloat {
        tableView.layoutIfNeeded()
        return tableView.contentSize.height
    }
    
    private let newItemButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "plus")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 28)
        
        var button  = UIButton(configuration: config)
        button.clipsToBounds = true
        return button
    }()
    
    private let projectGroupManager = ProjectGroupManager(dataAdapter: CoreDataAdapter.shared)
    
    var projectGroups: [ProjectGroup] {
        get {
            return projectGroupManager.fetchAll()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotifications()
        
        configureView()
        configureSearchBar()
        configureNewItemButton()
        configureProjectsTableView()
        
        setupConstraints()
    }

    @objc func viewBecameActive() {
        self.newItemButton.alpha = 1
        self.newItemButton.frame.origin.y += 100
        
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 15,
                       options: .curveEaseOut,
                       animations: {
            self.newItemButton.frame.origin.y -= 100
        })
    }
    
    @objc func showNewItemOverlay(sender: UIButton!) {
        self.newItemButton.alpha = 0
        let newItemOverlay = NewItemOverlay()
        newItemOverlay.appear(sender: self)
    }
    
    private func configureView() {
        title = "My Projects"
        view.backgroundColor = UIColor(rgb: 0x1E2128)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    private func configureSearchBar() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Quick Find"
    }
    
    private func configureNewItemButton() {
        newItemButton.frame = CGRect(x: view.bounds.maxX - 75, y: view.bounds.maxY * 0.88, width: 58, height: 58)
        newItemButton.layer.cornerRadius = (newItemButton.frame.size.width / 2)
        newItemButton.addTarget(self, action: #selector(showNewItemOverlay), for: .touchUpInside)
        view.addSubview(newItemButton)
    }
    
    private func configureProjectsTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor(rgb: 0x1E2128)
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: tableViewHeight)
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        contentView.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tableView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: contentView.leftAnchor)
        ])
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(viewBecameActive),
            name: Notification.Name("ViewBecameActive"),
            object: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

extension MainViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return projectGroups.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let projects = projectGroups[section].project else { return 0 }
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let projects = (projectGroups[indexPath.section].project?.allObjects as! [Project]).sorted { $0.title! < $1.title! }
    
        cell.textLabel?.text = projects[indexPath.row].title
        cell.imageView?.image = UIImage(systemName: projects[indexPath.row].image!)
        cell.imageView?.tintColor = UIColor.colorWith(name: projects[indexPath.row].color!)
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}