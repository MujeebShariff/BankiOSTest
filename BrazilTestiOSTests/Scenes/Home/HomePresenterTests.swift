//
//  HomePresenterTests.swift
//  BrazilTestiOSTests
//
//  Created by Mujeeb Ulla Shariff on 22/11/19.
//  Copyright © 2019 Mujeeb Ulla Shariff. All rights reserved.
//

import XCTest

class HomePresenterTests: XCTestCase {

    // MARK: - Subject under test
     
     var sut: HomePresenter!
     
     // MARK: - Test lifecycle
     
     override func setUp()
     {
       super.setUp()
       setupHomePresenter()
     }
     
     override func tearDown()
     {
       super.tearDown()
     }
     
     // MARK: - Test setup
     
     func setupHomePresenter()
     {
       sut = HomePresenter()
     }
     
     // MARK: - Test doubles
     
     class HomeDisplayLogicSpy: HomeDisplayLogic
     {
        
       // MARK: Method call expectations
       
       var displayUserDetailsCalled = false
       var displayAccountStatementListCalled = false
       var doLogoutCalled = false
        
       // MARK: Argument expectations
       
        var viewModelUserD: Home.HomeData.ViewModel!
        var viewModelStat: Home.GetStatementList.ViewModel!
        
       // MARK: Spied methods
       
        func displayUserDetails(viewModel: Home.HomeData.ViewModel) {
            displayUserDetailsCalled = true
            viewModelUserD = viewModel
        }
        
        func displayAccountStatementList(viewModel: Home.GetStatementList.ViewModel) {
            displayAccountStatementListCalled = true
            viewModelStat = viewModel
        }
        
        func doLogout() {
            doLogoutCalled = true
        }
     }
     
     // MARK: - Tests
     
     func testPresentAccountDetailsShouldAskViewControllerToDisplayFetchedUserDetails()
     {
       // Given
       let homeDisplayLogicSpy = HomeDisplayLogicSpy()
       sut.viewController = homeDisplayLogicSpy
       
       // When
        let response = Home.HomeData.Response(accountDetails: Seeds.Accounts.Jose)
       sut.presentAccountDetails(response: response)
       
       // Then
       XCTAssert(homeDisplayLogicSpy.displayUserDetailsCalled, "presentAccountDetails(_:) should ask view controller to display the fetched User Details")
     }
     
     func testPresentStatementDetailsShouldAskViewControllerToDisplayAccountStatementList()
     {
       // Given
       let homeDisplayLogicSpy = HomeDisplayLogicSpy()
       sut.viewController = homeDisplayLogicSpy
       
       // When
       let response = Home.GetStatementList.Response(success: true, statements: [ Seeds.Transactions.Statement1,Seeds.Transactions.Statement1,Seeds.Transactions.Statement1])
       sut.presentStatementDetails(response: response)
       
       // Then
       XCTAssert(homeDisplayLogicSpy.displayAccountStatementListCalled, "presentStatementDetails(_:) should ask view controller to display the statement list")
     }
    
    func testlogoutShouldAskViewControllerToDoLogout()
    {
      // Given
      let homeDisplayLogicSpy = HomeDisplayLogicSpy()
      sut.viewController = homeDisplayLogicSpy
      
      // When
      sut.logout()
      
      // Then
        XCTAssert(homeDisplayLogicSpy.doLogoutCalled, "logout(_:) should ask view controller to do Logout")
    }
    
    func testformatDateShouldConvertDateToProperFormat()
    {
      // Given
      let homeDisplayLogicSpy = HomeDisplayLogicSpy()
      sut.viewController = homeDisplayLogicSpy

      // When
      let dateString = "2018-08-15"
      
      let returnedDate = sut.formatDate(date: dateString)
      
      // Then
      let expectedDate = "08/15/2018"
        
      XCTAssertEqual(returnedDate, expectedDate, "Presenting an expiration date should convert date from yyyy-MM-dd to MM/dd/YYYY")
    }
}
