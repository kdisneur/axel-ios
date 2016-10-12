//
//  BabyBottleViewController.swift
//  AxeliOS
//
//  Created by Kevin Disneur on 08/10/16.
//  Copyright © 2016 Kevin Disneur. All rights reserved.
//

import UIKit

class BabyBottleViewController: UIViewController {
    
    var KEYBOARD_HEIGHT : CGFloat = 80
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var quantityField: UITextField!
    
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func submitAction(_ sender: AnyObject) {
        if quantity() != nil && quantity()! > 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            RestApiManager.sharedInstance.addBabyBottle(quantity()!,
                                                        at: datePicker.date,
                                                        onCompletion: {_ -> Void in
                                                            self.quantityField.text = ""
                                                            self.datePicker.date = Date.init()
                                                            Messages
                                                                .init(view: self.view)
                                                                .displaySuccessMessage("Successfully saved!")
                                                            UIApplication.shared.isNetworkActivityIndicatorVisible = false},
                                                        onError: {message -> Void in
                                                            Messages
                                                                .init(view: self.view)
                                                                .displayErrorMessage(message)
                                                            UIApplication.shared.isNetworkActivityIndicatorVisible = false})
            
        } else {
            Messages
                .init(view: self.view)
                .displayErrorMessage("Please, check your quantity value")
        }
    }
    
    func quantity() -> Int? {
        if quantityField.text != nil {
            return Int.init(quantityField.text!)
        } else {
            return nil
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.UIKeyboardWillShow,
            object: nil,
            queue: nil,
            using: keyboardShown)
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.UIKeyboardWillHide,
            object: nil,
            queue: nil,
            using: keyboardHidden)
    }
    
    func keyboardShown(notification: Notification) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        self.view.frame.origin.y -= KEYBOARD_HEIGHT
        self.view.frame.size.height += KEYBOARD_HEIGHT
        UIView.commitAnimations()
    }
    
    func keyboardHidden(notification: Notification) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        self.view.frame.origin.y += KEYBOARD_HEIGHT
        self.view.frame.size.height -= KEYBOARD_HEIGHT
        UIView.commitAnimations()
    }
}
