//
//  MainViewController.swift
//  Plan&Done
//
//  Created by Alexander Senin on 28.10.2022.
//

import UIKit

class MainViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    let searchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Projects"
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search tasks and projects"
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
