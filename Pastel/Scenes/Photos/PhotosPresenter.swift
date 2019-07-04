//
//  PhotosPresenter.swift
//  Pastel
//
//  Created by Ahmed Zaghloul on 6/28/19.
//  Copyright © 2019 Ahmed Zaghloul. All rights reserved.
//

import Foundation
import os

class PhotosPresenter {
    private var photos: [Photo] = []
    private weak var view: ViewsBaseDelegate?
    
    /**
     **Search Text**.
     ``
     Holds the search text (The Default is empty string)
     ``
     */
    var searchText = "" {
        didSet {
            if searchText != "" && view != nil{
                view?.reloadView()
                page = 1
                photos = []
                fetchData()
            }
        }
    }
    
    /**
     **Current page number**.
     ``
     The number current scrolling page (The Default is 1)
     ``
     */
    private var page = 1 {
        didSet {
            if page != 1 && view != nil {
                fetchData()
            }
        }
    }
    
    /**
     **Max number of pages**.
     ``
     The maximum number of pages to determine when the paging ended (The Default is 1)
     ``
     */
    private var maxPages = 1
    
    /**
     **Number of items**.
     ``
     Returning the number of items that should be presented
     ``
     */
    public var numberOfItems: Int {
        if (photos.count) == 0 {
            self.view?.showNoDataView()
        }
        return photos.count
    }
    
    /**
     **Attach View**.
     ``
     Call this function to attach a view that implementing the `ViewsBaseDelegate`
     ``
     - Parameter view: the view that implements the delegate
     */
    func attachView(view: ViewsBaseDelegate) {
        os_log("PhotosPresenter.attachView(view: ViewsBaseDelegate)", type: .debug)
        self.view = view
        viewDidAttach()
    }
    
    /**
     **View Did Attached**.
     ``
     Called when the view did attached to start fetching data
     ``
     */
    func viewDidAttach() {
        os_log("PhotosPresenter.viewDidAttach()", type: .debug)
        fetchData()
    }
    
    /**
     **Fetch Data**.
     ``
     Called to start fetching photos
     ``
     */
    private func fetchData() {
        os_log("PhotosPresenter.fetchData()", type: .debug)
        view?.showLoader()
        Repository.getPhotos(with: searchText, page: page) { (photos, maxPages, error) in
            self.view?.hideLoader()
            
            guard error == nil else {
                if let error = error as NSError? {
                    if error.code == 0 {
                        guard let message = error.userInfo["message"] as? String else {
                            self.view?.showAlertWith(title: "Error", message: "You don't have any recent search results" )
                            return
                        }
                        self.view?.showAlertWith(title: "Error", message: message)
                        return
                    }
                }
                self.view?.showAlertWith(title: "Error", message: error?.localizedDescription ?? "" )
                return
            }
            
            self.maxPages = maxPages ?? 1
            self.photos = self.page == 1 ? photos! : self.photos + photos!
            self.view?.reloadView()
        }
    }
    
    /**
     **Photo for Cell**.
     ``
     Called to get an object at specific index
     ``
     - Parameter indexPath: index for the needed object
     */
    func photoForCell(at indexPath: IndexPath) -> Photo {
        os_log("PhotosPresenter.photoForCell(at indexPath: IndexPath) -> Photo", type: .debug)
        if indexPath.item == self.photos.count - 1 && self.page < self.maxPages {
            self.page += 1
        }
        return self.photos[indexPath.item]
    }
    
    /**
     **Image Selection**.
     ``
     Called when an image selected to perform an action for that
     ``
     - Parameter indexPath: index for the selected object
     */
    func didTapOnImage(at indexPath: IndexPath) {
        os_log("PhotosPresenter.didTapOnImage(at indexPath: IndexPath)", type: .debug)
        self.view?.navigateToSceneWith(id: "fullImage", data: photoForCell(at: indexPath))
    }
    
}
