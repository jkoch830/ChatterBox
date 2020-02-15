//
//  Friends.swift
//  ChatterBox
//
//  Created by Edward on 2/15/20.
//  Copyright © 2020 Edward. All rights reserved.
//

class Friend {
    var name: String
    var emotion: String
    var keywords: [String]
    var url: String
    
    init(_ name: String, _ emotion: String, _ keywords: [String], _ url: String) {
        self.name = name
        self.emotion = emotion
        self.keywords = keywords
        self.url = url
    }
}
