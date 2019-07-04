//
//  PhotosVC.swift
//  Pastel
//
//  Created by Ahmed Zaghloul on 6/28/19.
//  Copyright © 2019 Ahmed Zaghloul. All rights reserved.
//

import UIKit
import os

class PhotosVC: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Variables
    var presenter: PhotosPresenter!
    let searchController = UISearchController(searchResultsController: nil)

    struct CellIDS {
        static let photoCellID = "PhotoCell"
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
        os_log("PhotosVC.registerCells()", type: .debug)
        let nib = UINib(nibName: CellIDS.photoCellID, bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: CellIDS.photoCellID)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? FullImageVC, let photo = sender as? Photo {
            vc.presenter = FullImagePresenter(photo: photo)
        }
    }
}

extension PhotosVC: ViewsBaseDelegate {
    func navigateToSceneWith(id: String, data: Any) {
        os_log("PhotosVC.navigateToSceneWith(id: String, data: Any)", type: .debug)
        self.performSegue(withIdentifier: id, sender: data)
    }
    
    func showNoDataView() {
        os_log("PhotosVC.showNoDataView()", type: .debug)
        searchController.isActive = true
        // TODO: Implement "No Search Results View"
    }
    
    func showLoader() {
        os_log("PhotosVC.showLoader()", type: .debug)
        self.activityIndicator.startAnimating()
    }
    
    func hideLoader() {
        os_log("PhotosVC.hideLoader()", type: .debug)
        self.activityIndicator.stopAnimating()
    }
    
    func showAlertWith(title: String, message: String) {
        os_log("PhotosVC.showAlertWith(title: String, message: String)", type: .debug)
        self.alertWith(title: title, message: message)
    }
    
    func reloadView() {
        os_log("PhotosVC.reloadView()", type: .debug)
        self.collectionView.reloadData()
    }
    
    
}

extension PhotosVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIDS.photoCellID, for: indexPath) as! PhotoCell
        cell.photo = self.presenter.photoForCell(at: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter.didTapOnImage(at: indexPath)
    }
    
}

// MARK: - Collection View Flow Layout Delegate
extension PhotosVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = Style.sectionInsets.left * (Style.itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / Style.itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
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

extension PhotosVC: UISearchBarDelegate{
    //MARK: - SEARCH
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchText = searchBar.text!
    }
}
