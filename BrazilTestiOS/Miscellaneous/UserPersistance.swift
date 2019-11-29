//
//  Persistance.swift
//  BrazilTestiOS
//
//  Created by Mujeeb Ulla Shariff on 01/11/19.
//  Copyright © 2019 Mujeeb Ulla Shariff. All rights reserved.
//

import Foundation
class UserPersistance {
  
  // save userId to UserDefaults
  func saveUserId(userId: String?, userName: String?) {
    UserDefaults.standard.set(userId, forKey: "userId")
    UserDefaults.standard.set(userName, forKey: "userName")
  }
  
  // get userId from UserDefaults
  func getUserId() -> String? {
    return UserDefaults.standard.string(forKey: "userId")
  }
  
  // save username from UserDefaults
  func getUserName() -> String? {
    return UserDefaults.standard.string(forKey: "userName")
  }
}

