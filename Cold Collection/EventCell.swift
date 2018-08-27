//
//  EventCell.swift
//  Cold Collection
//
//  Created by Carter Brown on 8/7/18.
//  Copyright © 2018 Carter Brown. All rights reserved.
//

import UIKit
import EventKit

class EventCell: UITableViewCell {
    let formatter = DateFormatter()
    var eventIndex = 0
    var buttonDate = ""
    
    @IBOutlet weak var myTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // Set the index of the event
    func setEventIndex(index: Int) {
        eventIndex = index
    }
    
    // Set the date to the date of the event of this cell
    func setDate(date: String) {
        buttonDate = date
    }
    
    // Add to Calendar Button Pressed
    @IBAction func addEventTapped(_ sender: Any) {
        formatter.dateFormat = "yyyy MM dd HH:mm:ss"

        // Variables to configure event
        let eventLength: TimeInterval = TimeInterval(EVENT_MAP.events[buttonDate]![eventIndex].eventLength)
        let dateString = buttonDate + " " + EVENT_MAP.events[buttonDate]![eventIndex].eventTime
        let startDate = formatter.date(from: dateString)
        let endDate = startDate?.addingTimeInterval(eventLength)
        let eventTitle = EVENT_MAP.events[buttonDate]![eventIndex].title
        let eventNote = EVENT_MAP.events[buttonDate]![eventIndex].artistName + " " + EVENT_MAP.events[buttonDate]![eventIndex].eventType
        
        let eventStore: EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            if (granted) && (error == nil) {
                print("granted \(granted)")
                print("error \(error)")
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                
                // Configure event
                event.title = eventTitle
                event.startDate = startDate
                event.endDate = endDate
                event.notes = eventNote
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                // Set an alarm for 24 hours before event
                let alarm:EKAlarm = EKAlarm(relativeOffset: -86400)
                event.alarms = [alarm]
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("error : \(error)")
                }
                print("Save Event")
                
            } else {
                print("error: \(error)")
            }
            
        }
        
    }
    
}
