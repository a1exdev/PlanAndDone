//
//  Button.swift
//  Plan&Done
//
//  Created by Alexander Senin on 09.11.2022.
//

import UIKit

extension UIButton {

    func checkBoxAnimation() {
        guard let image = self.imageView else { return }
        
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
            image.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }) { (success) in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                self.isSelected = !self.isSelected
                image.transform = .identity
            }, completion: nil)
        }
    }
}
