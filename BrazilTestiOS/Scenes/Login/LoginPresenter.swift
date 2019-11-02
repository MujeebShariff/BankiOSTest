//
//  LoginPresenter.swift
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

protocol LoginPresentationLogic
{
  func presentLoginResult(response: Login.LoginModel.Response)
}

class LoginPresenter: LoginPresentationLogic
{
  weak var viewController: LoginDisplayLogic?
  
  // MARK: Do something
  
  func presentLoginResult(response: Login.LoginModel.Response)
  {
    let viewModel = Login.LoginModel.ViewModel(success: response.success, loginResponse: response.loginResponse)
    viewController?.displaySomething(viewModel: viewModel)
  }
}
