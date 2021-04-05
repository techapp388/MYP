//
//  DashboardLayoutViewController.swift
//  MyProHelper
//
//  Created by Sourabh Nag on 01/07/20.
//  Copyright © 2020 Sourabh Nag. All rights reserved.
//

import UIKit

protocol DashboardLayoutViewControllerDelegate:class {
    func updateLayout()
}

class DashboardLayoutViewController: UIViewController {

    @IBOutlet weak var navigationView: PresentationNavigationView!
    @IBOutlet weak var tableView: UITableView!
    weak var layoutDelegate:DashboardLayoutViewControllerDelegate?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    let dataSource = DashboardLayoutDataSource()
    let delegate = DashboardLayoutDelegate()
    
    lazy var viewModel:DashboardLayoutViewModel = {
        let viewModel = DashboardLayoutViewModel(dataSource: dataSource,delegate: delegate)
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    func setUp() {
        self.navigationView.delegate = self
        self.tableView.dataSource = dataSource
        self.tableView.delegate = delegate
        self.tableView.register(UINib(nibName: "DashboardLayoutTableViewCell", bundle: nil), forCellReuseIdentifier: "DashboardLayoutTableViewCell")
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        self.tableView.isEditing = true
        self.dataSource.dataArray.addObserver(self) {[weak self] (layouts) in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        let header = DashboardLayoutTableHeader()
        header.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height*0.15)
        self.tableView.tableHeaderView = header
        self.viewModel.fetchLayoutModels()
    }

}

extension DashboardLayoutViewController:PresentationNavigationViewDelegate {
    
    func cancelButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func doneButtonAction() {
        self.viewModel.updateDB()
        self.layoutDelegate?.updateLayout()
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
