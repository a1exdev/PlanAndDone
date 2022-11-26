//
//  SettingsOverlay.swift
//  Plan&Done
//
//  Created by Alexander Senin on 13.11.2022.
//

import UIKit

class SettingsOverlay: UIViewController, MainViewProtocol {
    
    var presenter: MainViewPresenterProtocol!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    init() {
        super.init(nibName: "SettingsOverlay", bundle: nil)
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    func appear(sender: UIViewController) {
        sender.present(self, animated: false) { [self] in
            show()
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        hide()
    }
    
    @IBAction func resetAllDataButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure?", message: "To erase all tasks and projects you'll need to restart the app.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [self] _ in
            presenter.resetAllData()
        }))
        present(alert, animated: true)
    }
    
    private func configureView() {
        view.backgroundColor = .clear
        
        backView.backgroundColor = .black.withAlphaComponent(0.3)
        backView.alpha = 0
        
        contentView.alpha = 0
        contentView.layer.cornerRadius = 12
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
            dismiss(animated: true)
        })
    }
}
