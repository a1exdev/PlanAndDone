//
//  SelectDayOverlay.swift
//  Plan&Done
//
//  Created by Alexander Senin on 13.11.2022.
//

import UIKit

class SelectDayOverlay: UIViewController, NewTaskProtocol, CustomCellProtocol {
    
    var newTaskPresenter: NewTaskPresenterProtocol!
    var editTaskPresenter: CustomCellPresenterProtocol!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var insideView: UIView!
    
    @IBOutlet weak var todayButton: UIView!
    @IBOutlet weak var somedayButton: UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var task: Task?
    
    init() {
        super.init(nibName: "SelectDayOverlay", bundle: nil)
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        configureGestures()
        configureDatePicker()
    }
    
    func appear(sender: UIViewController) {
        sender.present(self, animated: false) { [self] in
            show()
        }
    }
    
    @IBAction func backViewTapped(_ sender: UIView) {
        hide()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        hide()
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        
        guard let project = (newTaskPresenter.projectGroups[1].project?.allObjects as! [Project]).first(where: { project in
            project.title == "Upcoming"
        }) else { return }
        
        if task != nil {
            editTaskPresenter.task = task
            editTaskPresenter.changeTaskCreation(newCreation: datePicker.date)
            editTaskPresenter.changeTaskProject(newProject: project)
        } else {
            newTaskPresenter.produceTaskCreation(datePicker.date)
            newTaskPresenter.produceTaskProject(project)
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
        
        todayButton.layer.cornerRadius = 6
        somedayButton.layer.cornerRadius = 6
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
            NotificationCenter.default.post(name: Notification.Name("CheckDay"), object: nil)
            dismiss(animated: true)
        })
    }
    
    private func produceTodayProject() {
        
        guard let project = (newTaskPresenter.projectGroups[1].project?.allObjects as! [Project]).first(where: { project in
            project.title == "Today"
        }) else { return }
        
        if task != nil {
            editTaskPresenter.task = task
            editTaskPresenter.changeTaskProject(newProject: project)
        } else {
            newTaskPresenter.produceTaskProject(project)
        }
    }
    
    private func produceSomedayProject() {
        
        guard let project = (newTaskPresenter.projectGroups[1].project?.allObjects as! [Project]).first(where: { project in
            project.title == "Someday"
        }) else { return }

        if task != nil {
            editTaskPresenter.task = task
            editTaskPresenter.changeTaskProject(newProject: project)
        } else {
            newTaskPresenter.produceTaskProject(project)
        }
    }
}

extension SelectDayOverlay: UIGestureRecognizerDelegate {
    
    @objc private func buttonLongPressed(gestureReconizer: UILongPressGestureRecognizer) {
        
        let currentLocationY = gestureReconizer.location(in: insideView).y
        
        switch gestureReconizer.state {
        case .ended:
            switch currentLocationY {
            case (todayButton.frame.minY)...(todayButton.frame.maxY):
                produceTodayProject()
                UIView.animate(withDuration: 0.2, delay: 0) { [self] in
                    todayButton.backgroundColor = UIColor(rgb: 0x2D3037)
                }
                hide()
            case (somedayButton.frame.minY)...(somedayButton.frame.maxY):
                produceSomedayProject()
                UIView.animate(withDuration: 0.2, delay: 0) { [self] in
                    somedayButton.backgroundColor = UIColor(rgb: 0x2D3037)
                }
                hide()
            default:
                break
            }
        default:
            switch currentLocationY {
            case (todayButton.frame.minY)...(todayButton.frame.maxY):
                UIView.animate(withDuration: 0.2, delay: 0) { [self] in
                    todayButton.backgroundColor = .lightGray.withAlphaComponent(0.2)
                    somedayButton.backgroundColor = UIColor(rgb: 0x2D3037)
                }
            case (somedayButton.frame.minY)...(somedayButton.frame.maxY):
                UIView.animate(withDuration: 0.2, delay: 0) { [self] in
                    somedayButton.backgroundColor = .lightGray.withAlphaComponent(0.2)
                    todayButton.backgroundColor = UIColor(rgb: 0x2D3037)
                }
            default:
                UIView.animate(withDuration: 0.2, delay: 0) { [self] in
                    todayButton.backgroundColor = UIColor(rgb: 0x2D3037)
                    somedayButton.backgroundColor = UIColor(rgb: 0x2D3037)
                }
            }
        }
    }
    
    private func configureGestures() {
        let longPressTodayButton = UILongPressGestureRecognizer(target: self, action: #selector(buttonLongPressed))
        longPressTodayButton.delegate = self
        longPressTodayButton.minimumPressDuration = 0
        todayButton.addGestureRecognizer(longPressTodayButton)
        
        let longPressSomedayButton = UILongPressGestureRecognizer(target: self, action: #selector(buttonLongPressed))
        longPressSomedayButton.delegate = self
        longPressSomedayButton.minimumPressDuration = 0
        somedayButton.addGestureRecognizer(longPressSomedayButton)
    }
}
