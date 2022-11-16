//
//  URLSession.swift
//  20221116-DuaneStrothers-NYCSchools
//
//  Created by Duane Strothers on 11/16/22.
//
import Foundation

protocol Session {
    func getData(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

extension URLSession: Session {
    
    func getData(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.dataTask(with: url) { data, response, error in
            completion(data, response, error)
        }.resume()
        
    }
    
}
