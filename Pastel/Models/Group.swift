//
//  Group.swift
//  Pastel
//
//  Created by Ahmed Zaghloul on 6/28/19.
//  Copyright © 2019 Ahmed Zaghloul. All rights reserved.
//

import Foundation

public struct Group {
    var isEighteenPlus: Bool?
    var iconserver: String?
    var members: String?
    var pool_count: String?
    var name: String?
    var nsid: String?
    var topic_count: String?
    var privacy: String?
    var iconfarm: Int?
    var membersKeyword: String = "Member"
    
    init(data:AnyObject) {
        if let data = data as? NSDictionary {
            isEighteenPlus = (data.getValueForKey(key: "eighteenplus", callback: 0) == 1)
            iconserver = data.getValueForKey(key: "iconserver", callback: "0")
            members = data.getValueForKey(key: "members", callback: "0")
            pool_count = data.getValueForKey(key: "pool_count", callback: "0")
            topic_count = data.getValueForKey(key: "topic_count", callback: "0")
            privacy = data.getValueForKey(key: "privacy", callback: "0")
            iconfarm = data.getValueForKey(key: "iconfarm", callback: 0)
            
            name = data.getValueForKey(key: "name", callback: "UNKNOWN")
            nsid = data.getValueForKey(key: "nsid", callback: "")
            
            if let membersCount = Int(members!) {
                membersKeyword = membersCount <= 1 ? "Member" : "Members"
            }
            
        }
    }
    
    init(entity: GroupEntity) {
        self.iconfarm = Int(entity.iconfarm)
        self.iconserver = entity.iconserver
        self.isEighteenPlus = entity.isEighteenPlus
        self.members = entity.members
        self.name = entity.name
        self.nsid = entity.nsid
        self.privacy = ""
        self.pool_count = ""
        self.topic_count = ""
    }

}
