//
//  LoginResponseModel.swift
//  BrazilTestiOS
//
//  Created by Mujeeb Ulla Shariff on 01/11/19.
//  Copyright © 2019 Mujeeb Ulla Shariff. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let userAccount: UserAccount
    let error: ErrorModel
}

struct UserAccount: Codable {
    let userId: Int
    let name, bankAccount, agency: String
    let balance: Double
    
}

struct ErrorModel: Codable {
    let code: Int
    let errorMessage: String
    
    init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = (try container.decodeIfPresent(Int.self, forKey: .code)) ?? -1
        errorMessage = (try container.decodeIfPresent(String.self, forKey: .errorMessage)) ?? "NA"
    }
    init(code: Int, message: String) {
        self.code = code
        self.errorMessage = message
    }
}
