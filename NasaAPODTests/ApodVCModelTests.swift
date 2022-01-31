//
//  ApodVCModelTests.swift
//  NasaAPODTests
//
//  Created by Rakesh Macbook on 31/01/22.
//

import XCTest
@testable import NasaAPOD

class ApodVCModelTests: XCTestCase
{
    let model = ApodVCModel()
    
    override class func setUp()
    {
        NetworkConfig.setAppMode(mode: .mock)
    }
    
    func test_getApodData()
    {
        XCTAssertTrue(self.model.getApodList(isFiltering: false).count == 0)
        
        model.fetchApodList
        {
            XCTAssertNotNil(self.model.getApodList(isFiltering: false))
            XCTAssertTrue(self.model.getApodList(isFiltering: false).count > 0)
        }
    }
    
    func test_filterApodData()
    {
        model.fetchApodList {
            self.model.filterApodList(for: "2019")
            let filterData = self.model.getApodList(isFiltering: true)
            XCTAssertEqual(filterData.count, 1)
        }
    }
}
