//
//  EditProjectOverlay.swift
//  Plan&Done
//
//  Created by Alexander Senin on 24.11.2022.
//

import UIKit

class EditProjectOverlay: UIViewController, CustomCellProtocol {
    
    var presenter: CustomCellPresenterProtocol!

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var customDayButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    init() {
        super.init(nibName: "EditProjectOverlay", bundle: nil)
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    func appear(sender: UIViewController, project: Project) {
        sender.present(self, animated: false) { [self] in
            show()
        }
        presenter.project = project
    }
    
    @IBAction func backViewTapped(_ sender: UIControl) {
        hide()
    }
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        hide()
    }
    
    @IBAction func customDayButtonTapped(_ sender: UIButton) {
        presenter.showSelectDayOverlay(viewController: self)
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure you want to delete this project? It's items will also be deleted. This cannot be undone.", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [self] _ in
            presenter.removeProject()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    @IBAction func moreButtonTapped(_ sender: UIButton) {
    }
    
    private func configureView() {
        view.backgroundColor = .clear
        
        backView.alpha = 0
        
        contentView.alpha = 0
        contentView.layer.cornerRadius = 12
        
        doneButton.alpha = 0
    }
    
    private func show() {
        contentView.frame.origin.y += 100
        doneButton.frame.origin.y -= 100
        
        UIView.animate(withDuration: 0.15,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: { [self] in
            backView.alpha = 1
            contentView.alpha = 1
            doneButton.alpha = 1
            contentView.frame.origin.y -= 100
            doneButton.frame.origin.y += 100
        })
    }
    
    private func hide() {
        UIView.animate(withDuration: 0.15,
                       delay: 0,
                       animations: { [self] in
            backView.alpha = 0
            contentView.alpha = 0
            doneButton.alpha = 0
        }, completion: { [self] _ in
            presenter.backToMainView()
        })
    }
}
