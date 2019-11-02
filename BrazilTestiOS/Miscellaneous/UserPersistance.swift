//
//  Persistance.swift
//  BrazilTestiOS
//
//  Created by Mujeeb Ulla Shariff on 01/11/19.
//  Copyright © 2019 Mujeeb Ulla Shariff. All rights reserved.
//

import Foundation
class UserPersistance {
    func saveUserId(_ userId: String?)
    {
        UserDefaults.standard.set(userId, forKey: "user")
    }

    func getUserId() -> String?
    {
        return UserDefaults.standard.string(forKey: "user")
    }
}

