//
//  PhotosTests.swift
//  PastelTests
//
//  Created by Ahmed Zaghloul on 7/3/19.
//  Copyright © 2019 Ahmed Zaghloul. All rights reserved.
//

import XCTest
@testable import Pastel

class PhotoTests: XCTestCase {
    let photosPresenter = PhotosPresenter()
    
    override func setUp() {
        super.setUp()
        
    }
    
    func testEmptyLocalData() {
        CoreDataManager.deleteAllPhotosRecords()
        let expec = expectation(description: "Failed test empty local photos 🙌🏼")
        let mockVC = MockPhotosVC(expectation: expec, presenter: photosPresenter)
        photosPresenter.attachView(view: mockVC)
        
        XCTAssertEqual(photosPresenter.maxPages, 1)
        XCTAssertEqual(photosPresenter.numberOfItems, CoreDataManager.numberOfSavedPhotos())
        XCTAssertEqual(CoreDataManager.numberOfSavedPhotos(), 0)
        wait(for: [expec], timeout: 20.0)
    }
    
    func testLocalData(){
        let expec = expectation(description: "Failed to get local photos 🙌🏼")
        let mockVC = MockPhotosVC(expectation: expec, presenter: photosPresenter)
        photosPresenter.attachView(view: mockVC)
        
        XCTAssertEqual(photosPresenter.maxPages, 1)
        // Test the number of data retrieved
        XCTAssertEqual(photosPresenter.numberOfItems, CoreDataManager.numberOfSavedPhotos())
        wait(for: [expec], timeout: 20.0)
        
    }
    
    func testUpdatingData() {
        
        let expec = expectation(description: "Failed to update groups 🙌🏼")
        // When setting the `searchText` to any value, the presenter will fetch the new data
        photosPresenter.searchText = "Apple"
        let mockVC = MockPhotosVC(expectation: expec, presenter: photosPresenter)
        photosPresenter.attachView(view: mockVC)
        print(mockVC)
        wait(for: [expec], timeout: 20.0)
        
    }
    
}

class MockPhotosVC: ViewsBaseDelegate{
    var expec: XCTestExpectation
    var presenter: PhotosPresenter
    init(expectation: XCTestExpectation, presenter: PhotosPresenter) {
        self.expec = expectation
        self.presenter = presenter
    }
    
    func showLoader() {
        
    }
    
    func hideLoader() {
        
    }
    
    func showAlertWith(title: String, message: String) {
        XCTAssertEqual(message, "You don't have any recent search results")
        expec.fulfill()
    }
    
    func reloadView() {
        if self.presenter.numberOfItems != 0 {
            XCTAssertGreaterThan(presenter.numberOfItems, 0)
            expec.fulfill()
        }
    }
    
    func showNoDataView() {
        
    }
    
    func navigateToSceneWith(id: String, data: Any) {
        
    }
}
