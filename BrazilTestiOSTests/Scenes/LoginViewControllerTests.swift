//
//  LoginViewControllerTests.swift
//  BrazilTestiOSTests
//
//  Created by Mujeeb Ulla Shariff on 22/11/19.
//  Copyright © 2019 Mujeeb Ulla Shariff. All rights reserved.
//
@testable import BrazilTestiOS
import XCTest

class LoginViewControllerTests: XCTestCase {
  
  // MARK: - Subject under test
  
  var sut: LoginViewController!
  var window: UIWindow!
  
  // MARK: - Test lifecycle
  
  override func setUp() {
    super.setUp()
    window = UIWindow()
    setupLoginViewController()
  }
  
  override func tearDown() {
    window = nil
    super.tearDown()
  }
  
  // MARK: - Test setup
  
  func setupLoginViewController() {
    let bundle = Bundle(for: self.classForCoder)
    
    let storyboard = UIStoryboard(name: "Main", bundle: bundle)
    sut = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
  }
  
  func loadView() {
    window.addSubview(sut.view)
    RunLoop.current.run(until: Date())
  }
  
  // MARK: - Test doubles
  class LoginBusinessLogicSpy: LoginBusinessLogic {
    
    // MARK: Method call expectations
    var fetchUserCalled = false
    var validateInputsCalled = false
    var loginCalled = false
    
    // MARK: Argument expectations
    var validationDataRequest: Login.ValidationModel.Request!
    var loginDataRequest: Login.LoginModel.Request!
    
    // MARK: Spied variables
    var userDetails: UserAccount?
    
    // MARK: Spied methods
    func fetchUser(request: Login.FetchModel.Request) {
      fetchUserCalled = true
    }
    
    func validateInputs(request: Login.ValidationModel.Request) {
      validateInputsCalled = true
      self.validationDataRequest = request
    }
    
    func login(request: Login.LoginModel.Request) {
      loginCalled = true
      self.loginDataRequest = request
    }
    
  }
  
  class LoginRouterSpy: LoginRouter {
    // MARK: Method call expectations
    
    var routeToGoToHomeCalled = false
    
    // MARK: Spied methods
    
    override func routeToGoToHome(segue: UIStoryboardSegue?) {
      routeToGoToHomeCalled = true
    }
    
  }
  
  //MARK: -Test UserDefaults Fetch
  
  func testShouldFetchFromUserDefaultsOnViewWillAppear() {
    // Given
    let loginBusinessLogicSpy = LoginBusinessLogicSpy()
    sut.interactor = loginBusinessLogicSpy
    loadView()
    
    // When
    sut.viewWillAppear(true)
    
    // Then
    XCTAssert(loginBusinessLogicSpy.fetchUserCalled, "Should get User Name of Previous Logged in user if exists when view appears")
  }
  
  
  //MARK: -Test Text Fields
  
  func testCursorFocusShouldMoveToPasswordFieldWhenUserTapsReturnKeyOnUsernameField() {
    // Given
    loadView()
    
    
    // When
    guard let username = sut.username else{return}
    guard let password = sut.password else{return}
    let currentTextField = username
    let nextTextField = password
    currentTextField.becomeFirstResponder()
    _ = sut.textFieldShouldReturn(currentTextField)
    
    // Then
    XCTAssert(!currentTextField.isFirstResponder, "Current text field should lose keyboard focus")
    XCTAssert(nextTextField.isFirstResponder, "Password text field should gain keyboard focus")
  }
  
  func testKeyboardShouldBeDismissedWhenUserTapsReturnKeyOnPasswordTextField() {
    // Given
    loadView()
    
    // When
    guard let password = sut.password else{return}
    let lastTextField = password
    lastTextField.becomeFirstResponder()
    _ = sut.textFieldShouldReturn(lastTextField)
    
    // Then
    XCTAssert(!lastTextField.isFirstResponder, "Last text field should lose keyboard focus")
  }
  
  func testShouldValidateInputsUponLoginButtonClick() {
    // Given
    let loginBusinessLogicSpy = LoginBusinessLogicSpy()
    sut.interactor = loginBusinessLogicSpy
    //        sut.username.text = Seeds.loginData.userName
    //        sut.password.text = Seeds.loginData.password
    
    // When
    sut.loginBtnClicked(self)
    
    // Then
    XCTAssert(loginBusinessLogicSpy.validateInputsCalled, "should validate inputs upon Login button click")
  }
  
  func testLoginOnSuccessfullValidation() {
    // Given
    
    let loginBusinessLogicSpy = LoginBusinessLogicSpy()
    sut.interactor = loginBusinessLogicSpy
    let viewModel = Login.ValidationModel.ViewModel(validUser: true, validPassword: true)
    
    // When
    loadView()
    sut.ValidationResult(viewModel: viewModel)
    
    // Then
    XCTAssert(loginBusinessLogicSpy.loginCalled,"Login Should be called upon successfull validation")
  }
  
  func testDisplayMessageOnUserNameValidationFailure() {
    //Given
    let loginBusinessLogicSpy = LoginBusinessLogicSpy()
    sut.interactor = loginBusinessLogicSpy
    let viewModel = Login.ValidationModel.ViewModel(validUser: false, validPassword: true)
    
    //When
    loadView()
    sut.ValidationResult(viewModel: viewModel)
    
    //Then
    XCTAssertEqual(sut.warningLabel.text, "Please enter valid username", "loginButtonTapped(_:) should display a warning message when username is wrong")
  }
  
  func testDisplayMessageOnPasswordValidationFailure() {
    //Given
    let loginBusinessLogicSpy = LoginBusinessLogicSpy()
    sut.interactor = loginBusinessLogicSpy
    let viewModel = Login.ValidationModel.ViewModel(validUser: true, validPassword: false)
    
    //When
    loadView()
    sut.ValidationResult(viewModel: viewModel)
    
    //Then
    XCTAssertEqual(sut.warningLabel.text, "Please enter valid password", "loginButtonTapped(_:) should display a warning message when password is wrong")
    
  }
  
  func testDisplayMessageOnValidationFailure() {
    //Given
    let loginBusinessLogicSpy = LoginBusinessLogicSpy()
    sut.interactor = loginBusinessLogicSpy
    let viewModel = Login.ValidationModel.ViewModel(validUser: false, validPassword: false)
    
    //When
    loadView()
    sut.ValidationResult(viewModel: viewModel)
    
    //Then
    XCTAssertEqual(sut.warningLabel.text, "Please enter valid username & password", "loginButtonTapped(_:) should display a warning message when both username & password are wrong")
    
  }
}
