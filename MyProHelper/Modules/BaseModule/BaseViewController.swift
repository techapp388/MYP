//
//  BaseViewController.swift
//  MyProHelper
//
//

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let backImage = UIImage(named: "back")

        navigationController?.isNavigationBarHidden                         = false
        navigationController?.interactivePopGestureRecognizer?.delegate     = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled    = true
        
        let backButton = UIBarButtonItem(image: backImage,
                                         style: .plain,
                                         target: self,
                                         action: #selector(handleDismissView))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func handleDismissView() {
        navigationController?.popViewController(animated: true)
    }
    
    func presentAlert(alert: UIAlertController, sourceView: UIView) {
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = sourceView
            popoverPresentationController.sourceRect = sourceView.bounds
            popoverPresentationController.permittedArrowDirections = [.any]
        }
        present(alert, animated: true, completion: nil)
    }
}
