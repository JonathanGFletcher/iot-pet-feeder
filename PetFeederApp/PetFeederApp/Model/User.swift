//
//  User.swift
//  PetFeederApp
//
//  Created by Jonathan Fletcher on 4/30/20.
//  Copyright © 2020 Jonathan Fletcher. All rights reserved.
//

import Foundation

struct User: Codable {
    
    var id: String
    var emailAddress: String
    var password: String
    var role: Role?
    var token: String?
    var feeders: [Feeder]?
}
