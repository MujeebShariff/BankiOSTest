//
//  HomeInteractorTests.swift
//  BrazilTestiOSTests
//
//  Created by Mujeeb Ulla Shariff on 22/11/19.
//  Copyright © 2019 Mujeeb Ulla Shariff. All rights reserved.
//

import XCTest

class HomeInteractorTests: XCTestCase {

     // MARK: - Subject under test
       
       var sut: HomeInteractor!
       
       // MARK: - Test lifecycle
       
       override func setUp()
       {
         super.setUp()
         setupHomeInteractor()
       }
       
       override func tearDown()
       {
         super.tearDown()
       }
       
       // MARK: - Test setup
       
       func setupHomeInteractor()
       {
         sut = HomeInteractor()
       }
       
       // MARK: - Test doubles
       
       class HomePresentationLogicSpy: HomePresentationLogic
       {
        
         // MARK: Method call expectations
         
         var presentAccountDetailsCalled = false
         var presentStatementDetailsCalled = false
         var logoutCalled = false
         
         // MARK: Spied methods
         
           func presentAccountDetails(response: Home.HomeData.Response) {
               presentAccountDetailsCalled = true
           }
           
           func presentStatementDetails(response: Home.GetStatementList.Response) {
               presentStatementDetailsCalled = true
           }
           
           func logout() {
               logoutCalled = true
           }
       }
       
       class HomeWorkerSpy: HomeWorker
       {
         // MARK: Method call expectations
         
         var getStatementsCalled = false
         
         // MARK: Spied methods
         
         override func getStatements(completion: @escaping (Bool, Statement?, Error?) -> Void)
         {
           getStatementsCalled = true
            completion(true,Statement(statementList: [ Seeds.Transactions.Statement1,Seeds.Transactions.Statement2,Seeds.Transactions.Statement3], error: ErrorModel(code: 1, message: "No Error")), nil)
         }
       }
       // MARK: - Tests
       
       func testGetUserDataShouldFetchUserDataAndAskPresenterToFormatResult()
       {
         // Given
         let homePresentationLogicSpy = HomePresentationLogicSpy()
         sut.presenter = homePresentationLogicSpy
           
         // When
        sut.userDetails = Seeds.Accounts.Jose
         let request = Home.HomeData.Request()
           sut.getUserData(request: request)
         
         // Then
        XCTAssert(homePresentationLogicSpy.presentAccountDetailsCalled, "getUserData() should ask presenter to format User data")
           
       }
       
       func testGetStatementListShouldAskHomeWorkerToGetStatementsAndSendToPresenterToFormatResult()
       {
         // Given
         let homePresentationLogicSpy = HomePresentationLogicSpy()
         sut.presenter = homePresentationLogicSpy
           let workerSpy = HomeWorkerSpy()
           sut.worker = workerSpy
         
         // When
           let request = Home.GetStatementList.Request()
           sut.getStatementList(request: request)
            
         // Then
        XCTAssert(homePresentationLogicSpy.presentStatementDetailsCalled, "getStatementList() should ask presentor to format the validation result")
            XCTAssert(workerSpy.getStatementsCalled, "getStatementList() should ask HomeWorker to get statement list from api")
       }
       
       func testLogoutShouldAskPresenterToLogout()
       {
         // Given
         let homePresentationLogicSpy = HomePresentationLogicSpy()
         sut.presenter = homePresentationLogicSpy
           
         // When
        sut.logout()
           
         // Then
        XCTAssert(homePresentationLogicSpy.logoutCalled , "logout() should ask presentor to Logout")
       }
}
