//
//  HomeViewControllerTests.swift
//  BrazilTestiOSTests
//
//  Created by Mujeeb Ulla Shariff on 22/11/19.
//  Copyright © 2019 Mujeeb Ulla Shariff. All rights reserved.
//

import XCTest

class HomeViewControllerTests: XCTestCase {
  
  // MARK: - Subject under test
  
  var sut: HomeViewController!
  var window: UIWindow!
  
  // MARK: - Test lifecycle
  
  override func setUp() {
    super.setUp()
    window = UIWindow()
    setupLoginViewController()
  }
  
  override func tearDown() {
    window = nil
    super.tearDown()
  }
  
  // MARK: - Test setup
  
  func setupLoginViewController() {
    let bundle = Bundle(for: self.classForCoder)
    
    let storyboard = UIStoryboard(name: "Main", bundle: bundle)
    sut = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
  }
  
  func loadView() {
    window.addSubview(sut.view)
    RunLoop.current.run(until: Date())
  }
  
  // MARK: - Test doubles
  
  class HomeBusinessLogicSpy: HomeBusinessLogic {
    
    // MARK: Method call expectations
    var getUserDataCalled = false
    var getStatementListCalled = false
    var logoutCalled = false
    
    // MARK: Argument expectations
    var userDataRequest: Home.HomeData.Request!
    var statementListRequest: Home.GetStatementList.Request!
    
    // MARK: Spied variables
    var userDetails: UserAccount?
    
    // MARK: Spied methods
    func getUserData(request: Home.HomeData.Request) {
      getUserDataCalled = true
      userDataRequest = request
    }
    
    func getStatementList(request: Home.GetStatementList.Request) {
      getStatementListCalled = true
      statementListRequest = request
    }
    
    func logout() {
      logoutCalled = true
    }
    
  }
  
  //MARK: - Tests
  
  func testShouldFetchUserDetailsOnViewDidLoad() {
    // Given
    let homeBusinessLogicSpy = HomeBusinessLogicSpy()
    sut.interactor = homeBusinessLogicSpy
    loadView()
    
    // When
    sut.viewDidLoad()
    
    // Then
    XCTAssert(homeBusinessLogicSpy.getUserDataCalled, "Should get User Data when view loads")
  }
  
  func testShouldGetStatementsOnViewDidLoad() {
    // Given
    let homeBusinessLogicSpy = HomeBusinessLogicSpy()
    sut.interactor = homeBusinessLogicSpy
    loadView()
    
    // When
    sut.viewDidLoad()
    
    // Then
    XCTAssert(homeBusinessLogicSpy.getStatementListCalled, "Should get account statement when view loads")
  }
  
  func testShouldLogoutOnLogoutButtonTap() {
    // Given
    let homeBusinessLogicSpy = HomeBusinessLogicSpy()
    sut.interactor = homeBusinessLogicSpy
    loadView()
    
    // When
    sut.logoutBtnClicked(self)
    
    // Then
    XCTAssert(homeBusinessLogicSpy.logoutCalled, "Should logout when logout button is tapped")
  }
  
  func testNumberOfSectionsInTableViewShouldAlwaysBeOne() {
    // Given
    let homeBusinessLogicSpy = HomeBusinessLogicSpy()
    sut.interactor = homeBusinessLogicSpy
    loadView()
    let tableView: UITableView = sut.transactionsTableView
    
    // When
    let numberOfSections = sut.numberOfSections(in: tableView)
    
    // Then
    XCTAssertEqual(numberOfSections, 1, "The number of table view sections should always be 1")
  }
  
  func testNumberOfRowsInAnySectionShouldEqaulNumberOfStatementsToDisplay() {
    // Given
    let homeBusinessLogicSpy = HomeBusinessLogicSpy()
    sut.interactor = homeBusinessLogicSpy
    loadView()
    let tableView: UITableView = sut.transactionsTableView
    let testDisplayedStatements = [Seeds.Transactions.Statement1,Seeds.Transactions.Statement2,Seeds.Transactions.Statement3]
    sut.statementList = testDisplayedStatements
    
    // When
    let numberOfRows = sut.tableView(tableView, numberOfRowsInSection: 0)
    
    // Then
    XCTAssertEqual(numberOfRows, testDisplayedStatements.count, "The number of table view rows should equal the number of Transactions to display")
  }
  
  func testShouldConfigureTableViewCellToDisplayStatements() {
    // Given
    let homeBusinessLogicSpy = HomeBusinessLogicSpy()
    sut.interactor = homeBusinessLogicSpy
    loadView()
    let tableView: UITableView = sut.transactionsTableView
    let testDisplayedStatements = [Seeds.FormattedTransactions.Statement1,Seeds.FormattedTransactions.Statement2,Seeds.FormattedTransactions.Statement3]
    sut.statementList = testDisplayedStatements
    
    // When
    let indexPath = IndexPath(row: 0, section: 0)
    let cell = sut.tableView(tableView, cellForRowAt: indexPath) as! TransactionTableViewCell
    
    // Then
    XCTAssertEqual(cell.titleLabel?.text, "Pagamento", "A properly configured table view cell should display the proper title")
    XCTAssertEqual(cell.descriptionLabel?.text, "Conta de luz", "A properly configured table view cell should display the proper description")
    XCTAssertEqual(cell.dateLabel?.text, "08/15/2018", "A properly configured table view cell should display the proper date")
    XCTAssertEqual(cell.valueLabel?.text, "R$"+"-50.0", "A properly configured table view cell should display the proper description")
  }
  
}
