//
//  Stats.swift
//  AddictionQuitter
//
//  Created by nithish-17632 on 09/12/23.
//

import Foundation

struct Streak: Codable {
    let id:Int
    let timeDate:Date
    let reason:String
    let category:String
    
    init(id:Int, timeDate: Date, reason: String, category: String) {
        self.id = id
        self.timeDate = timeDate
        self.reason = reason
        self.category = category
    }
}
