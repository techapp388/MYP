//
//  DashboardLayoutViewModel.swift
//  MyProHelper
//
//  Created by Sourabh Nag on 01/07/20.
//  Copyright © 2020 Sourabh Nag. All rights reserved.
//

import Foundation
import UIKit

struct DashboardLayoutViewModel {
    
    weak var dataSource:GenericDataSource<LayoutModel>?
    weak var delegate:GenericDelegate<LayoutModel>?
    var onErrorHandling:((ErrorResult?) -> ())?
    var approvedDashboardControllerList: [ControllerKeys] = [.calendar, .jobList]

    init(dataSource:GenericDataSource<LayoutModel>,delegate:GenericDelegate<LayoutModel>) {
        self.dataSource = dataSource
        self.delegate = delegate
    }
    
    func fetchLayoutModels() {

    }
    
    func updateDB() {

    }
    
}
