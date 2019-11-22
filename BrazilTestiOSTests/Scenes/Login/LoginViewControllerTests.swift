//
//  LoginViewControllerTests.swift
//  BrazilTestiOSTests
//
//  Created by Mujeeb Ulla Shariff on 11/11/19.
//  Copyright © 2019 Mujeeb Ulla Shariff. All rights reserved.
//

@testable import BrazilTestiOS
import XCTest

class LoginViewControllerTests: XCTestCase {

    var sut: LoginViewController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController)!
    var window: UIWindow!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        window = UIWindow()
        setupLoginViewController()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        window = nil
        super.tearDown()
    }

    // MARK: - Test setup
    
    func setupLoginViewController()
    {
//        let bundle = Bundle.main
//        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
//        sut = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
    }
    
    func loadView()
    {
//      window.addSubview(sut.view)
      RunLoop.current.run(until: Date())
    }
     
    // MARK: - Test doubles
    
    class userPersistanceSpy: UserPersistance
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
    
    class LoginBusinessLogicSpy: LoginBusinessLogic
    {
        
      // MARK: Method call expectations
      
      var validateInputsCalled = false
      var loginCalled = false
      
      // MARK: Argument expectations
      
      var validationDataRequest: Login.ValidationModel.Request!
      var loginDataRequest: Login.LoginModel.Request!
      
      // MARK: Spied variables

      var userDetails: UserAccount?
      
      // MARK: Spied methods
      
      func validateInputs(request: Login.ValidationModel.Request) {
        validateInputsCalled = true
        self.validationDataRequest = request
      }
      
      func login(request: Login.LoginModel.Request) {
        loginCalled = true
        self.loginDataRequest = request
      }
    
    }
    
    class LoginRouterSpy: LoginRouter
    {
      // MARK: Method call expectations
      
      var routeToGoToHomeCalled = false
      
      // MARK: Spied methods
      
      override func routeToGoToHome(segue: UIStoryboardSegue?)
      {
        routeToGoToHomeCalled = true
      }
      
    }
    
    //MARK: -Test UserDefaults Fetch
    
    func shouldFetchFromUserDefaultsOnViewWillAppear()
    {
        // Given
        loadView()
        
        // When
        sut.viewWillAppear(true)
        
        // Then
        XCTAssert(userPersistanceSpy().getUserNameCalled, "Should get User Name of Previous Logged in user if exists when view appears")
    }
    
    //MARK: -Test Text Fields
    
    func testCursorFocusShouldMoveToPasswordFieldWhenUserTapsReturnKeyOnUsernameField()
    {
      // Given
      loadView()
      
      
      // When
      let currentTextField = sut.username!
      let nextTextField = sut.password!
        currentTextField.becomeFirstResponder()
        _ = sut.textFieldShouldReturn(currentTextField)
      
      // Then
      XCTAssert(!currentTextField.isFirstResponder, "Current text field should lose keyboard focus")
      XCTAssert(nextTextField.isFirstResponder, "Password text field should gain keyboard focus")
    }
    
    func testKeyboardShouldBeDismissedWhenUserTapsReturnKeyOnPasswordTextField()
    {
      // Given
      loadView()
      
      // When
      let lastTextField = sut.password!
      lastTextField.becomeFirstResponder()
      _ = sut.textFieldShouldReturn(lastTextField)
      
      // Then
      XCTAssert(!lastTextField.isFirstResponder, "Last text field should lose keyboard focus")
    }
    
    func shouldValidateInputsUponLoginButtonClick()
    {
        // Given
        let loginBusinessLogicSpy = LoginBusinessLogicSpy()
        sut.interactor = loginBusinessLogicSpy
        
        // When
        loadView()
        
        // Then
        XCTAssert(loginBusinessLogicSpy.validateInputsCalled, "should validate inputs upon Login button click")
    }
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testExample1(){
        
    }
}
