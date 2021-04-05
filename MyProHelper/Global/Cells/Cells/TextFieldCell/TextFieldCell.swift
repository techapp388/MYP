//
//  TextFieldCell.swift
//  MyProHelper
//
//

import UIKit

protocol TextFieldCellDelegate {
    func didUpdateTextField(text: String?, data: TextFieldCellData)
}

protocol TextFieldListDelegate {
    func willAddItem(data: TextFieldCellData)
    func didChooseItem(at row: Int?, data: TextFieldCellData)
}

class TextFieldCell: BaseFormCell {
    
    static let ID = "TextFieldCell"
    
    @IBOutlet weak private var titleLabel               : UILabel!
    @IBOutlet weak private var textField                : UITextField!
    @IBOutlet weak private var requireSign              : UILabel!
    @IBOutlet weak private var errorLabel               : UILabel!
    @IBOutlet weak private var errorHeightConstraint    : NSLayoutConstraint!
    @IBOutlet weak private var listArrowImageView       : UIImageView!
    
    private let datePicker = UIDatePicker()
    private let pickerView = UIPickerView()
    private let errorHeight: CGFloat = 15
    private var isListAddButtonHidden = false
    
    var delegate: TextFieldCellDelegate?
    var listDelegate: TextFieldListDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureTextField()
        setupPickerView()
    }
    
    private func setupPickerView() {
        pickerView.delegate     = self
        pickerView.dataSource   = self
    }
    
    private func configureTextField() {
        textField.delegate = self
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 4
        setValid()
    }
    
    func bindTextField(data: TextFieldCellData) {
        self.data = data
        titleLabel.text = data.title
        if data.type == .Date {
            textField.text = DateManager.formatStandardToLocal(string: data.text ?? "")
        }
        else if data.type == .Time {
            textField.text = DateManager.formatStandardTimeString(string: data.text ?? "")
        }
        else {
            textField.text = data.text
        }
        
        setInputMode(type: data.type)
        setRequire(isRequired: data.isRequired)
        setKeyboardType(type: data.keyboardType)
        disableCell(isDisabled: data.isActive)
        
        if data.type == .ListView ||  data.type == .PickerView{
            listArrowImageView.isHidden = false
        }
        else {
            listArrowImageView.isHidden = true
        }
    }
    
    override func bindData() {
        endEditing(true)
        guard let data = data else { return }
        switch data.type {
        case .Text, .Mobile, .ZipCode, .TimeFrame:
            data.text = textField.text
            delegate?.didUpdateTextField(text: data.text, data: data)
            
        case .Date, .Time:
            handleChooseDate()
            
        case .ListView, .PickerView:
            data.text = textField.text
            listDelegate?.didChooseItem(at: data.listItemIndex, data: data)
        }
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
    
    func setFirstResponder() {
        guard let data = data else { return }
        switch data.type {
        case .Text, .Mobile, .ZipCode:
            textField.becomeFirstResponder()
        default:
            break
        }
        
    }
    
    func hideListAddButton() {
        isListAddButtonHidden = true
    }
    
    private func setRequire(isRequired: Bool) {
        if isRequired {
            requireSign.isHidden = false
        }
        else {
            requireSign.isHidden = true
        }
    }
    
    private func setKeyboardType(type: UIKeyboardType) {
        textField.keyboardType = type
    }
    
    private func disableCell(isDisabled: Bool) {
        textField.isUserInteractionEnabled = isDisabled
    }
    
    private func setValid() {
        errorLabel.isHidden = true
        errorHeightConstraint.constant = 0
        textField.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func setInvalid(message: String) {
        guard showValidation == true else { return }
        errorLabel.isHidden = false
        errorHeightConstraint.constant = errorHeight
        errorLabel.text = message
        textField.layer.borderColor = UIColor.systemRed.cgColor
    }
    
    private func setInputMode(type: DataType) {
        switch type {
        case .Date:
            setDatePick(with: .date)
        case .Time:
            setDatePick(with: .time)
        case .PickerView:
            textField.inputView = pickerView
            textField.tintColor = .clear
        default:
            textField.inputView = nil
            textField.tintColor = nil
            
        }
    }
    
    private func setDatePick(with mode: UIDatePicker.Mode) {
        datePicker.addTarget(self, action: #selector(handleChooseDate), for: .valueChanged)
        datePicker.datePickerMode = mode
        datePicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        textField.inputView = datePicker
        textField.tintColor = .clear
    }
    
    private func showAppList() {
        guard let data = data else { return }
        let appList = AppListView.instantiate(storyboard: .HOME)
        if isListAddButtonHidden {
            appList.hideAddButton()
        }
        appList.bindView(data: data.listData, delegate: self)
        showViewDelegate?.pushView(view: appList)
    }
    
    private func openPickTimeView() {
        guard let data = data else { return }
        let pickTimeView = PickTimeView.instantiate(storyboard: .HOME)
        pickTimeView.timeFrame.bind { [weak self] (time) in
            guard let self = self, let time = time else { return }
            data.text = time
            self.textField.text = time
            self.delegate?.didUpdateTextField(text: time, data: data)
        }
        showViewDelegate?.presentView(view: pickTimeView, completion: { })
    }
    
    @objc private func handleChooseDate() {
        guard let data = data else { return }
        let dateString = DateManager.getStandardDateString(date: datePicker.date)
        data.text = dateString
        if data.type == .Date {
            textField.text = DateManager.dateToString(date: datePicker.date)
        }
        else if data.type == .Time {
            textField.text = DateManager.timeToString(date: datePicker.date)
        }
        delegate?.didUpdateTextField(text: dateString, data: data)
        formCellDelegate?.didEndEditing(indexPath: indexPath)
    }
}

//MARK: - TEXTFIELD DELEGATE METHODS
extension TextFieldCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let data = data else { return false  }
        switch data.type {
        case .Date, .Time:
            handleChooseDate()
            return true
        case .ListView:
            showAppList()
            return false
        case .TimeFrame:
            openPickTimeView()
            return false
        default:
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let data = data else { return  }
        if data.type == .Date || data.type == .Time {
            handleChooseDate()
            return
        }
        data.text = textField.text
        delegate?.didUpdateTextField(text: textField.text, data: data)
        formCellDelegate?.didEndEditing(indexPath: indexPath)
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let data = data else { return false }
        if data.type == .Date || data.type == .Time {
            handleChooseDate()
            return true
        }
        data.text = textField.text
        delegate?.didUpdateTextField(text: textField.text, data: data)
        formCellDelegate?.didEndEditing(indexPath: indexPath)
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text, let stringRange = Range(range, in: currentText) else { return false }
        guard let data = data else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        switch data.type {
        case .Mobile:
            if string != "" {
                formatNumber(textField: textField)
            }
            return updatedText.count <= 12
            
        case .ZipCode:
            if !string.isEmpty {
                formatZipCode(textField: textField)
            }
            return updatedText.count <= 10
        case .Date:
            return false
        default:
            return true
        }
    }
    
    private func formatNumber(textField: UITextField){
        guard let text = textField.text else {
            return
        }
        if text.count == 3 {
            textField.text = text + "-"
        }
        else if text.count == 7 {
            textField.text = text + "-"
        }
    }
    
    private func formatZipCode(textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        if text.count == 5 {
            textField.text?.insert("-", at: .init(utf16Offset: text.count, in: text))
        }
    }
}

//MARK: - CONFORMING TO APP LIST DELEGATE
extension TextFieldCell: AppListDelegate {
    
    func willAddItem() {
        guard let data = data else { return }
        listDelegate?.willAddItem(data: data)
    }
    
    func didSelectItem(row: Int, text: String) {
        guard let data = data else { return }
        data.text = text
        textField.text = text
        listDelegate?.didChooseItem(at: row, data: data)
    }
    
    func willShowLastItem() {
        print("Call pagination")
    }
}

//MARK:- CONFORMING TO PICKER VIEW DELEGATE
extension TextFieldCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let data = data else { return }
        data.text = data.listData[row]
        textField.text = data.listData[row]
        listDelegate?.didChooseItem(at: row, data: data)
    }
}

//MARK:- CONFROMING TO PICKER VIEW DATA SOURCE
extension TextFieldCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let data = data else { return 0 }
        return data.listData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let data = data else { return nil }
        return data.listData[row]
    }
}
