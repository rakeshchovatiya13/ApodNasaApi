//
//  ApodViewControllerTest.swift
//  NasaAPODTests
//
//  Created by Rakesh Macbook on 31/01/22.
//

import XCTest
@testable import NasaAPOD

class ApodViewControllerTest: XCTestCase
{
    var testInstance: ApodViewController!
    
    override func setUp()
    {
        NetworkConfig.setAppMode(mode: .mock)
        
        testInstance = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "ApodViewController") as? ApodViewController
        
        testInstance.loadView()
        testInstance.viewDidLoad()
    }
    
    func testHasATableView()
    {
        XCTAssertNotNil(testInstance.tableView)
    }
    
    func testTableViewHasDelegate()
    {
        XCTAssertNotNil(testInstance.tableView.delegate)
    }
    
    func testTableViewHasDataSource()
    {
        XCTAssertNotNil(testInstance.tableView.dataSource)
    }
    
    func testTableViewConfromsToTableViewDelegateProtocol()
    {
        XCTAssertTrue(testInstance.conforms(to: UITableViewDelegate.self))
    }
    
    func testTableViewConformsToTableViewDataSourceProtocol()
    {
        XCTAssertTrue(testInstance.conforms(to: UITableViewDataSource.self))
        XCTAssertTrue(testInstance.responds(to: #selector(testInstance.tableView(_:numberOfRowsInSection:))))
        XCTAssertTrue(testInstance.responds(to: #selector(testInstance.tableView(_:cellForRowAt:))))
    }
}
