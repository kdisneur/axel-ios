//
//  HomeViewController.swift
//  AxeliOS
//
//  Created by Kevin Disneur on 09/10/16.
//  Copyright © 2016 Kevin Disneur. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var poopStat: UILabel!
    @IBOutlet weak var peeStat: UILabel!
    @IBOutlet weak var babyBottleStat: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.UIApplicationWillEnterForeground,
            object: nil,
            queue: nil,
            using: applicationWillEnterForeground)
        
        loadDailyStats()
    }
    
    func applicationWillEnterForeground(notification: Notification) {
        loadDailyStats()
    }
    
    func loadDailyStats() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        self.babyBottleStat.text = "??ml"
        self.poopStat.text = "??"
        self.peeStat.text = "??"
    
        RestApiManager.sharedInstance.loadDailyStats(Date(),
                                                     onCompletion: {json -> Void in
                                                        if let data = json as? [String : Any] {
                                                            if let babyBottleNode = data["baby_bottle"] as? [String : Any] {
                                                                if let babyBottleQuantity = babyBottleNode["quantity"] as? Int {
                                                                    self.babyBottleStat.text = "\(babyBottleQuantity)ml"
                                                                }
                                                            }
                                                            
                                                            if let poopNode = data["poop"] as? [String : Any] {
                                                                if let poopQuantity = poopNode["quantity"] as? Int {
                                                                    self.poopStat.text = "\(poopQuantity)"
                                                                }
                                                            }
                                                            
                                                            if let peeNode = data["pee"] as? [String : Any] {
                                                                if let peeQuantity = peeNode["quantity"] as? Int {
                                                                    self.peeStat.text = "\(peeQuantity)"
                                                                }
                                                            }
                                                        }
                                                        UIApplication.shared.isNetworkActivityIndicatorVisible = false},
                                                     onError: {message -> Void in
                                                        UIApplication.shared.isNetworkActivityIndicatorVisible = false})
    }
}
