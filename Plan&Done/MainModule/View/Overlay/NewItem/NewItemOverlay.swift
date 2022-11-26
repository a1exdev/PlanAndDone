//
//  NewItemOverlay.swift
//  Plan&Done
//
//  Created by Alexander Senin on 04.11.2022.
//

import UIKit

class NewItemOverlay: UIViewController, MainViewProtocol {
    
    var presenter: MainViewPresenterProtocol!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var newTaskButton: UIView!
    @IBOutlet weak var newProjectButton: UIView!
    
    init() {
        super.init(nibName: "NewItemOverlay", bundle: nil)
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
    
    func appear(sender: UIViewController) {
        sender.present(self, animated: false) { [self] in
            show()
        }
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
        
        newTaskButton.layer.cornerRadius = 6
        newProjectButton.layer.cornerRadius = 6
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
            presenter.backToMainView()
        })
    }
}

extension NewItemOverlay: UIGestureRecognizerDelegate {
    
    @objc private func buttonLongPressed(gestureReconizer: UILongPressGestureRecognizer) {
        
        let currentLocationY = gestureReconizer.location(in: contentView).y
        
        switch gestureReconizer.state {
        case .ended:
            switch currentLocationY {
            case (newTaskButton.frame.minY)...(newTaskButton.frame.maxY):
                presenter.showNewTaskOverlay()
            case (newProjectButton.frame.minY)...(newProjectButton.frame.maxY):
                presenter.addProject()
                hide()
            default:
                break
            }
        default:
            switch currentLocationY {
            case (newTaskButton.frame.minY)...(newTaskButton.frame.maxY):
                UIView.animate(withDuration: 0.2, delay: 0) { [self] in
                    newTaskButton.backgroundColor = .lightGray.withAlphaComponent(0.2)
                    newProjectButton.backgroundColor = UIColor(rgb: 0x2D3037)
                }
            case (newProjectButton.frame.minY)...(newProjectButton.frame.maxY):
                UIView.animate(withDuration: 0.2, delay: 0) { [self] in
                    newProjectButton.backgroundColor = .lightGray.withAlphaComponent(0.2)
                    newTaskButton.backgroundColor = UIColor(rgb: 0x2D3037)
                }
            default:
                UIView.animate(withDuration: 0.2, delay: 0) { [self] in
                    newTaskButton.backgroundColor = UIColor(rgb: 0x2D3037)
                    newProjectButton.backgroundColor = UIColor(rgb: 0x2D3037)
                }
            }
        }
    }
    
    private func configureGestures() {
        let longPressNewTaskButton = UILongPressGestureRecognizer(target: self, action: #selector(buttonLongPressed))
        longPressNewTaskButton.delegate = self
        longPressNewTaskButton.minimumPressDuration = 0
        newTaskButton.addGestureRecognizer(longPressNewTaskButton)
        
        let longPressNewProjectButton = UILongPressGestureRecognizer(target: self, action: #selector(buttonLongPressed))
        longPressNewProjectButton.delegate = self
        longPressNewProjectButton.minimumPressDuration = 0
        newProjectButton.addGestureRecognizer(longPressNewProjectButton)
    }
}
