//
//  Scrollable.swift
//  Pineapple
//
//  Created by Jon on 8/1/16.
//  Copyright © 2016 Pineapple. Inc. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol Scrollable {
    func setupScrollview()
    var scrollView: UIScrollView { get }
    var contentView: UIView { get }
}

extension Scrollable where Self: UIViewController {
    func setupScrollview() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        contentView.snp_makeConstraints { (make) in
            make.edges.equalTo(scrollView)
            make.width.equalTo(view)
        }
        
        setupNotificationHandlers()
    }
    
    func setupNotificationHandlers() {
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: nil, usingBlock: { (notification) in
            
            self.keyboardWillShow(notification)
        })
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillHideNotification, object: nil, queue: nil, usingBlock: { (notification) in
            
            self.keyboardWillHide(notification)
        })
    }
    
    func keyboardWillShow(notification: NSNotification) {
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        keyboardFrame = self.view.convertRect(keyboardFrame, fromView: nil)
        
        var contentInset:UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    func keyboardWillHide(notification: NSNotification) {
        var contentInset:UIEdgeInsets = scrollView.contentInset
        contentInset.bottom = 0
        scrollView.contentInset = contentInset
    }
}