//
//  ProjectCustomCell.swift
//  Plan&Done
//
//  Created by Alexander Senin on 26.11.2022.
//

import UIKit

class ProjectCustomCell: UITableViewCell, CustomCellProtocol {
    
    var presenter: CustomCellPresenterProtocol!
    
    var viewController: UIViewController!
    
    static let identifier = "ProjectCustomCell"
    
    private var title = ""
    
    @IBOutlet weak var projectIcon: UIImageView!
    @IBOutlet weak var projectTitleTextField: UITextField!
    
    @IBAction func projectTitleTextFieldTyping(_ sender: UITextField) {
        presenter.changeProjectTitle(newTitle: projectTitleTextField.text!)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "ProjectCustomCell", bundle: nil)
    }
    
    public func configure(title: String, image: String, color: String) {
        projectTitleTextField.text = title
        self.title = title
        
        projectIcon.image = UIImage(systemName: image, variableValue: 0, configuration: UIImage.SymbolConfiguration(weight: .regular))?.withTintColor(UIColor.colorWith(name: color)!, renderingMode: .alwaysOriginal)
    }
    
    public func isAdded() {
        if title == "" {
            DispatchQueue.main.async { [self] in
                projectTitleTextField.isUserInteractionEnabled = true
                projectTitleTextField.becomeFirstResponder()
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        contentView.backgroundColor = UIColor(rgb: 0x1E2128)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        projectTitleTextField.isUserInteractionEnabled = false
        projectTitleTextField.placeholder = "New Project"
        projectTitleTextField.delegate = self
    }
}


// MARK: SearhBar TextField configuration

extension ProjectCustomCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.isUserInteractionEnabled = false
        return false
    }
}
