//
//  MVVMTests.swift
//  MVVMTests
//
//  Created by diego on 7/29/17.
//  Copyright (c) 2017 Diego Navarro. All rights reserved.
//

import UIKit
import XCTest

class DetailViewModelTests: XCTestCase, DetailViewModelDelegate {
    
    var detailViewModel: DetailViewModel!
    
    override func setUp() {
        super.setUp()
        ShareManager.shared.shares = [Share]()
        detailViewModel = DetailViewModel(delegate: self)
    }
    
    override func tearDown() {
        super.tearDown()
        detailViewModel.delegate = nil
        resetFlags()
    }
    
    // ----------------------------------------------------------------------------------------
    
    
    func testNoData() {
        detailViewModel.handleDonePressed()
        XCTAssert(!dismissCalled && invalidInputCalled)
    }
    
    func testInvalidName() {
        detailViewModel.amount = "84.00"
        
        for name in ["", "Jo", "John", "John ", " John"] {
            detailViewModel.name = name
            
            detailViewModel.handleDonePressed()
            XCTAssert(!dismissCalled && invalidInputCalled)
            resetFlags()
        }
    }
    
    func testInvalidAmount() {
        detailViewModel.name = "John Appleseed"
        
        for amount in ["", "Abc", "A19", "..", "0"] {
            detailViewModel.amount = amount
            
            detailViewModel.handleDonePressed()
            XCTAssert(!dismissCalled && invalidInputCalled)
            resetFlags()
        }
    }
    
    func testAddPlayback() {
        detailViewModel.name = "John Appleseed"
        detailViewModel.amount = "84.0"
        detailViewModel.handleDonePressed()
        
        let isEqual = ShareManager.shared.shares[0] == Share(firstName: "John", lastName: "Appleseed", createdAt: ShareManager.shared.shares[0].createdAt, amount: 84.0)
        XCTAssertTrue(isEqual, "")
    }
    
    func testSavePlayback() {
        detailViewModel.name = "John Appleseed"
        detailViewModel.amount = "84.0"
        detailViewModel.handleDonePressed()
        
        let detailViewModel2 = DetailViewModel(delegate: self, index: 0)
        detailViewModel2.name = "Diego Navarro"
        detailViewModel2.amount = "90.0"
        detailViewModel2.handleDonePressed()
        
        let isEqual = ShareManager.shared.shares[0] == Share(firstName: "Diego", lastName: "Navarro", createdAt: ShareManager.shared.shares[0].createdAt, amount: 90.0)
        XCTAssertTrue(isEqual)
    }
    
    // ----------------------------------------------------------------------------------------
    
    
    
    // ----------------------------------------------------------------------------------------
    
    var dismissCalled = false
    var invalidInputCalled = false
    
    func resetFlags() {
        dismissCalled = false
        invalidInputCalled = false
    }
    
    func dismissAddView() {
        dismissCalled = true
    }
    
    func handleError(withMessage message: String) {
        invalidInputCalled = true
    }
}
