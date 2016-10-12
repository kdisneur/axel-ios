//
//  EventTableViewCell.swift
//  AxeliOS
//
//  Created by Kevin Disneur on 10/10/16.
//  Copyright © 2016 Kevin Disneur. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func configure(_ event: Event) {
        hourLabel.text = getFormattedHour(event.date)
        minLabel.text = getFormattedMinute(event.date)
        descriptionLabel.text = event.message
    }
    
    private func getFormattedHour(_ date: Date?) -> String {
        if date != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH"
            
            return dateFormatter.string(from: date!) + "H"
        } else {
            return "??H"
        }
    }
    
    private func getFormattedMinute(_ date: Date?) -> String {
        if date != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "mm"
            
            return dateFormatter.string(from: date!)
        } else {
            return "??"
        }
    }
}
