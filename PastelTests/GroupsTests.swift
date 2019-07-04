
//
//  GroupsTests.swift
//  PastelTests
//
//  Created by Ahmed Zaghloul on 7/3/19.
//  Copyright © 2019 Ahmed Zaghloul. All rights reserved.
//

import XCTest
@testable import Pastel

class GroupTests: XCTestCase {
    let groupsPresenter = GroupsPresenter()

    override func setUp() {
        super.setUp()

    }
    
    func testEmptyLocalData() {
        CoreDataManager.deleteAllGroupsRecords()
        let expec = expectation(description: "Failed test empty local groups 🙌🏼")
        let mockVC = MockGroupsVC(expectation: expec, presenter: groupsPresenter)
        groupsPresenter.attachView(view: mockVC)
        
        XCTAssertEqual(groupsPresenter.maxPages, 1)
        // Test the number of data retrieved
        XCTAssertEqual(groupsPresenter.numberOfItems, CoreDataManager.numberOfSavedGroups())
        XCTAssertEqual(CoreDataManager.numberOfSavedGroups(), 0)
        wait(for: [expec], timeout: 20.0)
    }

    func testLocalData(){
        let expec = expectation(description: "Failed to get local groups 🙌🏼")
        let mockVC = MockGroupsVC(expectation: expec, presenter: groupsPresenter)
        groupsPresenter.attachView(view: mockVC)
        
        XCTAssertEqual(groupsPresenter.maxPages, 1)
        // Test the number of data retrieved
        XCTAssertEqual(groupsPresenter.numberOfItems, CoreDataManager.numberOfSavedGroups())
        wait(for: [expec], timeout: 20.0)
    }
    
    func testUpdatingData() {

        let expec = expectation(description: "Failed to update groups 🙌🏼")
        // When setting the `searchText` to any value, the presenter will fetch the new data
        groupsPresenter.searchText = "Apple"
        let mockVC = MockGroupsVC(expectation: expec, presenter: groupsPresenter)
        groupsPresenter.attachView(view: mockVC)
        wait(for: [expec], timeout: 20.0)
    }
    
    func testPaging() {
        let expec = expectation(description: "Failed to get new page of groups 🙌🏼")
        // When setting the `searchText` to any value, the presenter will fetch the new data
        groupsPresenter.searchText = "Apple"
        let mockVC = MockGroupsVC(expectation: expec, presenter: groupsPresenter)
        groupsPresenter.attachView(view: mockVC)
        wait(for: [expec], timeout: 20.0)
    }
    
}

class MockGroupsVC: ViewsBaseDelegate{
    var expec: XCTestExpectation
    var presenter: GroupsPresenter
    init(expectation: XCTestExpectation, presenter: GroupsPresenter) {
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
