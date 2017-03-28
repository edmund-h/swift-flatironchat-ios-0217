//
//  FirebaseClient.swift
//  FlatironChat
//
//  Created by Edmund Holderbaum on 3/24/17.
//  Copyright © 2017 Johann Kerr. All rights reserved.
//

import Foundation
import Firebase

final class FirebaseClient{
    
    static let database = FIRDatabase.database().reference()
    
    static func tryLogin(name: String, success: @escaping (Bool, String)->() ){
        var alreadyLoggedIn: Bool = false
        
        database.child("users").child(name).child("isLoggedIn").observeSingleEvent(of: .value, with: { callback in
            alreadyLoggedIn = callback.value as? Bool ?? false
            if alreadyLoggedIn == false {
                success(true, "")
                database.child("users").child(name).child("isLoggedIn").setValue(true)
            }
            else { success(false, "A user is already logged in under that name.")  }
        })
    }
    
    static func getChannels(then observer: @escaping ([Channel])->()){
        database.child("channels").observe(.value , with: { snapshot in
            var allChannels = [Channel]()
            if let channelsDict = snapshot.value as? [String: Any]{
                channelsDict.keys.forEach({
                    channelName in
                    guard let channelDict = channelsDict[channelName] as? [String:Any],
                        let thisChannel = Channel.unwrapFireData(from: channelDict, name: channelName)
                        else { print ("Channel unwrap err"); return }
                    allChannels.append(thisChannel)
                })
                observer(allChannels)
            }
        })
    }
    
    static func addChannel(name: String, then completion: @escaping ()->()){
        //load dictionary with default info
        let newChannelInfo:[String:Any] = ["lastMessage":"",
                                           "participants":[User.getUserName():true],
                                           "numberOfMessages": 0]
        database.child("channels").child(name).setValue(newChannelInfo)
        database.child("users").child(User.getUserName()).child("channels").child(name).setValue(true)
        DispatchQueue.main.async {completion()}
    }
    
    static func logoutUser(){
        database.child("users").child(User.getUserName()).child("isLoggedIn").setValue(false)
    }
    
    static func joinChannel(name: String){
        //first append the user to channel's participants
        database.child("channels").child(name).child("participants").child(User.getUserName()).setValue(true)
        //then append the channel to user's channels
        database.child("users").child(User.getUserName()).child("channels").child(name).setValue(true)
    }
    
    static func getMessages(from channel: String, then observer: @escaping ([String:Any])->()){
        database.child("messages").child(channel).observe(.value, with: { snapshot in
            if let msgsDict = snapshot.value as? [String:Any]{
                DispatchQueue.main.async { observer(msgsDict) }
            }
        })
    }
    
    static func sendMessage(with text: String, to channel:String, then completion: @escaping ()->()){
        database.child("channels").child(channel).child("numberOfMessages").observeSingleEvent(of: .value, with: { snapshot in
            var numMsgs = snapshot.value as? Int ?? 0
            database.child("messages").child(channel).childByAutoId().setValue(["content":text, "from":User.getUserName(),"ID": numMsgs])
            database.child("channels").child(channel).child("numberOfMessages").setValue(numMsgs + 1)
            database.child("channels").child(channel).child("lastMessage").setValue(text)
            DispatchQueue.main.async { completion() }
            database.child("users").child(User.getUserName()).child("msgsSent").observeSingleEvent(of: .value, with: { snapshot in
                let msgsSent = snapshot.value as? Int ?? -1987
                database.child("users").child(User.getUserName()).child("msgsSent").setValue(msgsSent + 1)
            })
            
        })
        
    }
}
