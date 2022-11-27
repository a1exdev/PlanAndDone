//
//  MainViewController.swift
//  Plan&Done
//
//  Created by Alexander Senin on 28.10.2022.
//

import UIKit

class MainViewController: UIViewController, MainViewProtocol {
    
    var presenter: MainViewPresenterProtocol!
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotifications()
        setupInitialData()
        
        configureView()
        configureSearchBarView()
        configureNewItemButton()
        configureSettingsButton()
        configureProjectsTableView()
        
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    // MARK: Initial data configure
    
    private func setupInitialData() {
        if !UserDefaults.standard.bool(forKey: "SetupInitialData") {
            presenter.setupInitialData()
            UserDefaults.standard.set(true, forKey: "SetupInitialData")
        }
    }
    
    
    // MARK: Notifications
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(viewHasBecomeActive),
            name: Notification.Name("ViewHasBecomeActive"),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(newProjectHasBeenAdded),
            name: Notification.Name("NewProjectHasBeenAdded"),
            object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func viewHasBecomeActive() {
        
        tableView.reloadData()
        
        newItemButton.alpha = 1
        newItemButton.frame.origin.y += 110
        
        UIView.animate(withDuration: 0.25,
                       delay: 0.2,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 15,
                       options: .curveEaseOut,
                       animations: { [self] in
            newItemButton.frame.origin.y -= 110
            
            if searchBarView.alpha != 1 {
                searchBarView.alpha = 1
            }
        })
    }
    
    @objc func newProjectHasBeenAdded() {
        tableView.reloadData()
        configureProjectsTableView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let latestCustomProject = tableView.numberOfRows(inSection: 3) - 1
            let indexPath = IndexPath(row: latestCustomProject, section: 3)
            let cell = tableView.cellForRow(at: indexPath) as? ProjectCustomCell
            cell?.isAdded()
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 110, right: 0)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
    }
    
    
    // MARK: UI elements
    
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
    
    private let searchBarLabel: UILabel = {

        let label = UILabel()

        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "magnifyingglass")?.withTintColor(.secondaryLabel)
        imageAttachment.bounds = CGRect(x: 0, y: -4.5, width: 20, height: 20)

        let attachmentString = NSAttributedString(attachment: imageAttachment)
        let completeText = NSMutableAttributedString(string: "")
        completeText.append(attachmentString)
        let textAfterIcon = NSAttributedString(string: " Quick Find")
        completeText.append(textAfterIcon)

        label.attributedText = completeText
        label.textColor = .secondaryLabel
        label.sizeToFit()

        return label
    }()

    private let searchBarView: UIView = {
        let searchBarView = UIView()
        searchBarView.backgroundColor = UIColor(rgb: 0x2D3037)
        searchBarView.layer.cornerRadius = 10
        return searchBarView
    }()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.rowHeight = 44
        table.sectionHeaderHeight = 8
        table.sectionFooterHeight = 8
        table.isScrollEnabled = false
        table.register(ProjectCustomCell.nib(), forCellReuseIdentifier: ProjectCustomCell.identifier)
        return table
    }()
    
    private var tableViewHeight: CGFloat {
        tableView.layoutIfNeeded()
        return tableView.contentSize.height
    }
    
    private let newItemButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "plus")
        config.imagePlacement = .leading
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 28)

        var button = UIButton(configuration: config)
        button.clipsToBounds = true
        return button
    }()
    
    private let settingsButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = " Settings"
        config.image = UIImage(systemName: "gearshape")
        config.baseForegroundColor = .systemGray
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 12)
        
        var button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func configureView() {
        navigationController?.navigationBar.tintColor = .systemGray
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        view.backgroundColor = UIColor(rgb: 0x1E2128)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    private func configureSearchBarView() {
        searchBarView.frame = CGRect(x: 16, y: 8, width: view.frame.width - 32, height: 35)
        searchBarLabel.center.x = searchBarView.center.x - 16
        searchBarLabel.center.y = searchBarView.center.y - 7.5
        scrollView.addSubview(searchBarView)
        searchBarView.addSubview(searchBarLabel)
        
        let searchBarTapGesture = UITapGestureRecognizer(target: self, action: #selector(showSearchOverlay))
        searchBarView.addGestureRecognizer(searchBarTapGesture)
    }
    
    private func configureNewItemButton() {
        newItemButton.frame = CGRect(x: view.frame.maxX - 75, y: view.frame.maxY * 0.88, width: 58, height: 58)
        newItemButton.layer.cornerRadius = (newItemButton.frame.size.width / 2)
        newItemButton.addTarget(self, action: #selector(showNewItemOverlay), for: .touchUpInside)
        view.addSubview(newItemButton)
    }
    
    private func configureSettingsButton() {
        settingsButton.addTarget(self, action: #selector(showSettingsOverlay), for: .touchUpInside)
        scrollView.addSubview(settingsButton)
    }
    
    private func configureProjectsTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = view.backgroundColor
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.frame = CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width - 16, height: tableViewHeight + 30)
        contentView.addSubview(tableView)
    }
    
    
    // MARK: Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: -10),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 8),
            contentView.bottomAnchor.constraint(equalTo: settingsButton.topAnchor, constant: -5),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tableView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: contentView.leftAnchor)
        ])
        
        NSLayoutConstraint.activate([
            settingsButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            settingsButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: -5)
        ])
    }
    
    
    // MARK: Overlays navigation

    @objc func showSearchOverlay(sender: UITapGestureRecognizer) {
        presenter.showSearchOverlay()
    }
    
    @objc func showNewItemOverlay(sender: UIButton!) {
        newItemButton.alpha = 0
        presenter.showNewItemOverlay()
    }
    
    @objc func showSettingsOverlay(sender: UIButton!) {
        presenter.showSettingsOverlay()
    }
    
    private func performEditProjectOverlay(at indexPath: IndexPath) {
        
        let projects = (presenter.projectGroups[indexPath.section].project?.allObjects as! [Project]).sorted { $0.number < $1.number }
        let project = projects[indexPath.row]
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.layer.cornerRadius = 8
            cell.contentView.backgroundColor = UIColor(rgb: 0x2D3037)
        }
        
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 15,
                       options: .curveEaseOut,
                       animations: { [self] in
            newItemButton.alpha = 0
            searchBarView.alpha = 0.01
        })
        
        showEditProjectOverlay(for: project)
    }
    
    private func showEditProjectOverlay(for project: Project) {
        presenter.showEditProjectOverlay(for: project)
    }
}


// MARK: TableView configuration

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let projects = (presenter.projectGroups[indexPath.section].project?.allObjects as! [Project]).sorted { $0.number < $1.number }
        let project = projects[indexPath.row]
        presenter.showProject(project: project)
    }
}

extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.projectGroups.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let projects = presenter.projectGroups[section].project else { return 0 }
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectCustomCell.identifier, for: indexPath) as! ProjectCustomCell
        
        let projects = (presenter.projectGroups[indexPath.section].project?.allObjects as! [Project]).sorted { $0.number < $1.number }
        let project = projects[indexPath.row]
        
        let presenter = presenter.getExpandableCellPresenter(view: cell)
        presenter?.project = project
        
        cell.presenter = presenter
        cell.viewController = self
        cell.configure(project: project)
        
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        switch indexPath.section {
        case 3:
            let showEditProjectOverlayAction = UIContextualAction(style: .normal, title: "") { [self] (action, view, completion) in completion(true)
                performEditProjectOverlay(at: indexPath)
            }
            showEditProjectOverlayAction.image = UIImage(systemName: "checklist")
            showEditProjectOverlayAction.backgroundColor = .systemBlue
            return UISwipeActionsConfiguration(actions: [showEditProjectOverlayAction])
        default:
            return nil
        }
    }
}
