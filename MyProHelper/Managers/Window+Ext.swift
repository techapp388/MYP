//
//  Window+Ext.swift
//
//
//
//  Created by Jaykesh on 16/07/20.
//  Copyright © 2020 Jaykesh Uttam. All rights reserved.
//

import UIKit

struct MyProHelperApp {
    
    
    /// keyWindow
    // 'keyWindow' was deprecated in iOS 13.0: Should not be used for applications that support multiple scenes as it returns a key window across all connected scenes

    public static var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first ?? nil
    }
}
