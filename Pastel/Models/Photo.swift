//
//  Photo.swift
//  Pastel
//
//  Created by Ahmed Zaghloul on 6/28/19.
//  Copyright © 2019 Ahmed Zaghloul. All rights reserved.
//

import UIKit

public struct Photo {
    var isPublic: Bool?
    var isFriend: Bool?
    var isFamily: Bool?
    var id: String?
    var owner: String?
    var secret: String?
    var server: String?
    var title: String?
    var farm: Int?
    
    init(data:AnyObject) {
        if let data = data as? NSDictionary {
            isPublic = (data.getValueForKey(key: "ispublic", callback: 0) == 1)
            isFriend = (data.getValueForKey(key: "isfriend", callback: 0) == 1)
            isFamily = (data.getValueForKey(key: "isfamily", callback: 0) == 1)
            id = data.getValueForKey(key: "id", callback: "0")
            owner = data.getValueForKey(key: "owner", callback: "0")
            secret = data.getValueForKey(key: "secret", callback: "0")
            server = data.getValueForKey(key: "server", callback: "0")
            title = data.getValueForKey(key: "title", callback: "0")
            farm = data.getValueForKey(key: "farm", callback: 0)
            
        }
    }
    
    init(entity: PhotoEntity) {
        self.farm = Int(entity.farm)
        self.secret = entity.secret
        self.server = entity.server
        self.id = entity.id
        self.isPublic = false
        self.isFamily = false
        self.isFriend = false
        self.title = ""
        self.owner = ""
    }
}
