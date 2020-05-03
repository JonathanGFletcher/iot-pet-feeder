//
//  TimeFunctions.swift
//  PetFeederApp
//
//  Created by Jonathan Fletcher on 5/2/20.
//  Copyright © 2020 Jonathan Fletcher. All rights reserved.
//

import Foundation

//MARK: Get Time String
func getTimeString(date: Date) -> String {
    
    let calendar = Calendar.current
    
    let hour = calendar.component(.hour, from: date)
    let minutes = calendar.component(.minute, from: date)
    
    let time = "\(hour):\(minutes)"
    
    return time
}

//MARK: NEEDS WORK
func getNextTimeIndex(dates: [Date]) -> Int {
    
    var currentInterval: DateInterval?
    var currentIndex = 0
    
    for (index, date) in dates.enumerated() {
        
        let now = Date()
        
        if now <= date {
            
            let interval = DateInterval(start: now, end: date)
            
            if let currentIntervalSafe = currentInterval {
                
                if interval < currentIntervalSafe {
                    
                    currentInterval = interval
                    currentIndex = index
                }
            }
            else {
                
                currentInterval = interval
            }
        }
    }
    
    return currentIndex
}
