//
//  NewTaskOverlay.swift
//  Plan&Done
//
//  Created by Alexander Senin on 07.11.2022.
//

import UIKit

class NewTaskOverlay: UIViewController {
    
    var presenter: MainViewPresenterProtocol!

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var checkButton: UIButton! {
        didSet {
            checkButton.setImage(UIImage(systemName: "square"), for: .normal)
            checkButton.setImage(UIImage(systemName: "checkmark.square.fill", variableValue: 0, configuration: UIImage.SymbolConfiguration(weight: .regular))?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal), for: .selected)
        }
    }
    
    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextField: UITextField!
    
    @IBOutlet weak var projectButton: UIButton!
    
    init() {
        super.init(nibName: "NewTaskOverlay", bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    func appear(sender: UIViewController) {
        sender.present(self, animated: false) {
            self.show()
        }
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
            self.presenter.backToMainView()
        })
    }
    
    private func addTask() {
        var title: String! = taskTitleTextField.text
        if title == "" { title = "New Task" }
        let desc = taskDescriptionTextField.text
        var dayComponent = DateComponents()
        dayComponent.day = 1
        let dtDeadline = Calendar.current.date(byAdding: dayComponent, to: Date())
        let isDone = checkButton.isSelected
        guard let project = (presenter.projectGroups.first?.project?.allObjects as! [Project]).first else { return }
        presenter.addTask(title: title, desc: desc, dtDeadline: dtDeadline, isDone: isDone, project: project)
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
        addTask()
        hide()
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

extension NewTaskOverlay: MainViewProtocol {
    
}
