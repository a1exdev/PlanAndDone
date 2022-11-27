//
//  MoreActionsOverlay.swift
//  Plan&Done
//
//  Created by Alexander Senin on 27.11.2022.
//

import UIKit

class MoreActionsOverlay: UIViewController, EditItemProtocol {
    
    var presenter: EditItemPresenterProtocol!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var markAsCompletedButton: UIView!
    @IBOutlet weak var setDeadlineButton: UIView!
    
    init() {
        super.init(nibName: "MoreActionsOverlay", bundle: nil)
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureGestures()
    }
    
    func appear(sender: UIViewController, task: Task?, project: Project?) {
        sender.present(self, animated: false) { [self] in
            show()
        }
        presenter.task = task
        presenter.project = project
    }
    
    @IBAction func backViewTapped(_ sender: UIControl) {
        hide()
    }
    
    private func configureView() {
        view.backgroundColor = .clear
        
        backView.backgroundColor = .black.withAlphaComponent(0.3)
        backView.alpha = 0
        
        contentView.alpha = 0
        contentView.layer.cornerRadius = 12
        
        markAsCompletedButton.layer.cornerRadius = 6
        setDeadlineButton.layer.cornerRadius = 6
    }
    
    private func show() {
        contentView.frame.origin.x += 300
        contentView.frame.origin.y += 300
        
        UIView.animate(withDuration: 0.15,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: { [self] in
            backView.alpha = 1
            contentView.alpha = 1
            contentView.frame.origin.x -= 300
            contentView.frame.origin.y -= 300
        })
    }
    
    private func hide() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       animations: { [self] in
            backView.alpha = 0
            contentView.alpha = 0
            contentView.frame.origin.x += 300
            contentView.frame.origin.y += 300
        }, completion: { [self] _ in
            dismiss(animated: true)
        })
    }
}

extension MoreActionsOverlay: UIGestureRecognizerDelegate {
    
    @objc private func buttonLongPressed(gestureReconizer: UILongPressGestureRecognizer) {
        
        let currentLocationY = gestureReconizer.location(in: contentView).y
        
        switch gestureReconizer.state {
        case .ended:
            switch currentLocationY {
            case (markAsCompletedButton.frame.minY)...(markAsCompletedButton.frame.maxY):
                if presenter.task != nil {
                    presenter.changeTaskState()
                }
                if presenter.project != nil {
                    presenter.changeProjectState()
                }
            case (setDeadlineButton.frame.minY)...(setDeadlineButton.frame.maxY):
                presenter.showSelectDeadlineOverlay(viewController: self)
            default:
                break
            }
        default:
            switch currentLocationY {
            case (markAsCompletedButton.frame.minY)...(markAsCompletedButton.frame.maxY):
                UIView.animate(withDuration: 0.2, delay: 0) { [self] in
                    markAsCompletedButton.backgroundColor = .lightGray.withAlphaComponent(0.2)
                    setDeadlineButton.backgroundColor = UIColor(rgb: 0x2D3037)
                }
            case (setDeadlineButton.frame.minY)...(setDeadlineButton.frame.maxY):
                UIView.animate(withDuration: 0.2, delay: 0) { [self] in
                    setDeadlineButton.backgroundColor = .lightGray.withAlphaComponent(0.2)
                    markAsCompletedButton.backgroundColor = UIColor(rgb: 0x2D3037)
                }
            default:
                UIView.animate(withDuration: 0.2, delay: 0) { [self] in
                    markAsCompletedButton.backgroundColor = UIColor(rgb: 0x2D3037)
                    setDeadlineButton.backgroundColor = UIColor(rgb: 0x2D3037)
                }
            }
        }
    }
    
    private func configureGestures() {
        let longPressNewTaskButton = UILongPressGestureRecognizer(target: self, action: #selector(buttonLongPressed))
        longPressNewTaskButton.delegate = self
        longPressNewTaskButton.minimumPressDuration = 0
        markAsCompletedButton.addGestureRecognizer(longPressNewTaskButton)
        
        let longPressNewProjectButton = UILongPressGestureRecognizer(target: self, action: #selector(buttonLongPressed))
        longPressNewProjectButton.delegate = self
        longPressNewProjectButton.minimumPressDuration = 0
        setDeadlineButton.addGestureRecognizer(longPressNewProjectButton)
    }
}
