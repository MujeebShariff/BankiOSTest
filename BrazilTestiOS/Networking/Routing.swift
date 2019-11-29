//
//  Routing.swift
//  BrazilTestiOS
//
//  Created by Mujeeb Ulla Shariff on 01/11/19.
//  Copyright © 2019 Mujeeb Ulla Shariff. All rights reserved.
//

import Foundation

class NetworkRouter {
  enum Endpoints {
    static let base = "https://bank-app-test.herokuapp.com/api/"
    
    case login
    case statements
    
    var stringValue: String {
      switch self {
        case .login:
          return Endpoints.base + "login"
        case .statements:
          guard let userId = UserPersistance().getUserId() else {
            preconditionFailure("Invalid User ID")
          }
          return Endpoints.base + "statements/\(userId)"
      }
    }
    
    var url: URL {
      guard let url = URL(string: stringValue) else {
        preconditionFailure("Invalid URL string: \(stringValue)")
      }
      return url
    }
  }
}
