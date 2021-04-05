//
//  ProfileCell.swift
//  MyProHelper
//
//

import UIKit

class ProfileCell: UITableViewCell {

    static let ID = String(describing: ProfileCell.self)

    @IBOutlet weak private var profileImageView : UIImageView!
    @IBOutlet weak private var nameLabel        : UILabel!
    @IBOutlet weak private var emailLabel       : UILabel!
    @IBOutlet weak private var closeButton      : UIButton!

    var didPressCloseButton: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupProfileImageView()
        setupCloseButton()
        selectionStyle = .none
    }

    private func setupCloseButton() {
        let closeImage = UIImage(named: Constants.Image.CIRCLE_CLOSE_BUTTON)
        closeButton.setImage(closeImage, for: .normal)
    }

    private func setupProfileImageView() {
        profileImageView.layer.masksToBounds = false
        profileImageView.clipsToBounds = true
    }

    @IBAction private func closeButtonPressed(sender: UIButton) {
        didPressCloseButton?()
    }
}
