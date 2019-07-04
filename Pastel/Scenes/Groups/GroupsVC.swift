//
//  GroupsVC.swift
//  Pastel
//
//  Created by Ahmed Zaghloul on 6/28/19.
//  Copyright © 2019 Ahmed Zaghloul. All rights reserved.
//

import UIKit
import os

class GroupsVC: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: Variables
    var presenter: GroupsPresenter!
    let searchController = UISearchController(searchResultsController: nil)

    struct CellIDS {
        static let groupCellID = "GroupCell"
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.presenter.attachView(view: self)
        
        searchController.searchBar.tintColor = .groupTableViewBackground
        searchController.searchBar.returnKeyType = .search
        searchController.searchBar.barStyle = .blackTranslucent
        
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = false

        self.navigationItem.searchController = searchController
        
        registerCells()
    }
    
    func registerCells() {
        os_log("GroupsVC.registerCells()", type: .debug)
        let nib = UINib(nibName: CellIDS.groupCellID, bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: CellIDS.groupCellID)
    }
    
}

extension GroupsVC: ViewsBaseDelegate {
    func navigateToSceneWith(id: String, data: Any) {
        // TODO: handle if having any segues
        os_log("GroupsVC.navigateToSceneWith(id: String, data: Any)", type: .debug)
    }
    
    func showNoDataView() {
        os_log("GroupsVC.showNoDataView()", type: .debug)
        self.searchController.isActive = true
        // TODO: Implement "No Search Results View"
    }
    
    func showLoader() {
        os_log("GroupsVC.showLoader()", type: .debug)
        self.activityIndicator.startAnimating()
    }
    
    func hideLoader() {
        os_log("GroupsVC.hideLoader()", type: .debug)
        self.activityIndicator.stopAnimating()
    }
    
    func showAlertWith(title: String, message: String) {
        os_log("GroupsVC.showAlertWith(title: String, message: String)", type: .debug)
        self.alertWith(title: title, message: message)
    }
    
    func reloadView() {
        os_log("GroupsVC.reloadView()", type: .debug)
        self.collectionView.reloadData()
    }
    
}

extension GroupsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIDS.groupCellID, for: indexPath) as! GroupCell
        cell.group = self.presenter.groupForCell(at: indexPath)
        
        return cell
    }
}

// MARK: - Collection View Flow Layout Delegate
extension GroupsVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = Style.sectionInsets.left * (Style.itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / Style.itemsPerRow
        
        
        let verticalPaddingSpace = Style.sectionInsets.left * (Style.itemsPerColumn + 1)
        let availableHeight = collectionView.frame.height - verticalPaddingSpace
        let heightPerItem = availableHeight / Style.itemsPerColumn
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return Style.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Style.sectionInsets.left
    }
}

extension GroupsVC: UISearchBarDelegate{
    //MARK: - SEARCH
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchText = searchBar.text!
    }
}
