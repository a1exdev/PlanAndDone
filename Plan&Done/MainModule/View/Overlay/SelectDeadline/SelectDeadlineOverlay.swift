//
//  SelectDeadlineOverlay.swift
//  Plan&Done
//
//  Created by Alexander Senin on 13.11.2022.
//

import UIKit

class SelectDeadlineOverlay: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    var presenter: MainViewPresenterProtocol!
    
    init() {
        super.init(nibName: "SelectDeadlineOverlay", bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    @IBAction func backViewTapped(_ sender: UIControl) {
        hide()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
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
            self.dismiss(animated: true)
        })
    }
}

extension SelectDeadlineOverlay: MainViewProtocol {
    
}
