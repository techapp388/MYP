//
//  SideMenuSubCell.swift
//  MyProHelper
//
//

import UIKit

class SideMenuSubCell: UITableViewCell {

    static let ID = String(describing: SideMenuSubCell.self)
    
    @IBOutlet weak private var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
}
