//
//  SelectDeadlineOverlay.swift
//  Plan&Done
//
//  Created by Alexander Senin on 13.11.2022.
//

import UIKit

class SelectDeadlineOverlay: UIViewController, NewTaskProtocol, CustomCellProtocol {
    
    var newTaskPresenter: NewTaskPresenterProtocol!
    var editTaskPresenter: CustomCellPresenterProtocol!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var task: Task?
    
    init() {
        super.init(nibName: "SelectDeadlineOverlay", bundle: nil)
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureDatePicker()
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
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        if task != nil {
            editTaskPresenter.task = task
            editTaskPresenter.changeTaskDeadline(newDeadline: datePicker.date)
        } else {
            newTaskPresenter.produceTaskDeadline(datePicker.date)
        }
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
    
    private func configureDatePicker() {
        datePicker.minimumDate = Date()
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
            NotificationCenter.default.post(name: Notification.Name("CheckDeadline"), object: nil)
            dismiss(animated: true)
        })
    }
}
