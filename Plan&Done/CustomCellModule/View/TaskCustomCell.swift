//
//  TaskCustomCell.swift
//  Plan&Done
//
//  Created by Alexander Senin on 22.11.2022.
//

import UIKit

class TaskCustomCell: UITableViewCell, CustomCellProtocol {
    
    var presenter: CustomCellPresenterProtocol!
    
    var viewController: UIViewController!
    
    static let identifier = "TaskCustomCell"
    
    private var task: Task?
    
    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextField: UITextField!
    
    @IBOutlet weak var customDeadlineButton: UIButton!
    @IBOutlet weak var customDayButton: UIButton!
    
    @IBOutlet weak var clearCustomDeadlineButton: UIButton!
    @IBOutlet weak var clearCustomDayButton: UIButton!
    
    @IBOutlet weak var customDeadlineSmallButton: UIButton!
    @IBOutlet weak var customDaySmallButton: UIButton! {
        didSet {
            customDayButton.setImage(UIImage(systemName: "calendar", variableValue: 0, configuration: UIImage.SymbolConfiguration(weight: .medium))?.withTintColor(.systemRed, renderingMode: .alwaysOriginal), for: .normal)
        }
    }
    @IBOutlet weak var checkButton: UIButton! {
        didSet {
            checkButton.setImage(UIImage(systemName: "square"), for: .normal)
            checkButton.setImage(UIImage(systemName: "checkmark.square.fill", variableValue: 0, configuration: UIImage.SymbolConfiguration(weight: .regular))?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal), for: .selected)
        }
    }
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        sender.checkBoxAnimation()
        presenter.changeTaskState()
    }
    
    @IBAction func taskTitleTextFieldTyping(_ sender: UITextField) {
        presenter.changeTaskTitle(newTitle: taskTitleTextField.text!)
    }
    
    @IBAction func taskDescriptionTextFieldTyping(_ sender: UITextField) {
        presenter.changeTaskDescription(newDescription: taskDescriptionTextField.text!)
    }
    
    @IBAction func customDeadlineButtonTapped(_ sender: UIButton) {
        presenter.showSelectDeadlineOverlay(viewController: viewController)
    }
    
    @IBAction func customDayButtonTapped(_ sender: UIButton) {
        presenter.showSelectDayOverlay(viewController: viewController)
    }
    
    @IBAction func clearCustomDeadlineButtonTapped(_ sender: UIButton) {
        presenter.changeTaskDeadline(newDeadline: nil)
        customDeadlineButton.isHidden = true
        clearCustomDeadlineButton.isHidden = true
        customDeadlineSmallButton.isHidden = false
    }
    
    @IBAction func clearCustomDayButtonTapped(_ sender: UIButton) {
        let newCreation = Date()
        presenter.changeTaskCreation(newCreation: newCreation)
        customDayButton.isHidden = true
        clearCustomDayButton.isHidden = true
        customDaySmallButton.isHidden = false
    }
    
    @IBAction func customDaySmallButtonTapped(_ sender: UIButton) {
        presenter.showSelectDayOverlay(viewController: viewController)
    }
    
    @IBAction func customDeadlineSmallButtonTapped(_ sender: UIButton) {
        presenter.showSelectDeadlineOverlay(viewController: viewController)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "TaskCustomCell", bundle: nil)
    }
    
    public func configure(task: Task) {
        self.task = task
        
        taskTitleTextField.text = task.title
        
        if let desc = task.desc {
            taskDescriptionTextField.text = desc
        }
        
        if task.isDone {
            checkButton.isSelected = true
        }
    }
    
    public func checkDay() {
        let currentDay = Date().getFormattedDate(format: "d")
        if task!.dtCreation?.getFormattedDate(format: "d") != currentDay {
            customDayButton.setTitle(" \(task!.dtCreation!.getFormattedDate(format: "E, d MMM"))", for: .normal)
            customDayButton.isHidden = false
            clearCustomDayButton.isHidden = false
            customDaySmallButton.isHidden = true
        } else {
            customDayButton.isHidden = true
            clearCustomDayButton.isHidden = true
            customDaySmallButton.isHidden = false
        }
    }
    
    public func checkDeadline() {
        if let dtDeadline = task!.dtDeadline {
            customDeadlineButton.setTitle(" \(dtDeadline.getFormattedDate(format: "E, d MMM"))", for: .normal)
            customDeadlineButton.isHidden = false
            clearCustomDeadlineButton.isHidden = false
            customDeadlineSmallButton.isHidden = true
        } else {
            customDeadlineButton.isHidden = true
            clearCustomDeadlineButton.isHidden = true
            customDeadlineSmallButton.isHidden = false
        }
    }
    
    public func cellSelected() {
        
        checkDay()
        checkDeadline()

        contentView.backgroundColor = UIColor(rgb: 0x2D3037)
        
        if task!.title == "" {
            DispatchQueue.main.async { [self] in
                taskTitleTextField.becomeFirstResponder()
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        checkButton.isSelected = false
        
        taskDescriptionTextField.text = ""
        
        customDayButton.isHidden = true
        customDeadlineButton.isHidden = true
        clearCustomDayButton.isHidden = true
        clearCustomDeadlineButton.isHidden = true
        customDaySmallButton.isHidden = true
        customDeadlineSmallButton.isHidden = true
        
        contentView.backgroundColor = UIColor(rgb: 0x1E2128)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        taskTitleTextField.placeholder = "New To-Do"
        taskTitleTextField.delegate = self
        
        taskDescriptionTextField.placeholder = "Notes"
        taskDescriptionTextField.delegate = self
        taskDescriptionTextField.isHidden = true
        
        customDayButton.isHidden = true
        customDeadlineButton.isHidden = true
        clearCustomDayButton.isHidden = true
        clearCustomDeadlineButton.isHidden = true
        customDaySmallButton.isHidden = true
        customDeadlineSmallButton.isHidden = true
    }
}


// MARK: SearhBar TextField configuration

extension TaskCustomCell: UITextFieldDelegate {
    
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
