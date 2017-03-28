//
//  Channel.swift
//  FlatironChat
//
//  Created by Johann Kerr on 3/24/17.
//  Copyright © 2017 Johann Kerr. All rights reserved.
//

import Foundation

struct Channel {
    var name: String
    var lastMsg: String
    var numberOfParticipants: Int
}

extension Channel{
    
    static func unwrapFireData(from dict:[String:Any], name: String)-> Channel? {
        let lastMessage: String
        let numberOfParticipants: Int
        lastMessage = dict["lastMessage"] as? String ?? ""
        print(dict["lastMesssage"])
        if let participants = dict["participants"] as? [String:Any]{
            numberOfParticipants = participants.count
        }else{numberOfParticipants = 0}
        return Channel(name: name, lastMsg: lastMessage, numberOfParticipants: numberOfParticipants)
    }
}
