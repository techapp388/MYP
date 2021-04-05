//
//  GlobalMethods.swift
//  MyProHelper
//
//

import UIKit

struct GlobalFunction {
    
    static func showListActionSheet(deleteTitle: String? = nil ,customActions: [UIAlertAction] = [], showHandler: @escaping (UIAlertAction)->(), editHandler: @escaping (UIAlertAction)->(), deleteHandler: @escaping (UIAlertAction)->()) -> UIAlertController{
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let showAction = UIAlertAction(title: "SHOW".localize,
                                       style: .default,
                                       handler: showHandler)
        let editAction = UIAlertAction(title: "EDIT".localize,
                                       style: .default,
                                       handler: editHandler)
        let deleteAction = UIAlertAction(title: deleteTitle ?? "DELETE".localize,
                                         style: .destructive, handler: deleteHandler)
        let closeAction = UIAlertAction(title: "CLOSE".localize,
                                        style: .cancel, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        })
        
        for action in customActions {
            alert.addAction(action)
        }
        
        alert.addAction(showAction)
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(closeAction)
        return alert
    }
    
    static func showListASheet(deleteTitle: String? = nil ,customActions: [UIAlertAction] = [], showHandler: @escaping (UIAlertAction)->(), editHandler: @escaping (UIAlertAction)->(), deleteHandler: @escaping (UIAlertAction)->()) -> UIAlertController{
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let showAction = UIAlertAction(title: "SHOW",
                                       style: .default,
                                       handler: showHandler)
        let editAction = UIAlertAction(title: "EDIT".localize,
                                       style: .default,
                                       handler: editHandler)
        let deleteAction = UIAlertAction(title: deleteTitle ?? "DELETE".localize,
                                         style: .destructive, handler: deleteHandler)
        let closeAction = UIAlertAction(title: "CLOSE".localize,
                                        style: .cancel, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        })
        
        for action in customActions {
            alert.addAction(action)
        }
        
        alert.addAction(showAction)
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(closeAction)
        return alert
    }
    
    static func showDeleteAlert(title: String, message: String, deleteAction: @escaping () -> ()) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "DELETE".localize, style: .destructive) { (_) in
            deleteAction()
        }
        let cancelAction = UIAlertAction(title: "CLOSE".localize, style: .cancel) { (_) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        return alert
    }
    
    static func showMessageAlert(fromView: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localize, style: .default) { (_) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        fromView.present(alert, animated: true, completion: nil)
    }
    
    static func getAppVersion() -> String? {
        let object: AnyObject = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as AnyObject
        guard let version = object as? String else {
            return nil
        }
        return version
    }
}
