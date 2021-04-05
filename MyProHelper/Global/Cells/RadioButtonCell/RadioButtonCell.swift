//
//  RadioButtonCell.swift
//  MyProHelper
//
//  Created by Samir on 12/30/20.
//  Copyright © 2020 Benchmark Computing. All rights reserved.
//


import UIKit

protocol RadioButtonCellDelegate: NSObject {
    func didChooseButton(data: RadioButtonData)
}

class RadioButtonCell: BaseFormCell {

    static let ID = String(describing: RadioButtonCell.self)
    
    @IBOutlet weak private var titleLabel   : UILabel!
    @IBOutlet weak private var stackView    : UIStackView!
    
    private var isDataSet = false
    weak var delegate: RadioButtonCellDelegate?
    var isSelectionEnabled: Bool = false {
        didSet {
            stackView.isUserInteractionEnabled = isSelectionEnabled
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func addRadioButton(data: RadioButtonData) {
        let radioButton = RadioButton(frame: .zero)
        NSLayoutConstraint.activate([
            radioButton.heightAnchor.constraint(equalToConstant: 50),
            radioButton.widthAnchor.constraint(equalToConstant: data.title.width(withConstrainedHeight: 50) + 100)
        ])
        
        radioButton.didSelectButton =  { [weak self] in
            guard let self = self else { return }
            self.resetRedioButtons()
            radioButton.setRadioValue(isSelected: true)
            self.delegate?.didChooseButton(data: data)
        }
        radioButton.initializeRadioButton(data: data)
        stackView.addArrangedSubview(radioButton)
    }
    
    private func resetRedioButtons() {
        stackView.subviews.forEach { (view) in
            if let radioButton = view as? RadioButton {
                radioButton.resetButtonData()
            }
        }
    }
    
    func bindCell(data: [RadioButtonData]) {
        guard !isDataSet else { return }
        
        data.forEach { [weak self] (radioButtonData) in
            guard let self = self else { return }
            self.addRadioButton(data: radioButtonData)
        }
        isDataSet = true
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
}
