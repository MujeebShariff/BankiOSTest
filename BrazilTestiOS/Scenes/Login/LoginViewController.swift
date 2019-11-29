//
//  LoginViewController.swift
//  BrazilTestiOS
//
//  Created by Mujeeb Ulla Shariff on 01/11/19.
//  Copyright (c) 2019 Mujeeb Ulla Shariff. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol LoginDisplayLogic: class {
  func displayFetchUserResult(viewModel: Login.FetchModel.ViewModel)
  func ValidationResult(viewModel: Login.ValidationModel.ViewModel)
  func displayLoginResult(viewModel: Login.LoginModel.ViewModel)
}

class LoginViewController: UIViewController, LoginDisplayLogic {
  var interactor: LoginBusinessLogic?
  var router: (NSObjectProtocol & LoginRoutingLogic & LoginDataPassing)?
  
  // MARK: - Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: - Setup
  
  private func setup() {
    let viewController = self
    let interactor = LoginInteractor()
    let presenter = LoginPresenter()
    let router = LoginRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: - Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }
  
  // MARK: - View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    warningLabel.isHidden = true
    username.delegate = self
    password.delegate = self
    
  }
  // MARK: - Pre-fetching username
  
  // fetch previous logged in user's username when view appears
  override func viewWillAppear(_ animated: Bool) {
    fetchPreviousUserDetails()
  }
  
  // Get previous logged in user's username and return
  func fetchPreviousUserDetails() {
    let request = Login.FetchModel.Request()
    interactor?.fetchUser(request: request)
  }
  
  // Display previous logged in user's username in the username textField
  func displayFetchUserResult(viewModel: Login.FetchModel.ViewModel) {
    username.text = viewModel.user
  }
  
  @IBOutlet weak var username: UITextField!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var warningLabel: UILabel!
  let utils = Utilities()
  
  // Call validation method when user clicks on login button
  @IBAction func loginBtnClicked(_ sender: Any) {
    validate()
    //    login()  //To bypass validation uncomment this line and comment validation function call
  }
  
  // Validation method
  func validate() {
    if(username != nil) {
      guard let userName = username.text, !userName.isEmpty else {
        warningLabel.isHidden = false
        if password.text!.isEmpty {
          warningLabel.text = "Please enter Username & Password"
        } else {
          warningLabel.text = "User field cannot be empty"
        }
        utils.hideActivityIndicator(view: self.view)
        return
      }
      guard let passwordValue = password.text, !passwordValue.isEmpty else {
        warningLabel.isHidden = false
        warningLabel.text = "Password field cannot be empty"
        utils.hideActivityIndicator(view: self.view)
        return
      }
      let request = Login.ValidationModel.Request(user: userName, password: passwordValue)
      interactor?.validateInputs(request: request)
    } else {
      let request = Login.ValidationModel.Request(user: "", password: "")
      interactor?.validateInputs(request: request)
    }
  }
  
  // display validation results on the warning label
  func ValidationResult(viewModel: Login.ValidationModel.ViewModel) {
    if viewModel.validUser && viewModel.validPassword {
      login()
    } else {
      warningLabel.isHidden = false
      if viewModel.validUser && !viewModel.validPassword {
        warningLabel.text = "Please enter valid password"
      } else if !viewModel.validUser && viewModel.validPassword {
        warningLabel.text = "Please enter valid username"
      } else {
        warningLabel.text = "Please enter valid username & password"
      }
    }
  }
  
  // MARK: - Login
  
  // Send username & password for interactor
  func login() {
    utils.showActivityIndicator(view: self.view)
    guard let userName = username.text else {
      return
    }
    guard let passwordValue = password.text else {
      return
    }
    let request = Login.LoginModel.Request(user: userName, password: passwordValue)
    interactor?.login(request: request)
  }
  
  // Go to home page on successfull login or display error message on warning label
  func displayLoginResult(viewModel: Login.LoginModel.ViewModel) {
    utils.hideActivityIndicator(view: self.view)
    
    if(viewModel.success) {
      warningLabel.isHidden = true
      username.text = ""
      password.text = ""
      performSegue(withIdentifier: "GoToHome", sender: nil)
    } else {
      warningLabel.isHidden = false
      warningLabel.text = viewModel.loginResponse.error.errorMessage
      username.text = nil
      password.text = nil
      password.resignFirstResponder()
    }
  }
}

// UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
  
  // Hide warning label when user begins editing the Text fields
  func textFieldDidBeginEditing(_ textField: UITextField) {
    warningLabel.isHidden = true
  }
  
  // return key function definition on the text fields
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == username {
      textField.resignFirstResponder()
      password.becomeFirstResponder()
    } else {
      textField.resignFirstResponder()
    }
    return true
  }
}
