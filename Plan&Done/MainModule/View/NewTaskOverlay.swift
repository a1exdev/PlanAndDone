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
    
    @IBAction func exitButtonTapped(_ sender: UIButton) {
        hide()
    }
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func taskTitleTextFieldEdited(_ sender: UITextField) {
    }
    
    @IBAction func taskDescriptionTextFieldEdited(_ sender: UITextField) {
    }
    
    @IBAction func calendarButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func flagButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func projectButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
    }
}

extension NewTaskOverlay: MainViewProtocol {
    
}
