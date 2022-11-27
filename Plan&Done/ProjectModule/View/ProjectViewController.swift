//
//  ProjectViewController.swift
//  Plan&Done
//
//  Created by Alexander Senin on 28.10.2022.
//

import UIKit

class ProjectViewController: UIViewController, ProjectViewProtocol {
    
    var presenter: ProjectViewPresenterProtocol!
    
    // MARK: View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNotifications()
        
        configureView()
        configureNewTaskButton()
        configureTasksTableView()
        
        setupConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
            selector: #selector(newTaskHasBeenAdded),
            name: Notification.Name("NewTaskHasBeenAdded"),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(checkDay),
            name: Notification.Name("CheckDay"),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(checkDeadline),
            name: Notification.Name("CheckDeadline"),
            object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func checkDay() {
        guard let cell = tableView.cellForRow(at: IndexPath(row: selectedIndex, section: 0)) as? TaskCustomCell else { return }
        cell.checkDay()
    }
    
    @objc private func checkDeadline() {
        guard let cell = tableView.cellForRow(at: IndexPath(row: selectedIndex, section: 0)) as? TaskCustomCell else { return }
        cell.checkDeadline()
    }
    
    @objc private func viewHasBecomeActive() {
        tableView.reloadData()
        
        UIView.animate(withDuration: 0.25,
                       delay: 0.2,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 15,
                       options: .curveEaseOut,
                       animations: { [self] in
            newTaskButton.alpha = 1
            newTaskButton.frame.origin.y -= 110
        })
    }
    
    @objc private func newTaskHasBeenAdded() {
        tableView.reloadData()
        configureTasksTableView()
        
        let indexPath = IndexPath(row: 0, section: 0)
        UIView.animate(withDuration: 0.2) { [self] in
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            tableView.delegate?.tableView!(tableView, didSelectRowAt: indexPath)
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + 120, right: 0)
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
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.sectionHeaderHeight = 8
        table.sectionFooterHeight = 8
        table.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        table.isScrollEnabled = false
        table.register(TaskCustomCell.nib(), forCellReuseIdentifier: TaskCustomCell.identifier)
        return table
    }()
    
    private var tableViewHeight: CGFloat {
        tableView.layoutIfNeeded()
        return tableView.contentSize.height
    }
    
    private var selectedIndex = -1
    
    private let newTaskButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "plus")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 28)
        
        var button  = UIButton(configuration: config)
        button.clipsToBounds = true
        return button
    }()
    
    private func configureView() {
        
        if presenter.project.title == "" {
            title = "New Project"
        } else {
            title = presenter.project.title
        }
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = UIColor(rgb: 0x1E2128)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        hideKeyboardWhenTappedAround()
    }
    
    private func configureNewTaskButton() {
        newTaskButton.frame = CGRect(x: view.bounds.maxX - 75, y: view.bounds.maxY * 0.88, width: 58, height: 58)
        newTaskButton.layer.cornerRadius = (newTaskButton.frame.size.width / 2)
        newTaskButton.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        view.addSubview(newTaskButton)
    }
    
    @objc func addTask() {
        if selectedIndex != -1 {
            selectedIndex = -1
        }
        
        presenter.createTask()
    }
    
    private func configureTasksTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = view.backgroundColor
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.frame = CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width - 16, height: tableViewHeight + 70)
        contentView.addSubview(tableView)
    }
    
    
    // MARK: Constraints
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: 8),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tableView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: contentView.leftAnchor)
        ])
    }
    
    private func performEditTaskOverlay(at indexPath: IndexPath) {
        
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
            newTaskButton.alpha = 0
            newTaskButton.frame.origin.y += 110
        })
        
        if let tasks = tasks {
            showEditTaskOverlay(for: tasks[indexPath.row])
        }
    }
    
    private func showEditTaskOverlay(for task: Task) {
        presenter.showEditTaskOverlay(for: task)
    }
}


// MARK: TableView configuration

extension ProjectViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedIndex == -1 {
            selectedIndex = indexPath.row
        } else {
            selectedIndex = -1
        }
        
        UIView.transition(with: tableView, duration: 0.2, options: .transitionCrossDissolve, animations: { tableView.reloadData() }, completion: nil)
    }
}

extension ProjectViewController: UITableViewDataSource {
    
    var tasks: [Task]? {
        get {
            return (presenter.project.task?.allObjects as? [Task])?.sorted { $0.dtCreation! > $1.dtCreation! }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tasks = tasks else { return 0 }
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedIndex {
            return 150
        } else {
            return 45
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCustomCell.identifier, for: indexPath) as! TaskCustomCell
        
        guard let tasks = tasks else { return cell }
        let task = tasks[indexPath.row]
        
        let presenter = presenter.getCustomCellPresenter(view: cell)
        presenter?.task = task
        
        cell.presenter = presenter
        cell.viewController = self
        cell.configure(task: task)
        
        cell.selectionStyle = .none
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        if indexPath.row == selectedIndex {
            cell.cellSelected()
            cell.taskTitleTextField.isUserInteractionEnabled = true
        } else {
            cell.taskTitleTextField.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let showEditItemOverlayAction = UIContextualAction(style: .normal, title: "") { [self] (action, view, completion) in completion(true)
            performEditTaskOverlay(at: indexPath)
        }
        
        showEditItemOverlayAction.image = UIImage(systemName: "checklist")
        showEditItemOverlayAction.backgroundColor = .systemBlue
        
        if indexPath.row == selectedIndex || selectedIndex != -1 {
            return nil
        }
        
        return UISwipeActionsConfiguration(actions: [showEditItemOverlayAction])
    }
}
