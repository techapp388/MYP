//
//  ShowViewDelegate.swift
//  MyProHelper
//
//

import UIKit

@objc protocol ShowViewDelegate {
    func presentView(view: UIViewController,completion: @escaping ()->())
    @objc optional func showAlert(alert: UIAlertController,sourceView: UIView)
    func pushView(view: UIViewController)
}
