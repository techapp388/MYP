//
//  Storyboarded.swift
//  MyProHelper
//
//

import UIKit

protocol Storyboarded: NSObject {
    
    static func instantiate(storyboard: Constants.Storyboard) -> Self
}

extension Storyboarded where Self: UIViewController {
    
    static func instantiate(storyboard: Constants.Storyboard) -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: .main)
        return storyboard.instantiateViewController(identifier: id) as! Self
    }
}
