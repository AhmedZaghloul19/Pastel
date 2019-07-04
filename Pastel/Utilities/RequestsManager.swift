//
//  RequestsManager.swift
//  Pastel
//
//  Created by Ahmed Zaghloul on 6/28/19.
//  Copyright © 2019 Ahmed Zaghloul. All rights reserved.
//

import Foundation
import Alamofire
import os

class RequestsManager: NSObject {

    /**
     **Fetching Groups From the API**.
     ````
     URLSession Method
     ````
     - Parameter keyword: the search keyword
     - Parameter page: the page number (used for the pagination when scroll to the last item)
     - Parameter groups: array of returned groups
     - Parameter maxPages: the maximum number of pages for specific keyword results (used for the pagination when scroll to the last item)
     - Parameter error: error object if an error occured
     */
    public static func fetchGroups(with keyword :String, page: Int, completion: @escaping (_ groups: [Group]?,_ maxPages: Int?,_ error: Error?) -> ()) {
        os_log("RequestsManager.fetchGroups(with keyword :String, page: Int, completion: @escaping ([Group]?, Int?, Error?) -> ())" , type: .debug)
        let baseURL = "\(BASE_URL)/\(MethodKeys.groups)"
        let apiString = "&api_key=\(API_KEY)&page=\(page)"
        let searchString = "&text=\(keyword.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")&format=json&nojsoncallback=1"
        
        guard let url = URL(string: baseURL + apiString + searchString) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let error = err {
                os_log("Server Error", log: OSLog.default, type: .error, error.localizedDescription)
                DispatchQueue.main.async {
                    completion([],1,error)
                    return
                }
            }

            // check response
            guard let data = data else { return }
            do {
                let json: NSDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary
                let groups: [Group]!
                var maxPages = 1
                if let groupsDic = json["groups"] as? NSDictionary {
                    maxPages = groupsDic.getValueForKey(key: "pages", callback: 1)
                    if let arr = groupsDic["group"] as? [NSDictionary] {
                        groups = arr.map({ (object) -> Group in
                            return Group(data: object as AnyObject)
                        })
                        
                        DispatchQueue.main.async {
                            completion(groups, maxPages, nil)
                            return
                        }
                        
                    }
                } else {
                    os_log("un expected serialization error", type: .error)
                    DispatchQueue.main.async {
                        let error = NSError(domain: "Local", code: 0, userInfo: [
                        "message":"un expected error"
                        ])
                        completion(nil,1,error)
                        return
                    }
                }

                
            } catch let jsonErr {
                os_log("Failed to decode JSON", log: OSLog.default, type: .error, jsonErr.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil, nil, jsonErr)
                    return
                }
                
            }
            }.resume()
    }
    
    /**
     **Fetching Photos From the API**.
     ````
     ALAMOFIRE Method
     ````
     - Parameter keyword: the search keyword
     - Parameter page: the page number (used for the pagination when scroll to the last item)
     - Parameter photos: array of returned photos
     - Parameter maxPages: the maximum number of pages for specific keyword results (used for the pagination when scroll to the last item)
     - Parameter error: error object if an error occured
     */
    public static func fetchPhotos(with keyword :String, page: Int, completion: @escaping (_ photos: [Photo]?,_ maxPages: Int?,_ error: Error?) -> ()) {
        os_log("fetchPhotos(with keyword :String, page: Int, completion: @escaping ([Photo]?, Int?, Error?) -> ())" , type: .debug)
        let baseURL = "\(BASE_URL)/\(MethodKeys.photos)"
        let apiString = "&api_key=\(API_KEY)&page=\(page)"
        let searchString = "&text=\(keyword.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")&format=json&nojsoncallback=1"

        Alamofire.request(baseURL + apiString + searchString).validate().responseJSON { response in
            switch response.result {
            case .success:
                if let json = response.result.value as? NSDictionary{
                    if let photosDic = json["photos"] as? NSDictionary {
                        let photos: [Photo]!
                        var maxPage = 1
                        maxPage = photosDic.getValueForKey(key: "pages", callback: 1)
                        if let arr = photosDic["photo"] as? [NSDictionary] {
                            photos = arr.map({ (object) -> Photo in
                                return Photo(data: object as AnyObject)
                            })
    
                            DispatchQueue.main.async {
                                completion(photos, maxPage, nil)
                            }
                            return
                        }
                    }
                } else {
                    os_log("un expected serialization error", type: .error)
                    DispatchQueue.main.async {
                        let error = NSError(domain: "Local", code: 0, userInfo: [
                            "message":"un expected error"
                            ])
                        completion(nil,1,error)
                        return
                    }
                }
                
            case .failure(let error):
                completion(nil, nil, error)
                os_log("Server Error", log: OSLog.default, type: .error, error.localizedDescription)
            }
        }
    }
}
