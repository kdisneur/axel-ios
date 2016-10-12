//
//  HistoryViewController.swift
//  AxeliOS
//
//  Created by Kevin Disneur on 10/10/16.
//  Copyright © 2016 Kevin Disneur. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var events : [Event] = []
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var eventsView: UITableView!
    
    @IBAction func searchAction() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        events.removeAll()
        RestApiManager.sharedInstance.loadHistory(datePicker.date,
                                                  onCompletion: {json -> Void in
                                                    if let data = json as? [String : Any] {
                                                        if let history = data["history"] as? [Any] {
                                                            for rawModel in history {
                                                                if let model = rawModel as? [String : Any] {
                                                                    if let type = model["type"] as? String {
                                                                        if type == "change" {
                                                                            self.events.append(Event.buildFrom(change: model))
                                                                        } else if type == "feeding" {
                                                                            self.events.append(Event.buildFrom(feeding: model))
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                    self.eventsView.reloadData()
                                                    UIApplication.shared.isNetworkActivityIndicatorVisible = false},
                                                  onError: {message -> Void in
                                                    Messages
                                                        .init(view: self.view)
                                                        .displayErrorMessage(message)
                                                    UIApplication.shared.isNetworkActivityIndicatorVisible = false})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventsView.delegate = self
        eventsView.dataSource = self
        
        searchAction()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return [
            UITableViewRowAction.init(style: UITableViewRowActionStyle.destructive,
                                      title: "Remove",
                                      handler: {action, indexPath -> Void in
                                        UIApplication.shared.isNetworkActivityIndicatorVisible = true
                                        RestApiManager.sharedInstance.remove(self.events[indexPath.row],
                                                                             onCompletion: {json -> Void in
                                                                                if let data = json as? [String : Any] {
                                                                                    if let errors = data["errors"] as? [String : String] {
                                                                                        if let message = errors["global"] {
                                                                                            Messages
                                                                                                .init(view: self.view)
                                                                                                .displayErrorMessage(message)
                                                                                        }
                                                                                    } else {
                                                                                        self.events.remove(at: indexPath.row)
                                                                                        tableView.deleteRows(at: [indexPath], with: .fade)
                                                                                    }
                                                                                }
                                                                                UIApplication.shared.isNetworkActivityIndicatorVisible = false},
                                                                             onError: {message -> Void in
                                                                                Messages
                                                                                    .init(view: self.view)
                                                                                    .displayErrorMessage(message)
                                                                                UIApplication.shared.isNetworkActivityIndicatorVisible = false})})
        ]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->  UITableViewCell {
        let genericCell = tableView.dequeueReusableCell(withIdentifier: "eventIdentifier", for: indexPath)
        let cell = genericCell as! EventTableViewCell
        
        let event = events[indexPath.row]
        
        cell.configure(event)
        
        return cell
    }
}
