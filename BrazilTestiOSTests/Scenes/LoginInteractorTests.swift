//
//  LoginInteractorTests.swift
//  BrazilTestiOSTests
//
//  Created by Mujeeb Ulla Shariff on 22/11/19.
//  Copyright © 2019 Mujeeb Ulla Shariff. All rights reserved.
//

import XCTest

class LoginInteractorTests: XCTestCase {

    // MARK: - Subject under test
    
    var sut: LoginInteractor!
    
    // MARK: - Test lifecycle
    
    override func setUp()
    {
      super.setUp()
      setupLoginInteractor()
    }
    
    override func tearDown()
    {
      super.tearDown()
    }
    
    // MARK: - Test setup
    
    func setupLoginInteractor()
    {
      sut = LoginInteractor()
    }
    
    // MARK: - Test doubles
    
    class UserPersistanceSpy: UserPersistance
      {
          // MARK: Method call expectations
          var saveUserIdCalled = false
          var getUserIdCalled = false
          var getUserNameCalled = false
          
          // MARK: Argument expectations
          var userIdString: String?
          var userNameString: String?
      
          // MARK: Spied methods
          override func saveUserId(userId: String?, userName: String?) {
            saveUserIdCalled = true
            self.userIdString = userId
            self.userNameString = userName
          }
          
          override func getUserId() -> String? {
              getUserIdCalled = true
              return ""
          }
          
           override func getUserName() -> String? {
               getUserNameCalled = true
               return ""
           }
       }
           
    
    class LoginPresentationLogicSpy: LoginPresentationLogic
    {
        
      // MARK: Method call expectations
      
      var presentFetchUserResultCalled = false
      var presentValidationResultCalled = false
      var presentLoginResultCalled = false
      
      // MARK: Spied methods
      
        func presentFetchUserResult(response: Login.FetchModel.Response) {
            presentFetchUserResultCalled = true
        }
        
        func presentValidationResult(response: Login.ValidationModel.Response) {
            presentValidationResultCalled = true
        }
        
        func presentLoginResult(response: Login.LoginModel.Response) {
            presentLoginResultCalled = true
        }
    }
    
    class LoginWorkerSpy: LoginWorker
    {
      // MARK: Method call expectations
      
      var validateUserCalled = false
      var validatePasswordCalled = false
        var loginCalled = false
      
      // MARK: Spied methods
      
      override func validateUser(username: String) -> Bool
      {
        validateUserCalled = true
        return true
      }
      
      override func validatePassword(password: String) -> Bool
      {
        validatePasswordCalled = true
        return true
      }
        
        override func login(username: String, password: String, completion: @escaping (Bool, LoginResponse?, Error?) -> Void) {
            loginCalled = true
            completion(true, LoginResponse(userAccount: Seeds.Accounts.Jose, error: ErrorModel(code: 1, message: "No Error")),nil)
        }
    }
    // MARK: - Tests
    
    func testFetchUserShouldFetchUserNameAndAskPresenterToFormatResult()
    {
      // Given
      let loginPresentationLogicSpy = LoginPresentationLogicSpy()
      sut.presenter = loginPresentationLogicSpy
      let userPersistanceSpy = UserPersistanceSpy()
        sut.userPersistance = userPersistanceSpy
        
      // When
      let request = Login.FetchModel.Request()
        sut.fetchUser(request: request)
      
      // Then
        XCTAssert(userPersistanceSpy.getUserNameCalled, "FetchOrders() should fetch username from user defaults")
      XCTAssert(loginPresentationLogicSpy.presentFetchUserResultCalled, "FetchOrders() should ask presenter to format User data result")
        
    }
    
    func testValidateInputsShouldAskLoginWorkerToValidateUserAndPasswordAndPresenterToFormatResult()
    {
      // Given
      let loginPresentationLogicSpy = LoginPresentationLogicSpy()
      sut.presenter = loginPresentationLogicSpy
        let workerSpy = LoginWorkerSpy()
        sut.worker = workerSpy
      
      // When
        let request = Login.ValidationModel.Request(user: Seeds.loginData.userName, password: Seeds.loginData.password)
        sut.validateInputs(request: request)
      // Then
        XCTAssert(loginPresentationLogicSpy.presentValidationResultCalled, "validateInputs() should ask presentor to format the validation result")
        XCTAssert(workerSpy.validateUserCalled, "validateInputs() should ask LoginWorker to validate username")
        XCTAssert(workerSpy.validatePasswordCalled, "validateInputs() should ask LoginWorker to validate password")
        
        
    }
    
    func testLoginShouldAskLoginWorkerToFetchFromApiAndSendResponseToPresenterToFormatResult()
    {
      // Given
      let loginPresentationLogicSpy = LoginPresentationLogicSpy()
      sut.presenter = loginPresentationLogicSpy
      let workerSpy = LoginWorkerSpy()
      sut.worker = workerSpy
      let userPersistanceSpy = UserPersistanceSpy()
        sut.userPersistance = userPersistanceSpy
        
      // When
      let request = Login.LoginModel.Request()
        sut.login(request: request)
        
      // Then
        XCTAssert(userPersistanceSpy.saveUserIdCalled, "login() should save the user id to user defaults")
        XCTAssert(workerSpy.loginCalled, "login() should ask LoginWorker to fetch from Api")
        XCTAssert(loginPresentationLogicSpy.presentLoginResultCalled, "validateInputs() should ask presentor to format the Login response recieved from the Api")
    }
}
