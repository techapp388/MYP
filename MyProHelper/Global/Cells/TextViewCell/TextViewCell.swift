//
//  TextViewCell.swift
//  MyProHelper
//
//

import UIKit

class TextViewCell: BaseFormCell {

    static let ID = String(describing: TextViewCell.self)
    @IBOutlet weak private var titleLabel               : UILabel!
    @IBOutlet weak private var textView                 : UITextView!
    @IBOutlet weak private var requireSign              : UILabel!
    @IBOutlet weak private var errorLabel               : UILabel!
    @IBOutlet weak private var errorHeightConstraint    : NSLayoutConstraint!
    
    private let errorHeight: CGFloat = 15
    var delegate: TextFieldCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureTextView()
    }
    
    private func configureTextView() {
        textView.delegate = self
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 4
        setValid()
    }
    
    private func setValid() {
        errorLabel.isHidden = true
        errorHeightConstraint.constant = 0
        textView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func setInvalid(message: String) {
        guard showValidation == true else { return }
        errorLabel.isHidden = false
        errorHeightConstraint.constant = errorHeight
        errorLabel.text = message
        textView.layer.borderColor = UIColor.systemRed.cgColor
    }
    
    private func disableCell(isDisabled: Bool) {
        textView.isUserInteractionEnabled = isDisabled
    }
    
    private func setRequire(isRequired: Bool) {
        if isRequired {
            requireSign.isHidden = false
        }
        else {
            requireSign.isHidden = true
        }
    }
    
    override func bindData() {
        guard let data = data else { return }
        delegate?.didUpdateTextField(text: textView.text, data: data)
    }
    
    override func validateData() {
        if let data = data {
            switch data.validation {
            case .Valid:
                setValid()
            case .Invalid(let message):
                setInvalid(message: message)
            }
        }
    }
    
    func bindTextView(data: TextFieldCellData) {
        self.data = data
        titleLabel.text = data.title
        textView.text = data.text
        setRequire(isRequired: data.isRequired)
        disableCell(isDisabled: data.isActive)
        
        switch data.validation {
        case .Valid:
            setValid()
        case .Invalid(let message):
            setInvalid(message: message)
        }
    }
}

extension TextViewCell: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let data = data else { return  }
        data.text = textView.text
        delegate?.didUpdateTextField(text: textView.text, data: data)
        formCellDelegate?.didEndEditing(indexPath: indexPath)
        textView.resignFirstResponder()
    }
}
