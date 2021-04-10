//
//  ApproveView.swift
//  MyProHelper
//
//  Created by Sarvesh on 07/04/21.
//  Copyright © 2021 Benchmark Computing. All rights reserved.
//

import Foundation
import UIKit

class ApproveView: UIViewController,Storyboarded {
    @IBOutlet weak var backgroundViewContainer: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var DiscardButton: UIButton!
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var remarksTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGesture()
        backgroundViewContainer.cornerRadius = 15
        
    }
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismissView))
        backgroundViewContainer.addGestureRecognizer(tapGesture)
    }
    @objc private func handleDismissView() {
        dismiss(animated: true, completion: nil)
        //self.viewModel.fetchMoreData()
    
    }
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        handleDismissView()
    }
    @IBAction func saveAction(_sender :UIButton){
        if (remarksTextField.text == "") {
            print("name")
            // create the alert
                   let alert = UIAlertController(title: "Remarks", message: "Please fill the remarks", preferredStyle: UIAlertController.Style.alert)

                   // add an action (button)
                   alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                   // show the alert
                   self.present(alert, animated: true, completion: nil)
        }else{
            handleDismissView()

        }
    }
}
