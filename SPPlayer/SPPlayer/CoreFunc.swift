//
//  CoreFunc.swift
//  SPPlayer
//
//  Created by Ethan Chen on 11/20/18.
//  Copyright © 2018 Estamp. All rights reserved.
//

import Foundation

struct CoreFunc {
    
    //sample id: 
    static func saveIDToGroup(_ groupName: String, _ songIdAndKind: [String], _ msg: String){
        print("Yo1")
        if let userDefaults = UserDefaults(suiteName: "group.com.SPPlayer1") {
            print("Yo2")
            if var list = userDefaults.dictionary(forKey: "groups") {
                print("Yo3")
                if let kind = songIdAndKind.first, let id = songIdAndKind.last{
                    print("Yo4")
                    //init song object
                    let songObj = songClientObj.init(groupID: groupName, kind: kind, id: id, msg: msg, timestamp: Int64(Date().timeIntervalSince1970))
                    // retrieve groupValue
                    if var groupSongList = list[groupName, default: []] as? [String] {
                        //update array
                        groupSongList.insert(songObj.stringfy, at: 0)
                        //set record
                        list[groupName] = groupSongList
                        userDefaults.set(list, forKey: "groups")
                        //sync
                        userDefaults.synchronize()
                    }
                }
            }
            else{
                if let kind = songIdAndKind.first, let id = songIdAndKind.last {
                    print("Yo4")
                    //init song object
                    let songObj = songClientObj.init(groupID: groupName, kind: kind, id: id, msg: msg, timestamp: Int64(Date().timeIntervalSince1970))
                    var arr : [String] = []
                    arr.append(songObj.stringfy)
                    //set record
                    var dict : [String : [String]] = [:]
                    dict[groupName] = arr
                    userDefaults.set(dict, forKey: "groups")
                    //sync
                    userDefaults.synchronize()
                }
            }
        }
    }
    static func retriveIdFromUrl(_ url : String)->[String]{
        var result : [String] = []
        if let lastPart = url.components(separatedBy: "https://open.spotify.com/").last {
            if let id = lastPart.components(separatedBy: "?").first {
                result = id.components(separatedBy: "/")
            }
        }
        return result
    }
    static func retrieveDict()->[String : [String]] {
        if let userDefaults = UserDefaults(suiteName: "group.com.SPPlayer1") {
            if let list = userDefaults.dictionary(forKey: "groups") as? [String : [String]]{
                return list
            }
        }
        return [:]
    }
    
}
