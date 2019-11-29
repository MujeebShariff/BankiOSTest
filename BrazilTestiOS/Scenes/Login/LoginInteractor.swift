//
//  LoginInteractor.swift
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

protocol LoginBusinessLogic {
  var userDetails: UserAccount? { get }
  func fetchUser(request: Login.FetchModel.Request)
  func validateInputs(request: Login.ValidationModel.Request)
  func login(request: Login.LoginModel.Request)
}

protocol LoginDataStore {
  var userDetails: UserAccount? { get }
}

class LoginInteractor: LoginBusinessLogic, LoginDataStore {
  var userPersistance = UserPersistance()
  var presenter: LoginPresentationLogic?
  var worker = LoginWorker()
  var userDetails: UserAccount?
  
  // MARK: - Fetch Previous Logged In User    
  func fetchUser(request: Login.FetchModel.Request) {
    let userName = userPersistance.getUserName()
    let response = Login.FetchModel.Response(user: userName)
    presenter?.presentFetchUserResult(response: response)
  }
  
  // MARK: - Validation
  func validateInputs(request: Login.ValidationModel.Request) {
    guard let userName = request.user else {
      return
    }
    guard let password = request.password else {
      return
    }
    let validU: Bool
    let validP: Bool
    
    validU = worker.validateUser(username: userName)
    validP = worker.validatePassword(password: password)
    let response = Login.ValidationModel.Response(validUser: validU, validPassword: validP)
    presenter?.presentValidationResult(response: response)
  }
  
  // MARK: - Login with the help of login worker
  func login(request: Login.LoginModel.Request) {
    guard let userName = request.user else {
      return
    }
    guard let password = request.password else {
      return
    }
    worker.login(username: userName, password: password) { (success, response, error) in
      if(success) {
        guard let userId = response?.userAccount.userId else {
          return
        }
        guard let responseVal = response else {
          return
        }
        self.userPersistance.saveUserId(userId: "\(userId)", userName: userName)
        let response = Login.LoginModel.Response(success: success, loginResponse: responseVal)
        self.userDetails = response.loginResponse.userAccount
        self.presenter?.presentLoginResult(response: response)
      } else {
        guard let error = error else {
          return
        }
        let response = Login.LoginModel.Response(success: success, loginResponse: response ?? LoginResponse(userAccount: UserAccount(userId: -1, name: "", bankAccount: "", agency: "", balance: nil), error: ErrorModel(code: -1, message: error.localizedDescription)))
        self.userDetails = response.loginResponse.userAccount
        self.presenter?.presentLoginResult(response: response)
      }
    }
  }
}
