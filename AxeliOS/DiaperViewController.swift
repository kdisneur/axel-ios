//
//  DiaperViewController.swift
//  AxeliOS
//
//  Created by Kevin Disneur on 09/10/16.
//  Copyright © 2016 Kevin Disneur. All rights reserved.
//

import UIKit

class DiaperViewController: UIViewController {
    @IBOutlet weak var datetimePicker: UIDatePicker!
    @IBOutlet weak var poopField: UISwitch!
    @IBOutlet weak var peeField: UISwitch!
    
    @IBAction func saveAction(_ sender: AnyObject) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        RestApiManager.sharedInstance.addDiaper(datetimePicker.date,
                                                withPoop: poopField.isOn,
                                                AndPee: peeField.isOn,
                                                onCompletion: {_ -> Void in
                                                    self.poopField.isOn = false
                                                    self.peeField.isOn = false
                                                    self.datetimePicker.date = Date.init()
                                                    Messages
                                                        .init(view: self.view)
                                                        .displaySuccessMessage("Successfully saved!")
                                                    UIApplication.shared.isNetworkActivityIndicatorVisible = false},
                                                onError: {message -> Void in
                                                    Messages
                                                        .init(view: self.view)
                                                        .displayErrorMessage(message)
                                                    UIApplication.shared.isNetworkActivityIndicatorVisible = false})
    }
}
