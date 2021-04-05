//
//  DashboardLayoutDataSource.swift
//  MyProHelper
//
//  Created by Sourabh Nag on 01/07/20.
//  Copyright © 2020 Sourabh Nag. All rights reserved.
//

import Foundation
import UIKit 

class DashboardLayoutDataSource:GenericDataSource<LayoutModel>,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.value[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardLayoutTableViewCell") as? DashboardLayoutTableViewCell else {
            return UITableViewCell()
        }
        let layout = dataArray.value[indexPath.section][indexPath.row]
        cell.configure(with: layout)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let model = dataArray.value[indexPath.section][indexPath.row]
        switch editingStyle {
        case .delete:
            
            //For Default layout at dashboard
            guard dataArray.value[indexPath.section].count > 1 else {
                return
            }
            
            self.dataArray.value[0].remove(at: indexPath.row)
            self.dataArray.value[1].append(model)
        default:
            self.dataArray.value[0].append(model)
            self.dataArray.value[1].remove(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Add Widgets to Dashboard"
        }else if section == 0 {
            return "Remove Widgets from Dashboard"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            
            //For Default layout at dashboard
            if dataArray.value[indexPath.section].count > 1 {
                return true
            }else {
                return false
            }
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let model = dataArray.value[sourceIndexPath.section][sourceIndexPath.row]
        dataArray.value[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        dataArray.value[destinationIndexPath.section].insert(model, at: destinationIndexPath.row)
    }
    
}
