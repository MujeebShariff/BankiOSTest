//
//  Seeds.swift
//  BrazilTestiOSTests
//
//  Created by Mujeeb Ulla Shariff on 11/11/19.
//  Copyright © 2019 Mujeeb Ulla Shariff. All rights reserved.
//

@testable import BrazilTestiOS
import XCTest

struct Seeds
{
    
  struct loginData {
    static let userName = "muj@gma.com"
    static let password = "abCd@2"
  }
    
  struct Accounts {
    static let Jose = UserAccount(userId: 1, name: "Jose da Silva Teste", bankAccount: "2050", agency: "012314564", balance: 3.3445)
  }
    
  struct Transactions {
    static let Statement1 = StatementList(title: "Pagamento", desc: "Conta de luz", date: "2018-08-15", value: -50)
    static let Statement2 = StatementList(title: "TED Recebida", desc: "Joao Alfredo", date: "2018-07-25", value: 745.03)
    static let Statement3 = StatementList(title: "DOC Recebida", desc: "Victor Silva", date: "2018-06-23", value: 399.9)
  }
    
    struct FormattedTransactions {
        static let Statement1 = StatementList(title: "Pagamento", desc: "Conta de luz", date: "08/15/2018", value: -50.0)
      static let Statement2 = StatementList(title: "TED Recebida", desc: "Joao Alfredo", date: "07/25/2018", value: 745.03)
      static let Statement3 = StatementList(title: "DOC Recebida", desc: "Victor Silva", date: "06/23/2018", value: 399.9)
    }
}

