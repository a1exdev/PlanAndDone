//
//  SelectDayOverlay.swift
//  Plan&Done
//
//  Created by Alexander Senin on 13.11.2022.
//

import UIKit

class SelectDayOverlay: UIViewController {
    
    var presenter: NewTaskPresenterProtocol!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var insideView: UIView!
    
    @IBOutlet weak var todayButton: UIView!
    @IBOutlet weak var somedayButton: UIView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    init() {
        super.init(nibName: "SelectDayOverlay", bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
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
    
    @IBAction func backViewTapped(_ sender: UIView) {
        hide()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        hide()
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        presenter.produceTaskCreation(datePicker.date)
        guard let project = (presenter.projectGroups[1].project?.allObjects as! [Project]).first(where: { project in
            project.title == "Upcoming"
        }) else { return }
        presenter.produceTaskProject(project)
        hide()
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
        
        self.todayButton.layer.cornerRadius = 6
        self.somedayButton.layer.cornerRadius = 6
    }
    
    private func configureDatePicker() {
        datePicker.minimumDate = Date()
    }
    
    private func show() {
        self.contentView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       animations: {
            self.backView.alpha = 1
            self.contentView.alpha = 1
            self.contentView.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    private func hide() {
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       animations: {
            self.backView.alpha = 0
            self.contentView.alpha = 0
            self.contentView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { _ in
            NotificationCenter.default.post(name: Notification.Name("CheckDay"), object: nil)
            self.dismiss(animated: true)
        })
    }
    
    private func produceTodayProject() {
        guard let project = (presenter.projectGroups[1].project?.allObjects as! [Project]).first(where: { project in
            project.title == "Today"
        }) else { return }
        presenter.produceTaskProject(project)
    }
    
    private func produceSomedayProject() {
        guard let project = (presenter.projectGroups[1].project?.allObjects as! [Project]).first(where: { project in
            project.title == "Someday"
        }) else { return }
        presenter.produceTaskProject(project)
    }
}

extension SelectDayOverlay: UIGestureRecognizerDelegate {
    
    @objc func buttonLongPressed(gestureReconizer: UILongPressGestureRecognizer) {
        
        let currentLocationY = gestureReconizer.location(in: insideView).y
        
        switch gestureReconizer.state {
        case .ended:
            switch currentLocationY {
            case (todayButton.frame.minY)...(todayButton.frame.maxY):
                produceTodayProject()
                UIView.animate(withDuration: 0.2, delay: 0) {
                    self.todayButton.backgroundColor = UIColor(rgb: 0x2D3037)
                }
                hide()
            case (somedayButton.frame.minY)...(somedayButton.frame.maxY):
                produceSomedayProject()
                UIView.animate(withDuration: 0.2, delay: 0) {
                    self.somedayButton.backgroundColor = UIColor(rgb: 0x2D3037)
                }
                hide()
            default:
                break
            }
        default:
            switch currentLocationY {
            case (todayButton.frame.minY)...(todayButton.frame.maxY):
                UIView.animate(withDuration: 0.2, delay: 0) {
                    self.todayButton.backgroundColor = .lightGray.withAlphaComponent(0.2)
                    self.somedayButton.backgroundColor = UIColor(rgb: 0x2D3037)
                }
            case (somedayButton.frame.minY)...(somedayButton.frame.maxY):
                UIView.animate(withDuration: 0.2, delay: 0) {
                    self.somedayButton.backgroundColor = .lightGray.withAlphaComponent(0.2)
                    self.todayButton.backgroundColor = UIColor(rgb: 0x2D3037)
                }
            default:
                UIView.animate(withDuration: 0.2, delay: 0) {
                    self.todayButton.backgroundColor = UIColor(rgb: 0x2D3037)
                    self.somedayButton.backgroundColor = UIColor(rgb: 0x2D3037)
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

extension SelectDayOverlay: NewTaskProtocol {
    
}
