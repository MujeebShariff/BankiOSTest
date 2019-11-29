//
//  LoginPresenterTests.swift
//  BrazilTestiOSTests
//
//  Created by Mujeeb Ulla Shariff on 22/11/19.
//  Copyright © 2019 Mujeeb Ulla Shariff. All rights reserved.
//

import XCTest

class LoginPresenterTests: XCTestCase {
  // MARK: - Subject under test
  
  var sut: LoginPresenter!
  
  // MARK: - Test lifecycle
  
  override func setUp() {
    super.setUp()
    setupLoginPresenter()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  // MARK: - Test setup
  
  func setupLoginPresenter() {
    sut = LoginPresenter()
  }
  
  // MARK: - Test doubles
  
  class LoginDisplayLogicSpy: LoginDisplayLogic {
    
    // MARK: Method call expectations
    
    var displayFetchUserResultCalled = false
    var ValidationResultCalled = false
    var displayLoginResultCalled = false
    
    // MARK: Argument expectations
    
    var viewModelFetch: Login.FetchModel.ViewModel!
    var viewModelVal: Login.ValidationModel.ViewModel!
    var viewModelLogin: Login.LoginModel.ViewModel!
    
    // MARK: Spied methods
    
    func displayFetchUserResult(viewModel: Login.FetchModel.ViewModel) {
      displayFetchUserResultCalled = true
      self.viewModelFetch = viewModel
    }
    
    func ValidationResult(viewModel: Login.ValidationModel.ViewModel) {
      ValidationResultCalled = true
      self.viewModelVal = viewModel
    }
    
    func displayLoginResult(viewModel: Login.LoginModel.ViewModel) {
      displayLoginResultCalled = true
      self.viewModelLogin = viewModel
    }
  }
  
  // MARK: - Tests
  
  func testPresentFetchedUserResultShouldAskViewControllerToDisplayFetchedUserName() {
    // Given
    let loginDisplayLogicSpy = LoginDisplayLogicSpy()
    sut.viewController = loginDisplayLogicSpy
    
    // When
    let response = Login.FetchModel.Response(user: "Mujeeb")
    sut.presentFetchUserResult(response: response)
    
    // Then
    XCTAssert(loginDisplayLogicSpy.displayFetchUserResultCalled, "presentFetchUserResult(_:) should ask view controller to display the fetched Username from user defaults")
  }
  
  func testPresentValidationResultShouldAskViewControllerToDisplayValidationResults() {
    // Given
    let loginDisplayLogicSpy = LoginDisplayLogicSpy()
    sut.viewController = loginDisplayLogicSpy
    
    // When
    let response = Login.ValidationModel.Response(validUser: true, validPassword: true)
    sut.presentValidationResult(response: response)
    
    // Then
    XCTAssert(loginDisplayLogicSpy.ValidationResultCalled, "presentValidationResult(_:) should ask view controller to display the validation results")
  }
  
  func testPresentLoginResultShouldAskViewControllerToDisplayLoginResults() {
    // Given
    let loginDisplayLogicSpy = LoginDisplayLogicSpy()
    sut.viewController = loginDisplayLogicSpy
    
    // When
    let response = Login.LoginModel.Response(success: true, loginResponse: LoginResponse(userAccount: Seeds.Accounts.Jose, error: ErrorModel(code: 1, message: "No Error")))
    sut.presentLoginResult(response: response)
    
    // Then
    XCTAssert(loginDisplayLogicSpy.displayLoginResultCalled, "presentValidationResult(_:) should ask view controller to display the login results")
  }
}
