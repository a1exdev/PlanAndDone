//
//  ProjectViewController.swift
//  Plan&Done
//
//  Created by Alexander Senin on 28.10.2022.
//

import UIKit

class ProjectViewController: UIViewController {
    
    var presenter: ProjectViewPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotifications()
        
        configureView()
        configureNewTaskButton()
        configureTasksTableView()
        
        setupConstraints()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(newTaskHasBeenAdded),
            name: Notification.Name("NewTaskHasBeenAdded"),
            object: nil)
    }
    
    @objc func newTaskHasBeenAdded() {
        tableView.reloadData()
        configureTasksTableView()
        
        //TODO: Focus on the new task, rename, etc.
    }
    
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
    
    private let newTaskButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "plus")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 28)
        
        var button  = UIButton(configuration: config)
        button.clipsToBounds = true
        return button
    }()
    
    private func configureView() {
        title = presenter.project.title
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = UIColor(rgb: 0x1E2128)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    private func configureNewTaskButton() {
        newTaskButton.frame = CGRect(x: view.bounds.maxX - 75, y: view.bounds.maxY * 0.88, width: 58, height: 58)
        newTaskButton.layer.cornerRadius = (newTaskButton.frame.size.width / 2)
        newTaskButton.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        view.addSubview(newTaskButton)
    }
    
    @objc func addTask() {
        presenter.addTask()
    }
    
    private func configureTasksTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = view.backgroundColor
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
}

extension ProjectViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ProjectViewController: UITableViewDataSource {
    
    var tasks: [Task] {
        get {
            return (presenter.project.task?.allObjects as! [Task]).sorted { $0.title! < $1.title! }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].title
        cell.backgroundColor = .clear
        return cell
    }
}

extension ProjectViewController: ProjectViewProtocol {
    
}
