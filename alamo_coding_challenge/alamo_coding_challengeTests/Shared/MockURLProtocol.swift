//
//  MockURLProtocol.swift
//  alamo_coding_challengeTests
//
//  Created by Cameron Eubank on 6/15/20.
//  Copyright © 2020 Cameron Eubank. All rights reserved.
//

import Foundation

final class MockURLProtocol: URLProtocol {
    
    enum MockURLProtocolError: Error {
        case missingConfiguration
        case missingStubFile
    }
    
    enum Configuration {
        case error(Error)
        case mock(stubFileName: String)
    }
    
    static var configuration: Configuration?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let configuration = MockURLProtocol.configuration else {
            self.client?.urlProtocol(self, didFailWithError: MockURLProtocolError.missingConfiguration)
            self.client?.urlProtocolDidFinishLoading(self)
            return
        }
        
        switch configuration {
        case .mock(let stubFileName):
            guard let pathOfStubFile = Bundle(for: PlacesNetworkingControllerTests.self).path(forResource: stubFileName, ofType: "json"),
                  let data = try? Data(contentsOf: URL(fileURLWithPath: pathOfStubFile), options: .mappedIfSafe)
            else {
                self.client?.urlProtocol(self, didFailWithError: MockURLProtocolError.missingStubFile)
                self.client?.urlProtocolDidFinishLoading(self)
                return
            }
            self.client?.urlProtocol(self, didLoad: data)
        case .error(let error):
            self.client?.urlProtocol(self, didFailWithError: error)
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
