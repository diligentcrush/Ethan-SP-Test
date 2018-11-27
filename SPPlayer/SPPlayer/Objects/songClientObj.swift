//
//  songClientObj.swift
//  SPPlayer
//
//  Created by Ethan Chen on 11/20/18.
//  Copyright © 2018 Estamp. All rights reserved.
//

import Foundation
class songClientObj {
    var groupID: String
    var kind: String
    var id: String
    var msg: String
    var timestamp: Int64

    var stringfy : String{
        return "\(groupID):\(kind):\(id):\(msg):\(timestamp)"
    }
    init(groupID: String, kind: String, id: String, msg: String, timestamp: Int64) {
        self.groupID = groupID
        self.kind = kind
        self.id = id
        self.msg = msg
        self.timestamp = timestamp
    }
    
}
