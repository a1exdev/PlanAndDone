//
//  SelectProjectOverlay.swift
//  Plan&Done
//
//  Created by Alexander Senin on 13.11.2022.
//

import UIKit

class SelectProjectOverlay: UIViewController, NewTaskProtocol, CustomCellProtocol {
    
    var newTaskPresenter: NewTaskPresenterProtocol!
    var editTaskPresenter: CustomCellPresenterProtocol!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var insideView: UIView!
    
    @IBOutlet weak var inboxButton: UIView!
    @IBOutlet weak var noProjectButton: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var task: Task?
    
    init() {
        super.init(nibName: "SelectProjectOverlay", bundle: nil)
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureGestures()
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
        
        inboxButton.layer.cornerRadius = 8
        noProjectButton.layer.cornerRadius = 8
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: -30, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "projectCell")
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
            NotificationCenter.default.post(name: Notification.Name("CheckProject"), object: nil)
            dismiss(animated: true)
        })
    }
    
    private func produceInboxProject() {
        
        guard let project = (newTaskPresenter.projectGroups.first?.project?.allObjects as! [Project]).first(where: { project in
            project.title == "Inbox"
        }) else { return }
        
        if task != nil {
            editTaskPresenter.task = task
            editTaskPresenter.changeTaskProject(newProject: project)
        } else {
            newTaskPresenter.produceTaskProject(project)
        }
    }
    
    private func produceAnytimeProject() {
        
        guard let project = (newTaskPresenter.projectGroups[1].project?.allObjects as! [Project]).first(where: { project in
            project.title == "Anytime"
        }) else { return }

        if task != nil {
            editTaskPresenter.task = task
            editTaskPresenter.changeTaskProject(newProject: project)
        } else {
            newTaskPresenter.produceTaskProject(project)
        }
    }
}

extension SelectProjectOverlay: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let customProject = (newTaskPresenter.projectGroups.last?.project?.allObjects as! [Project])[indexPath.row]
        
        if task != nil {
            editTaskPresenter.task = task
            editTaskPresenter.changeTaskProject(newProject: customProject)
        } else {
            newTaskPresenter.produceTaskProject(customProject)
        }
        
        hide()
    }
}

extension SelectProjectOverlay: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let customProjectsCount = (newTaskPresenter.projectGroups.last?.project?.allObjects as! [Project]).count
        return customProjectsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath)
        
        let customProjects = newTaskPresenter.projectGroups.last?.project?.allObjects as! [Project]
        
        cell.textLabel?.text = customProjects[indexPath.row].title
        cell.imageView?.image = UIImage(systemName: ProjectImage.pie.rawValue)
        cell.imageView?.tintColor = .systemBlue
        cell.backgroundColor = .clear
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        return cell
    }
}

extension SelectProjectOverlay: UIGestureRecognizerDelegate {
    
    @objc private func buttonLongPressed(gestureReconizer: UILongPressGestureRecognizer) {
        
        let currentLocationY = gestureReconizer.location(in: insideView).y
        
        switch gestureReconizer.state {
        case .ended:
            switch currentLocationY {
                
            case (inboxButton.frame.minY)...(inboxButton.frame.maxY):
                produceInboxProject()
                UIView.animate(withDuration: 0.2, delay: 0) { [self] in
                    inboxButton.backgroundColor = UIColor(rgb: 0x2D3037)
                }
                hide()
            case (noProjectButton.frame.minY)...(noProjectButton.frame.maxY):
                produceAnytimeProject()
                UIView.animate(withDuration: 0.2, delay: 0) { [self] in
                    noProjectButton.backgroundColor = UIColor(rgb: 0x2D3037)
                }
                hide()
            default:
                break
            }
        default:
            switch currentLocationY {
            case (inboxButton.frame.minY)...(inboxButton.frame.maxY):
                UIView.animate(withDuration: 0.2, delay: 0) { [self] in
                    inboxButton.backgroundColor = .lightGray.withAlphaComponent(0.2)
                    noProjectButton.backgroundColor = UIColor(rgb: 0x2D3037)
                }
            case (noProjectButton.frame.minY)...(noProjectButton.frame.maxY):
                UIView.animate(withDuration: 0.2, delay: 0) { [self] in
                    noProjectButton.backgroundColor = .lightGray.withAlphaComponent(0.2)
                    inboxButton.backgroundColor = UIColor(rgb: 0x2D3037)
                }
            default:
                UIView.animate(withDuration: 0.2, delay: 0) { [self] in
                    inboxButton.backgroundColor = UIColor(rgb: 0x2D3037)
                    noProjectButton.backgroundColor = UIColor(rgb: 0x2D3037)
                }
            }
        }
    }
    
    private func configureGestures() {
        let longPressInboxButton = UILongPressGestureRecognizer(target: self, action: #selector(buttonLongPressed))
        longPressInboxButton.delegate = self
        longPressInboxButton.minimumPressDuration = 0
        inboxButton.addGestureRecognizer(longPressInboxButton)
        
        let longPressNoProjectButton = UILongPressGestureRecognizer(target: self, action: #selector(buttonLongPressed))
        longPressNoProjectButton.delegate = self
        longPressNoProjectButton.minimumPressDuration = 0
        noProjectButton.addGestureRecognizer(longPressNoProjectButton)
    }
}
