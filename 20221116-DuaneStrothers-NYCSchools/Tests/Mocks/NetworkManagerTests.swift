//
//  NetworkManagerTests.swift
//  20221116-DuaneStrothers-NYCSchoolsTests
//
//  Created by Duane Strothers on 11/16/22.
//


import XCTest
@testable import _0221116_DuaneStrothers_NYCSchools

class NetworkManagerTests: XCTestCase {

    var networkManager: NetworkManager?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        self.networkManager = NetworkManager(session: MockURLSession())
    }

    override func tearDownWithError() throws {
        self.networkManager = nil
        try super.tearDownWithError()
    }
    
    func testSuccessfullyFetchDecodableData() {
        // Arrange
        let expectation = XCTestExpectation(description: "Successfully fetching the model data")
        let url = URL(string: "https://data.cityofnewyork.us/resource/f9bf-2cp4.json")
        var schools: [SchoolInformation] = []
        
        // Act
        self.networkManager?.fetchModel(url: url, completion: { (result: Result<[SchoolInformation], Error>) in
            switch result {
            case .success(let page):
                schools = page
                expectation.fulfill()
            case .failure(let err):
                XCTFail("Failed to decode the model. Got Error: \(err)")
            }
        })
        wait(for: [expectation], timeout: 3)
        
        // Assert
        XCTAssertEqual(schools.count, 956)
        XCTAssertEqual(schools.first?.schoolName, "HENRY STREET SCHOOL FOR INTERNATIONAL STUDIES")
    }
    
    func testFailedForBadURL() {
        // Arrange
        let expectation = XCTestExpectation(description: "URL Failed to be converted")
        var err: NetworkError?
    
        // Act
        self.networkManager?.fetchModel(url: nil, completion: { (result: Result<[SchoolInformation], Error>) in
            switch result {
            case .success:
                XCTFail("Failed at failing on URL")
            case .failure(let error):
                err = error as? NetworkError
                expectation.fulfill()
            }
        })
        wait(for: [expectation], timeout: 3)
        
        // Assert
        XCTAssertEqual(err, NetworkError.badURL)
    }
    
    func testFailedForGeneralError() {
        // Arrange
        let expectation = XCTestExpectation(description: "General Failure")
        let url = URL(string: "https://Example.com/generalError")
        var err: NetworkError?
    
        // Act
        self.networkManager?.fetchModel(url: url, completion: { (result: Result<[SchoolInformation], Error>) in
            switch result {
            case .success:
                XCTFail("Failed at getting general Error")
            case .failure(let error):
                err = error as? NetworkError
                expectation.fulfill()
            }
        })
        wait(for: [expectation], timeout: 3)
        
        // Assert
        let error = NSError(domain: "Test", code: 0, userInfo: nil)
        XCTAssertEqual(err, NetworkError.generalError(error))
    }
    
    func testFailedForBadData() {
        // Arrange
        let expectation = XCTestExpectation(description: "Bad Data Failure")
        let url = URL(string: "https://Example.com/badData")
        var err: NetworkError?
    
        // Act
        self.networkManager?.fetchModel(url: url, completion: { (result: Result<[SchoolInformation], Error>) in
            switch result {
            case .success:
                XCTFail("Failed at getting bad data")
            case .failure(let error):
                err = error as? NetworkError
                expectation.fulfill()
            }
        })
        wait(for: [expectation], timeout: 3)
        
        // Assert
        XCTAssertEqual(err, NetworkError.badData)
        
    }
    
    func testFailedForDecodeError() {
        // Arrange
        let expectation = XCTestExpectation(description: "Decode Failure")
        let url = URL(string: "https://Example.com/decodeFailure")
        var err: NetworkError?
    
        // Act
        self.networkManager?.fetchModel(url: url, completion: { (result: Result<[SchoolInformation], Error>) in
            switch result {
            case .success:
                XCTFail("Failed at failing to decode")
            case .failure(let error):
                err = error as? NetworkError
                expectation.fulfill()
            }
        })
        wait(for: [expectation], timeout: 3)
        
        // Assert
        XCTAssertEqual(err, NetworkError.decodeError("The data couldn’t be read because it isn’t in the correct format."))
        
    }

}
