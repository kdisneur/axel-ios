//
//  Messages.swift
//  AxeliOS
//
//  Created by Kevin Disneur on 09/10/16.
//  Copyright © 2016 Kevin Disneur. All rights reserved.
//

import Foundation
import UIKit

class Messages {
    
    var view : UIView
    
    init(view: UIView) {
        self.view = view
    }
    
    func displayErrorMessage(_ message: String) {
        let errorColor = UIColor(red: (229.0 / 255.0), green: (108.0 / 255.0), blue: (103.0 / 255), alpha: 1)
        displayMessage(message, withBackground: errorColor)
    }
    
    func displaySuccessMessage(_ message: String) {
        let successColor = UIColor(red: (40.0 / 255.0), green: (126.0 / 255.0), blue: (92.0 / 255), alpha: 1)
        displayMessage(message, withBackground: successColor)
    }
    
    func displayMessage(_ message: String, withBackground background: UIColor) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        
        let finalSize = CGSize(width: self.view.frame.width, height: 64)
        let startingSize = CGSize(width: self.view.frame.width, height: 0)
        let origin = UIApplication.shared.keyWindow!.frame.origin
        
        let rect = CGRect(origin: origin, size: startingSize)
        
        let messageView = UIView(frame: rect)
        messageView.backgroundColor = background
        
        let messageLabel = UILabel(frame: messageView.bounds)
        messageLabel.text = message
        messageLabel.textColor = UIColor.white
        messageLabel.baselineAdjustment = UIBaselineAdjustment.alignCenters
        messageLabel.textAlignment = NSTextAlignment.center
        
        messageView.addSubview(messageLabel)
        UIApplication.shared.keyWindow?.addSubview(messageView)
        
        messageView.frame.size = finalSize
        messageLabel.frame = messageView.bounds
        
        UIView.commitAnimations()
        
        
        let deadlineTime = DispatchTime.now() + .seconds(3)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.5)
            
            messageView.frame.size = CGSize(width: self.view.frame.width, height: 0)
            messageLabel.frame = messageView.bounds
            
            UIView.commitAnimations()
            
            let deadlineTime = DispatchTime.now() + .seconds(1)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                messageView.removeFromSuperview()
            }
        }
    }
}
