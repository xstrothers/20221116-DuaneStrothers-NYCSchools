//
//  MockURLSession.swift
//  20221116-DuaneStrothers-NYCSchoolsTests
//
//  Created by Duane Strothers on 11/16/22.
//


import Foundation
@testable import _0221116_DuaneStrothers_NYCSchools

class MockURLSession: Session {
    
    func getData(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        // Success
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            
            if url.absoluteString.contains("success") {
                let bundle = Bundle(for: MockURLSession.self)
                guard let path = bundle.path(forResource: "SampleJSONData", ofType: "json") else {
                    fatalError("Failed to fetch sample payload")
                }
                let url = URL(fileURLWithPath: path)
                let data = try? Data(contentsOf: url)
                completion(data, nil, nil)
            } else if url.absoluteString.contains("generalError") {
                let error = NSError(domain: "Test", code: 0, userInfo: nil)
                completion(nil, nil, NetworkError.generalError(error))
            } else if url.absoluteString.contains("badData") {
                completion(nil, nil, nil)
            } else if  url.absoluteString.contains("decodeFailure") {
                completion(Data(), nil, nil)
            }
        }
        
        // Fail on general error
        // Fail on data being nil
        // Fail on decode
    }
}
