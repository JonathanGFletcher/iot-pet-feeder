//
//  Feeder.swift
//  PetFeederApp
//
//  Created by Jonathan Fletcher on 4/29/20.
//  Copyright © 2020 Jonathan Fletcher. All rights reserved.
//

import Foundation

struct Feeder: Codable {
    
    var id: String
    var feederId: String
    var feedOverride: Int?
    var feedCount: Int?
    var currentTime: Int?
    var numberOfFeedTimes: Int?
    var feedTimes: String?
}
