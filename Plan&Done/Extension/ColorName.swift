//
//  ColorName.swift
//  Plan&Done
//
//  Created by Alexander Senin on 02.11.2022.
//

import UIKit

extension UIColor {
    var name: String {
        switch self {
            case UIColor.systemRed: return "systemRed"
            case UIColor.systemOrange: return "systemOrange"
            case UIColor.systemYellow: return "systemYellow"
            case UIColor.systemGreen: return "systemGreen"
            case UIColor.systemMint: return "systemMint"
            case UIColor.systemTeal: return "systemTeal"
            case UIColor.systemCyan: return "systemCyan"
            case UIColor.systemBlue: return "systemBlue"
            case UIColor.systemIndigo: return "systemIndigo"
            case UIColor.systemPurple: return "systemPurple"
            case UIColor.systemPink: return "systemPink"
            case UIColor.systemBrown: return "systemBrown"
            case UIColor.systemGray: return "systemGray"
        default:
            return "not system color"
        }
    }
    
    static func colorWith(name: String) -> UIColor? {
        let selector = Selector("\(name)Color")
        if UIColor.self.responds(to: selector) {
            let color = UIColor.self.perform(selector).takeUnretainedValue()
            return (color as? UIColor)
        } else {
            return nil
        }
    }
}
