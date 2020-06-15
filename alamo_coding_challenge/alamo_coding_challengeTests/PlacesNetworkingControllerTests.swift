//
//  PlacesNetworkingControllerTests.swift
//  alamo_coding_challengeTests
//
//  Created by Cameron Eubank on 6/15/20.
//  Copyright © 2020 Cameron Eubank. All rights reserved.
//

import Foundation
import XCTest
@testable import alamo_coding_challenge

final class PlacesNetworkingControllerTests: XCTestCase {
    
    private enum TestError: Error {
        case generic
    }
    
    private var controller: PlacesNetworkingController!
    
    func test_getPlacesCompletionProvidesError_whenRequestFails() {
        let expectation = XCTestExpectation(description: "getPlaces(keyword:completion:) completion should provide error")
        var sut: Error?
        setupController(with: .error(TestError.generic))
        controller.getPlaces(keyword: "Alamo Drafthouse") { result in
            defer {
                expectation.fulfill()
            }
            switch result {
            case .success:
                XCTFail("Expected failure but succeeded instead.")
            case .failure(let error):
                sut = error
            }
        }
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(sut)
    }
    
    func test_getPlacesCompletionProvidesError_whenRequestSucceeds_andResponseCantBeDecoded() {
        let expectation = XCTestExpectation(description: "getPlaces(keyword:completion:) completion should provide error")
        var sut: Error?
        setupController(with: .mock(stubFileName: "NonDecodablePlacesResponseStub"))
        controller.getPlaces(keyword: "Alamo Drafthouse") { result in
            defer {
                expectation.fulfill()
            }
            switch result {
            case .success:
                XCTFail("Expected failure but succeeded instead.")
            case .failure(let error):
                sut = error
            }
        }
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(sut)
    }
    
    func test_getPlacesCompletionProvidesPlaces_whenRequestSucceeds() {
        let expectation = XCTestExpectation(description: "getPlaces(keyword:completion:) completion should provide places")
        var sut: [Place]?
        setupController(with: .mock(stubFileName: "PlacesResponseStub"))
        controller.getPlaces(keyword: "Alamo Drafthouse") { result in
            defer {
                expectation.fulfill()
            }
            switch result {
            case .success(let places):
                sut = places
            case .failure:
                XCTFail("Expected success but failed instead.")
            }
        }
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(sut)
        XCTAssertFalse(sut?.isEmpty ?? true)
    }
    
    private func setupController(with configuration: MockURLProtocol.Configuration) {
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        MockURLProtocol.configuration = configuration
        sessionConfiguration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: sessionConfiguration)
        controller = PlacesNetworkingController(urlSession: session)
    }
}
