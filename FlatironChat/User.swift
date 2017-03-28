//
//  User.swift
//  FlatironChat
//
//  Created by Edmund Holderbaum on 3/24/17.
//  Copyright © 2017 Johann Kerr. All rights reserved.
//

import Foundation

final class User{
    
    private static var currentUser = User()
    
    var name: String
    
    private init () {
        self.name = ""
    }
    
    static func setCurrentUserName (as name: String){
        currentUser.name = name
    }
    static func getUserName () -> String{
        return currentUser.name
    }
}

