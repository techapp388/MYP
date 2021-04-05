//
//  CalendarTableViewCell.swift
//  MyProHelper
//
//

import UIKit

class GenericTableViewCell: UITableViewCell {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var calendarView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with view:UIView) {
        self.calendarView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: self.calendarView.leadingAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: self.calendarView.trailingAnchor, constant: 0).isActive = true
        view.topAnchor.constraint(equalTo: self.calendarView.topAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: self.calendarView.bottomAnchor, constant: 0).isActive = true
//        self.layoutIfNeeded()
        self.shadowView.dropShadowWithoutCaching()
    }
    
}
