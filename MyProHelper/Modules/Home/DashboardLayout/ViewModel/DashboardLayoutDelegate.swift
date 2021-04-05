//
//  DashboardLayoutDelegate.swift
//  MyProHelper
//
//  Created by Sourabh Nag on 01/07/20.
//  Copyright © 2020 Sourabh Nag. All rights reserved.
//

import Foundation
import UIKit

class GenericDelegate<T>:NSObject {
    var data:DynamicValue<[T]> = DynamicValue([])
    var didSelectItem:((Int) -> ())?
    var didSelect: ((T) -> ())?
}


class DashboardLayoutDelegate:GenericDelegate<LayoutModel>,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        switch indexPath.section {
        case 0:
            return .delete
        case 1:
            return .insert
        default:
            return .delete
        }
    }
    
}
