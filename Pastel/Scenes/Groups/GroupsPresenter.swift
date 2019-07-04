//
//  GroupsPresenter.swift
//  Pastel
//
//  Created by Ahmed Zaghloul on 6/28/19.
//  Copyright © 2019 Ahmed Zaghloul. All rights reserved.
//

import Foundation
import Kingfisher
import os

protocol ViewsBaseDelegate: class {
    /**
     **Show loading loader**.
     ``
     Called to show any loading action
     ``
     */
    func showLoader()
    /**
     **Hide loading loader**.
     ``
     Called to hide any loading action
     ``
     */
    func hideLoader()
    /**
     **Show Alert**.
     ``
     Called to show an alert to the user
     ``
     */
    func showAlertWith(title: String, message: String)
    /**
     **Reload View**.
     ``
     Called for reloading view action
     ``
     */
    func reloadView()
    /**
     **Show no data view**.
     ``
     Called to show the empty results action
     ``
     */
    func showNoDataView()
    /**
     **Navigate To**.
     ``
     Called to Navigate from the controller to implement segue with the following parameters
     ``
     - Parameter id: the segue identifier
     - Parameter data: the data that will be sent with this action to the next view
     */
    func navigateToSceneWith(id: String, data: Any)
}

class GroupsPresenter {
    private var groups: [Group] = []
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
                groups = []
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
        if (groups.count) == 0 {
          self.view?.showNoDataView()
        }
        return groups.count
    }
    
    /**
     **Attach View**.
     ``
     Call this function to attach a view that implementing the `ViewsBaseDelegate`
     ``
     - Parameter view: the view that implements the delegate
     */
    func attachView(view: ViewsBaseDelegate) {
        os_log("GroupsPresenter.attachView(view: ViewsBaseDelegate)", type: .debug)
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
        os_log("GroupsPresente.rviewDidAttach()", type: .debug)
        self.fetchData()
    }
    
    /**
     **Fetch Data**.
     ``
     Called to start fetching groups
     ``
     */
    private func fetchData() {
        os_log("GroupsPresenter.fetchData()", type: .debug)
        self.view?.showLoader()
        Repository.getGroups(with: searchText, page: self.page) { (groups, maxPages, error) in
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
            self.groups = self.page == 1 ? groups! : self.groups + groups!
            
            self.view?.reloadView()
        }
    }
    
    /**
     **Group for Cell**.
     ``
     Called to get an object at specific index 
     ``
     - Parameter indexPath: index for the needed object
     */
    func groupForCell(at indexPath: IndexPath) -> Group {
        os_log("GroupsPresenter.groupForCell(at indexPath: IndexPath) -> Group", type: .debug)
        if indexPath.item == self.groups.count - 1 && self.page < self.maxPages {
            self.page += 1
        }
        return self.groups[indexPath.item]
    }
    
}
