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
                let userId = UserPersistance().getUserId()
                return Endpoints.base + "statements/\(userId!)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
}
