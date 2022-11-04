//
//  NewItemOverlay.swift
//  Plan&Done
//
//  Created by Alexander Senin on 04.11.2022.
//

import UIKit

class NewItemOverlay: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    init() {
        super.init(nibName: "NewItemOverlay", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    @IBAction func newTaskButtonTapped(_ sender: Any) {
        print("New task button tapped")
        hide()
    }
    
    @IBAction func newProjectButtonTapped(_ sender: Any) {
        print("New project button tapped")
        hide()
    }
    
    @IBAction func backViewTapped(_ sender: Any) {
        hide()
    }
    
    func configureView() {
        self.view.backgroundColor = .clear
        self.backView.backgroundColor = .black.withAlphaComponent(0.3)
        self.backView.alpha = 0
        self.contentView.alpha = 0
        self.contentView.layer.cornerRadius = 12
    }
    
    func appear(sender: UIViewController) {
        sender.present(self, animated: false) {
            self.show()
        }
    }
    
    private func show() {
        self.contentView.frame.origin.x += 300
        self.contentView.frame.origin.y += 300
        
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
            self.backView.alpha = 1
            self.contentView.alpha = 1
            self.contentView.frame.origin.x -= 300
            self.contentView.frame.origin.y -= 300
        })
    }
    
    func hide() {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
            self.backView.alpha = 0
            self.contentView.alpha = 0
            self.contentView.frame.origin.x += 300
            self.contentView.frame.origin.y += 300
        }, completion: { _ in
            NotificationCenter.default.post(name: Notification.Name("ViewBecameActive"), object: nil)
            self.dismiss(animated: false)
            self.removeFromParent()
        })
    }
}
