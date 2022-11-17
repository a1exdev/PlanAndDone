//
//  SearchOverlay.swift
//  Plan&Done
//
//  Created by Alexander Senin on 13.11.2022.
//

import UIKit

class SearchOverlay: UIViewController {
    
    init() {
        super.init(nibName: "SearchOverlay", bundle: nil)
        self.modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func appear(sender: UIViewController) {
        sender.present(self, animated: false) {
            self.show()
        }
    }
    
    private func configureView() {
        
    }
    
    private func show() {
        
    }
    
    private func hide() {
        
    }
}

extension SearchOverlay: MainViewProtocol {
    
}
