//
//  Repository.swift
//  Pastel
//
//  Created by Ahmed Zaghloul on 7/1/19.
//  Copyright © 2019 Ahmed Zaghloul. All rights reserved.
//

import Foundation
import Kingfisher
import os

class Repository {
    /**
     **Get groups**.
     ``
     Check if there's a local groups to be fetched or update with new groups
     ``
     - Parameter keyword: the search keyword
     - Parameter page: the page number (used for the pagination when scroll to the last item)
     - Parameter groups: array of returned groups
     - Parameter maxPages: the maximum number of pages for specific keyword results (used for the pagination when scroll to the last item)
     - Parameter error: error object if an error occured
     */
    static func getGroups(with keyword: String, page: Int, completion: @escaping (_ groups: [Group]?,_ maxPages: Int?,_ error: Error?) -> ()) {
        os_log("Repository.getGroups(with keyword: String, page: Int, completion: @escaping ([Group]?, Int?, Error?) -> ())", type: .debug)
        if keyword == "" && CoreDataManager.isLocalStorageHavingGroups() {
            CoreDataManager.fetchGroups { (groups, error) in
                completion(groups,1,error)
            }
        } else if keyword != "" {
            RequestsManager.fetchGroups(with: keyword, page: page) { (groups, maxPages, error) in
                if error == nil {
                    if page == 1 {
                        CoreDataManager.deleteAllGroupsRecords()
                    }
                    Repository.save(groups: groups!)
                    Repository.prefetchImages(for: groups!)
                }
                completion(groups,maxPages,error)
            }
        } else {
            let error = NSError(domain: "Local", code: 0, userInfo: [
                "message":"You don't have any recent search results"
                ])
            completion(nil,1,error)
        }
    }
    
    /**
     **Save groups**.
     ``
     Save an array of groups
     ``
     - Parameter groups: array of groups that will be saved
     */
    private static func save(groups: [Group]) {
        os_log("Repository.save(groups: [Group])", type: .debug)
        for group in groups {
            CoreDataManager.saveNew(Group: group)
        }
    }
    
    /**
     **Prefetsh images of groups**.
     ``
     Prefetch all images for the groups (download once)
     ``
     - Parameter groups: array of groups that will save their images
     */
    private static func prefetchImages(for groups: [Group]) {
        os_log("Repository.prefetchImages(for groups: [Group])", type: .debug)
        // MARK: Prefetching images + storing objects in core data
        
        let urls: [URL] = groups
            .map {
                var urlStr = groupBaseURL
                urlStr = urlStr.replacingOccurrences(of: "{icon-farm}", with: "\($0.iconfarm ?? 0)")
                urlStr = urlStr.replacingOccurrences(of: "{icon-server}", with: $0.iconserver ?? "")
                urlStr = urlStr.replacingOccurrences(of: "{nsid}", with: $0.nsid ?? "")
                
                return URL(string: urlStr)!
        }
        let prefetcher = ImagePrefetcher(urls: urls) {
            skippedResources, failedResources, completedResources in
            print("These resources are prefetched: \(completedResources)")
        }
        prefetcher.start()
    }
    
    /**
     **Get photos**.
     ``
     Check if there's a local photos to be fetched or update with new photos
     ``
     - Parameter keyword: the search keyword
     - Parameter page: the page number (used for the pagination when scroll to the last item)
     - Parameter photos: array of returned photos
     - Parameter maxPages: the maximum number of pages for specific keyword results (used for the pagination when scroll to the last item)
     - Parameter error: error object if an error occured
     */
    static func getPhotos(with keyword: String, page: Int, completion: @escaping (_ photos: [Photo]?,_ maxPages: Int?,_ error: Error?) -> ()) {
        os_log("Repository.getPhotos(with keyword: String, page: Int, completion: @escaping ([Photo]?, Int?, Error?) -> ())", type: .debug)
        if keyword == "" && CoreDataManager.isLocalStorageHavingPhotos() {
            CoreDataManager.fetchPhotos { (photos, error) in
                completion(photos,1,error)
            }
        } else if keyword != "" {
            RequestsManager.fetchPhotos(with: keyword, page: page) { (photos, maxPages, error) in
                if error == nil {
                    if page == 1 {
                        CoreDataManager.deleteAllPhotosRecords()
                    }
                    Repository.save(photos: photos!)
                    Repository.prefetchImages(for: photos!)
                }
                completion(photos,maxPages,error)
            }
        } else {
            let error = NSError(domain: "Local", code: 0, userInfo: [
                "message":"You don't have any recent search results"
                ])
            completion(nil,1,error)
        }
    }
    
    /**
     **Save photos**.
     ``
     Save an array of photos
     ``
     - Parameter photos: array of photos that will be saved
     */
    private static func save(photos: [Photo]) {
        os_log("Repository.save(photos: [Photo])", type: .debug)
        for photo in photos {
            CoreDataManager.saveNew(Photo: photo)
        }
    }
    
    /**
     **Prefetsh images of photos**.
     ``
     Prefetch all images for the photos (download once)
     ``
     - Parameter photos: array of photos that will save their images
     */
    private static func prefetchImages(for photos: [Photo]) {
        os_log("Repository.prefetchImages(for photos: [Photo])", type: .debug)
        // MARK: Prefetching images + storing objects in core data
        
        let urls: [URL] = photos
            .map {
                var urlStr = photoBaseURL
                urlStr = urlStr.replacingOccurrences(of: "{farm-id}", with: "\($0.farm ?? 0)")
                urlStr = urlStr.replacingOccurrences(of: "{server-id}", with: $0.server ?? "")
                urlStr = urlStr.replacingOccurrences(of: "{id}", with: $0.id ?? "")
                urlStr = urlStr.replacingOccurrences(of: "{secret}", with: $0.secret ?? "")
                
                return URL(string: urlStr)!
        }
        let prefetcher = ImagePrefetcher(urls: urls) {
            skippedResources, failedResources, completedResources in
            print("These resources are prefetched: \(completedResources)")
        }
        prefetcher.start()
    }

}
