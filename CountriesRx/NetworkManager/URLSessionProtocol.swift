//
//  URLSessionProtocol.swift
//  CountriesRx
//
//  Created by Guy Twig on 07/08/2024.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @Sendable @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

class MockURLSessionDataTask: URLSessionDataTask {
    var resumeWasCalled = false
    var cancelWasCalled = false
    
    override func resume() {
        resumeWasCalled = true
    }

    override func cancel() {
        cancelWasCalled = true
    }
}

class MockURLSession: URLSessionProtocol {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let task = MockURLSessionDataTask()
        DispatchQueue.global().async {
            completionHandler(self.data, self.response, self.error)
        }
        return task
    }
}
