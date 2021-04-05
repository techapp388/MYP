//
//  GenericMenuSubmenuViewController.swift
//  MyProHelper
//
//

import UIKit

class GenericMenuSubmenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel:GenericMenuSubmenuViewModel?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUp()

    }

    func setUp() {
//        title = "Customers"
        self.navigationController?.isNavigationBarHidden = false
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(UINib(nibName: "GenericMenuSubmenuTableViewCell", bundle: nil), forCellReuseIdentifier: "GenericMenuSubmenuTableViewCell")
    }
    
}

