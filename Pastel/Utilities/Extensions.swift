//
//  Extensions.swift
//  Pastel
//
//  Created by Ahmed Zaghloul on 6/28/19.
//  Copyright © 2019 Ahmed Zaghloul. All rights reserved.
//

import UIKit
import os

extension UIViewController{
    func alertWith(title:String?,message:String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
extension URLRequest{
    mutating func setBodyConfigrationWithMethod(method:String){
        self.httpMethod = method
        self.setValue("application/json",forHTTPHeaderField:"Accept")
    }
}

extension NSDictionary {
    func getValueForKey<T>(key:String,callback:T)  -> T{
        if let value  = self[key]  {
            if let value = value as? T {
                return value
            }
            return callback
        }
        return callback
        
    }
    
}

let userData = UserDefaults.standard

let STRONG_VIBRATE_SOUND_ID:UInt32 = 1520
let SUCCESS_VIBRATE_SOUND_ID:UInt32 = 1519
let FAILED_VIBRATE_SOUND_ID:UInt32 = 1521

let API_KEY = "e3530a1aad1a23bdbdd496fc7d49640e"
let BASE_URL = "https://www.flickr.com/services/rest/"
struct MethodKeys {
    static var groups = "?method=flickr.groups.search"
    static var photos = "?method=flickr.photos.search"
}

let groupBaseURL = "http://farm{icon-farm}.staticflickr.com/{icon-server}/buddyicons/{nsid}_r.jpg"
let photoBaseURL = "https://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_\(FlickrImagesQuality.thumbnail).jpg"

struct FlickrImagesQuality {
    static var smallSquare = "s" // 75x75
    static var largeSquare = "q" // 150x15
    static var thumbnail = "t" // 100 on longest side
    static var small = "n" // 320 on longest sidestatic var
    static var medium = "z" // 640 on longest side
    static var large = "k" // 2048 on longest sidstatic var
    static var original = "o" // Original size
}
