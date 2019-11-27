//
//  HomePresenter.swift
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

protocol HomePresentationLogic
{
    func presentAccountDetails(response: Home.HomeData.Response)
    func presentStatementDetails(response: Home.GetStatementList.Response)
    func logout()
}

class HomePresenter: HomePresentationLogic
{
    
  weak var viewController: HomeDisplayLogic?
  
//    let dateFormatter: DateFormatter = {
//      let dateFormatter = DateFormatter()
//      dateFormatter.dateStyle = .short
//      dateFormatter.timeStyle = .none
//      return dateFormatter
//    }()
    
  // MARK: Do something
  
    func presentAccountDetails(response: Home.HomeData.Response) {
        let name = response.accountDetails.name
        let account = response.accountDetails.bankAccount! + " / " + response.accountDetails.agency!
        let balance = response.accountDetails.balance
        let viewModel = Home.HomeData.ViewModel(name: name!, accountNumber: account, balance: balance!)
        viewController?.displayUserDetails(viewModel: viewModel)
    }
    
    func presentStatementDetails(response: Home.GetStatementList.Response) {
        if let statements = response.statements{
            if !statements.isEmpty{
                let statementList = makeStatementList(statements: statements)
                let viewModel = Home.GetStatementList.ViewModel(success: true, statements: statementList)
                viewController?.displayAccountStatementList(viewModel: viewModel)
            }
        }
        
    }
    
    func logout() {
        viewController?.doLogout()
    }
    
    private func makeStatementList(statements: [StatementList]?) -> [StatementList]
    {
        var accountStatementList: [StatementList] = []
        if let statementList = statements {
            for statement in statementList {
                let title = statement.title
                let desc = statement.desc
                let date = formatDate(date: statement.date)
                let balance = statement.value
                let accountStatement = StatementList(title: title, desc: desc, date: date, value: balance)
                accountStatementList.append(accountStatement)
            }
        }
        return accountStatementList
    }
    
    func formatDate(date: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let myDate = dateFormatter.date(from: date)!
        dateFormatter.dateFormat = "MM/dd/YYYY"
        let formattedDateString = dateFormatter.string(from: myDate)
        return formattedDateString
    }
}
