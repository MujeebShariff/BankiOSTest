//
//  HomeViewController.swift
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

protocol HomeDisplayLogic: class
{
    func displayUserDetails(viewModel: Home.HomeData.ViewModel)
    func displayAccountStatementList(viewModel: Home.GetStatementList.ViewModel)
    func doLogout()
}

class HomeViewController: UIViewController, HomeDisplayLogic, UITableViewDataSource, UITableViewDelegate
{
    
  var interactor: HomeBusinessLogic?
  var router: (NSObjectProtocol & HomeRoutingLogic & HomeDataPassing)?
  var statementList: [StatementList] = []
    
  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = HomeInteractor()
    let presenter = HomePresenter()
    let router = HomeRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    self.transactionsTableView.sectionHeaderHeight = 50
    getUserDetails()
    getStatements()
  }
  
  // MARK: Outlets
  
    @IBOutlet weak var accountHolderName: UILabel!
    @IBOutlet weak var accountNumber: UILabel!
    @IBOutlet weak var accountBalance: UILabel!
    @IBOutlet weak var transactionsTableView: UITableView!
  
    // MARK: User Details
    
    func getUserDetails()
    {
      let request = Home.HomeData.Request()
      interactor?.getUserData(request: request)
    }
    
    func displayUserDetails(viewModel: Home.HomeData.ViewModel) {
        accountHolderName.text = viewModel.name
        accountNumber.text = viewModel.accountNumber
        accountBalance.text = "R$"+"\(viewModel.balance)"
    }
    
    // MARK: Statement List
    
    func getStatements()
    {
      let request = Home.GetStatementList.Request()
      interactor?.getStatementList(request: request)
    }
    
    func displayAccountStatementList(viewModel: Home.GetStatementList.ViewModel) {
        if let statements = viewModel.statements {
            statementList = statements
            transactionsTableView.reloadData()
        }
    }
    
    // MARK: Logout
    
    @IBAction func logoutBtnClicked(_ sender: Any) {
        logout()
    }
    
    func logout() {
        interactor?.logout()
    }
    
    func doLogout(){
        performSegue(withIdentifier: "Logout", sender: nil)
        // dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
      return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Recentes"
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 50))
            headerView.backgroundColor = UIColor.white
        let label = UILabel(frame: CGRect(x: 18, y: 15, width: 100, height: 20))
        label.text = "Recentes"
        label.font = UIFont(name: "HelveticaNeue", size: 17)

        label.textColor = UIColor(red: 72/255, green: 84/255, blue: 101/255, alpha: 1)

        headerView.addSubview(label)
        return headerView
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
      return statementList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
      let displayedTransaction = statementList[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTVCell", for: indexPath) as? TransactionTableViewCell
      if cell == nil {
        cell = UITableViewCell(style: .value1, reuseIdentifier: "TransactionTVCell") as? TransactionTableViewCell
      }
        
        cell?.titleLabel.text = displayedTransaction.title
        cell?.descriptionLabel.text = displayedTransaction.desc
        cell?.dateLabel.text = displayedTransaction.date
        cell?.valueLabel.text = "R$"+String(displayedTransaction.value)
      return cell!
    }
}
