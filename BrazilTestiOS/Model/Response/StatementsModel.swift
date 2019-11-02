//
//  StatementsModel.swift
//  BrazilTestiOS
//
//  Created by Mujeeb Ulla Shariff on 01/11/19.
//  Copyright © 2019 Mujeeb Ulla Shariff. All rights reserved.
//

import Foundation

struct Statement: Codable {
    let statementList: [StatementList]
    let error: ErrorModel
}

struct StatementList: Codable {
    let title, desc, date: String
    let value: Double
}
