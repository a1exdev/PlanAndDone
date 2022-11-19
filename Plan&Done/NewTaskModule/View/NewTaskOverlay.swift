//
//  NewTaskOverlay.swift
//  Plan&Done
//
//  Created by Alexander Senin on 07.11.2022.
//

import UIKit

class NewTaskOverlay: UIViewController {
    
    var presenter: NewTaskPresenterProtocol!

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextField: UITextField!
    
    @IBOutlet weak var customDeadlineButton: UIButton!
    @IBOutlet weak var customDayButton: UIButton!
    @IBOutlet weak var projectButton: UIButton!
    
    @IBOutlet weak var checkButton: UIButton! {
        didSet {
            checkButton.setImage(UIImage(systemName: "square"), for: .normal)
            checkButton.setImage(UIImage(systemName: "checkmark.square.fill", variableValue: 0, configuration: UIImage.SymbolConfiguration(weight: .regular))?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal), for: .selected)
        }
    }
    
    init() {
        super.init(nibName: "NewTaskOverlay", bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNotifications()
        configureView()
        configureCustomButtons()
    }
    
    @IBAction func exitButtonTapped(_ sender: UIButton) {
        hide()
    }

    @IBAction func checkButtonTapped(_ sender: UIButton) {
        sender.checkBoxAnimation()
    }
    
    @IBAction func calendarButtonTapped(_ sender: UIButton) {
        self.presenter.showSelectDayOverlay(viewController: self)
    }
    
    @IBAction func flagButtonTapped(_ sender: UIButton) {
        self.presenter.showSelectDeadlineOverlay(viewController: self)
    }
    
    @IBAction func projectButtonTapped(_ sender: UIButton) {
        self.presenter.showSelectProjectOverlay(viewController: self)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        createTask()
        hide()
    }
    
    func appear(sender: UIViewController) {
        sender.present(self, animated: false) {
            self.show()
        }
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(checkProject),
            name: Notification.Name("CheckProject"),
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
    }
    
    private func configureView() {
        self.view.backgroundColor = .clear
        
        self.backView.backgroundColor = .black.withAlphaComponent(0.3)
        self.backView.alpha = 0
        
        self.contentView.alpha = 0
        self.contentView.layer.cornerRadius = 12
        self.contentView.clipsToBounds = true
        
        taskTitleTextField.delegate = self
        taskDescriptionTextField.delegate = self
        taskTitleTextField.becomeFirstResponder()
    }
    
    private func configureCustomButtons() {
        customDeadlineButton.isHidden = true
        customDayButton.isHidden = true
        customDayButton.setImage(UIImage(systemName: "calendar", variableValue: 0, configuration: UIImage.SymbolConfiguration(weight: .regular))?.withTintColor(.systemRed, renderingMode: .alwaysOriginal), for: .normal)
    }
    
    private func show() {
        self.contentView.alpha = 1
        self.contentView.frame.origin.y += 500
        
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 20,
                       options: .curveEaseOut,
                       animations: {
            self.backView.alpha = 1
            self.contentView.frame.origin.y -= 500
        })
    }
    
    private func hide() {
        view.endEditing(true)
        
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       animations: {
            self.backView.alpha = 0
            self.contentView.alpha = 0
            self.contentView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { _ in
            self.presenter.resetTask()
            self.presenter.backToMainView()
        })
    }
    
    private func createTask() {
        
        if presenter.fetchTaskCreation() == nil {
            presenter.produceTaskCreation(Date())
        }
        
        checkButton.isSelected ? presenter.produceTaskIsDone(true) : presenter.produceTaskIsDone(false)
        
        if taskTitleTextField.text == "" {
            presenter.produceTaskTitle("New Task")
        } else {
            presenter.produceTaskTitle(taskTitleTextField.text!)
        }
        
        if let desc = taskDescriptionTextField.text {
            presenter.produceTaskDesc(desc)
        }
        
        if presenter.fetchTaskProject() == nil {
            guard let project = (presenter.projectGroups.first?.project?.allObjects as! [Project]).first(where: { project in
                project.title == "Inbox"
            }) else { return }
            presenter.produceTaskProject(project)
        }
        
        presenter.createTask()
    }
    
    @objc private func checkProject() {
        guard let project = presenter.fetchTaskProject() else { return }
        switch project.title {
        case "Inbox":
            projectButton.setTitle(" Inbox", for: .normal)
            projectButton.setImage(UIImage(systemName: ProjectImage.tray.rawValue), for: .normal)
            projectButton.setTitleColor(.systemGray, for: .normal)
            projectButton.setTitleColor(.systemGray, for: .highlighted)
        case "Anytime":
            projectButton.setTitle(" No Project", for: .normal)
            projectButton.setImage(UIImage(systemName: "arrow.forward", variableValue: 0, configuration: UIImage.SymbolConfiguration(weight: .regular))?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal), for: .normal)
            projectButton.setTitleColor(.systemBlue, for: .normal)
            projectButton.setTitleColor(.systemBlue, for: .highlighted)
        default:
            projectButton.setTitle(" \(project.title!)", for: .normal)
            projectButton.setImage(UIImage(systemName: "arrow.forward", variableValue: 0, configuration: UIImage.SymbolConfiguration(weight: .regular))?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal), for: .normal)
            projectButton.setTitleColor(.systemBlue, for: .normal)
            projectButton.setTitleColor(.systemBlue, for: .highlighted)
        }
    }
    
    @objc private func checkDay() {
        if let day = presenter.fetchTaskCreation() {
            customDayButton.isHidden = false
            customDayButton.setTitle(" \(day.getFormattedDate(format: "E, d MMM"))", for: .normal)
        }
    }
    
    @objc private func checkDeadline() {
        if let day = presenter.fetchTaskDeadline() {
            customDeadlineButton.isHidden = false
            customDeadlineButton.setTitle(" \(day.getFormattedDate(format: "E, d MMM"))", for: .normal)
        }
    }
}

extension NewTaskOverlay: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case taskTitleTextField:
            taskDescriptionTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        
        return false
    }
}

extension NewTaskOverlay: NewTaskProtocol {
    
}
