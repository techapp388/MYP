//
//  DynamicValue.swift
//  MyProHelper
//
//  Created by Benchmark Computing on 29/07/20.
//  Copyright © 2020 Benchmark Computing. All rights reserved.
//

import Foundation
import UIKit

class DynamicValue<T> {
    
    typealias CompletionHandler = ((T) -> Void)
    
    var value:T {
        didSet {
            self.notify()
        }
    }
    
    private var observers = [String:CompletionHandler]()
    
    init(_ value:T) {
        self.value = value
    }
    
    public func addObserver(_ observer:NSObject,completionHandler:@escaping(CompletionHandler)) {
        observers[observer.description] = completionHandler
    }
    
    public func addAndNotify(observer:NSObject,completionHandler:@escaping(CompletionHandler)) {
        self.addObserver(observer, completionHandler: completionHandler)
        self.notify()
    }
    
    private func notify() {
        observers.forEach({$0.value(value)})
    }
    
    deinit {
        observers.removeAll()
    }
}

