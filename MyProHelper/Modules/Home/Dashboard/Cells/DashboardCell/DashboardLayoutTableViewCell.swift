//
//  DashboardLayoutTableViewCell.swift
//  MyProHelper
//
//

import UIKit

class DashboardLayoutTableViewCell: UITableViewCell {

    @IBOutlet weak var layoutImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with layout:LayoutModel?) {
        self.nameLabel.text = layout?.key?.rawValue
        self.layoutImage.image = layout?.image
    }
}
