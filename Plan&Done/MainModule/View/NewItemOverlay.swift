//
//  NewItemOverlay.swift
//  Plan&Done
//
//  Created by Alexander Senin on 04.11.2022.
//

import UIKit

class NewItemOverlay: UIViewController {
    
    var presenter: MainViewPresenterProtocol!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var newTaskButton: UIView!
    @IBOutlet weak var newProjectButton: UIView!
    
    init() {
        super.init(nibName: "NewItemOverlay", bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureGestures()
    }
    
    @IBAction func backViewTapped(_ sender: Any) {
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
        
        self.newTaskButton.layer.cornerRadius = 4
        self.newProjectButton.layer.cornerRadius = 4
    }
    
    private func show() {
        self.contentView.frame.origin.x += 300
        self.contentView.frame.origin.y += 300
        
        UIView.animate(withDuration: 0.15,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
            self.backView.alpha = 1
            self.contentView.alpha = 1
            self.contentView.frame.origin.x -= 300
            self.contentView.frame.origin.y -= 300
        })
    }
    
    private func hide() {
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       animations: {
            self.backView.alpha = 0
            self.contentView.alpha = 0
            self.contentView.frame.origin.x += 300
            self.contentView.frame.origin.y += 300
        }, completion: { _ in
            self.presenter.backToMainView()
        })
    }
}

extension NewItemOverlay: UIGestureRecognizerDelegate {
    
    @objc func buttonLongPressed(gestureReconizer: UILongPressGestureRecognizer) {
        
        let currentLocationY = gestureReconizer.location(in: contentView).y
        
        switch gestureReconizer.state {
        case .ended:
            switch currentLocationY {
            case (newTaskButton.frame.minY)...(newTaskButton.frame.maxY):
                self.presenter.showNewTaskOverlay()
            case (newProjectButton.frame.minY)...(newProjectButton.frame.maxY):
                hide()
            default:
                break
            }
        default:
            switch currentLocationY {
            case (newTaskButton.frame.minY)...(newTaskButton.frame.maxY):
                UIView.animate(withDuration: 0.2, delay: 0) {
                    self.newTaskButton.backgroundColor = .lightGray.withAlphaComponent(0.2)
                    self.newProjectButton.backgroundColor = UIColor(rgb: 0x2D3037)
                }
            case (newProjectButton.frame.minY)...(newProjectButton.frame.maxY):
                UIView.animate(withDuration: 0.2, delay: 0) {
                    self.newProjectButton.backgroundColor = .lightGray.withAlphaComponent(0.2)
                    self.newTaskButton.backgroundColor = UIColor(rgb: 0x2D3037)
                }
            default:
                UIView.animate(withDuration: 0.2, delay: 0) {
                    self.newTaskButton.backgroundColor = UIColor(rgb: 0x2D3037)
                    self.newProjectButton.backgroundColor = UIColor(rgb: 0x2D3037)
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

extension NewItemOverlay: MainViewProtocol {
    
}
