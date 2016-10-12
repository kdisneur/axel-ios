//
//  Event.swift
//  AxeliOS
//
//  Created by Kevin Disneur on 10/10/16.
//  Copyright © 2016 Kevin Disneur. All rights reserved.
//

import Foundation

class Event {
    enum EventType {
        case feeding
        case change
    }
    
    var id : Int
    var message : String
    var date : Date?
    var type : EventType
    
    init(_ id: Int, atDate date: Date?, withMessage message : String, forType type: EventType) {
        self.id = id
        self.date = date
        self.message = message
        self.type = type
    }
    
    static func buildFrom(feeding: [String : Any]) -> Event {
        return Event.init(fieldToID(feeding["id"]),
                          atDate: fieldToDate(feeding["fed_at"]),
                          withMessage: buildMessage(feeding: feeding["quantity"]),
                          forType: .feeding)
    }
    
    static func buildFrom(change: [String : Any]) -> Event {
        return Event.init(fieldToID(change["id"]),
                          atDate: fieldToDate(change["changed_at"]),
                          withMessage: buildMessage(change: change["poop"], withPee: change["pee"]),
                          forType: .change)
    }
    
    private static func buildMessage(feeding rawQuantity: Any) -> String {
        if let quantity = rawQuantity as? Int {
            return "A baby bottle of \(quantity) ml has been drunk"
        } else {
            return "A baby bottle has been drunk"
        }
    }
    
    private static func buildMessage(change rawPoop: Any, withPee rawPee: Any) -> String {
        if let poop = rawPoop as? Bool , let pee = rawPee as? Bool {
            if poop && pee {
                return "A diaper full of poop and pee has been changed"
            } else if poop {
                return "A diaper full of poop has been changed"
            } else if pee {
                return "A diaper full of pee has been changed"
            } else {
                return "An empty diaper has been changed"
            }
        } else {
            return "A diaper has been changed"
        }
    }
    
    private static func fieldToDate(_ field : Any) -> Date? {
        if let rawDate = field as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            return dateFormatter.date(from: rawDate)
        } else {
            return nil
        }
    }
    
    private static func fieldToID(_ id: Any) -> Int {
        return id as! Int
    }
}
