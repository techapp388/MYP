//
//  PickTimeView.swift
//  MyProHelper
//
//
//  Created by Samir on 12/24/20.
//  Copyright © 2020 Benchmark Computing. All rights reserved.
//

import UIKit

class PickTimeView: UIViewController, Storyboarded {

    @IBOutlet weak private var viewTitleLabel           : UILabel!
    @IBOutlet weak private var timeFrameTitleLabel      : UILabel!
    @IBOutlet weak private var timeFrameTextField       : UITextField!
    @IBOutlet weak private var scheduleButton           : UIButton!
    @IBOutlet weak private var closeButton              : UIButton!
    @IBOutlet weak private var backgroundViewContainer  : UIView!
    
    private let datePicker = UIDatePicker()
    
    var timeFrame: Box<String?> = Box(nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGesture()
        setupViewText()
        setupTextField()
        setupDatePicker()
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismissView))
        backgroundViewContainer.addGestureRecognizer(tapGesture)
    }

    private func setupViewText() {
        viewTitleLabel.text         = "PICK_TIME_SCREEN_TITLE".localize
        timeFrameTitleLabel.text    = "PICK_TIME_TEXT_FIELD_TITLE".localize
        
        scheduleButton.setTitle("PICK_TIME_SCHEDULE_BUTTON".localize, for: .normal)
        closeButton.setTitle("PICK_TIME_CLOSE_BUTTON".localize, for: .normal)
    }
    
    private func setupTextField() {
        timeFrameTextField.delegate     = self
        timeFrameTextField.tintColor    = .clear
        timeFrameTextField.inputView    = datePicker
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode           = .countDownTimer
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minuteInterval           = 30
        datePicker.addTarget(self, action: #selector(handleChangeDate), for: .valueChanged)
    }
    
    @objc private func handleChangeDate() {
        timeFrameTextField.text = DateManager.timeFrameToString(date: datePicker.date)
    }
    
    @objc private func handleDismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func scheduleButtonPressed(sender: UIButton) {
        dismiss(animated: false, completion: { [weak self] in
            guard let self = self else { return }
            self.timeFrame.value = DateManager.timeFrameToString(date: self.datePicker.date)
        })
    }
    
    @IBAction private func closeButtonPressed(sender: UIButton) {
        handleDismissView()
    }
}

extension PickTimeView: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        handleChangeDate()
        return true
    }
}
