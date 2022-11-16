//
//  NetworkManager.swift
//  20221116-DuaneStrothers-NYCSchools
//
//  Created by Duane Strothers on 11/16/22.
//

import Foundation

protocol DataFetcher {
    func fetchModel<T: Decodable>(url: URL?, completion: @escaping (Result<T, Error>) -> Void)
    func fetchData(url: URL?, completion: @escaping (Result<Data, Error>) -> Void)
}

//manager will gather JSON data
class NetworkManager {
    
    let session: Session
    
    init(session: Session = URLSession.shared) {
        self.session = session
    }
    
}

extension NetworkManager: DataFetcher {
// general fetching using generic
    func fetchModel<T: Decodable>(url: URL?, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = url else {
            completion(.failure(NetworkError.badURL))
            return
        }
        self.session.getData(url: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.badData))
                return
            }
            do {
                let model = try JSONDecoder().decode(T.self, from: data)
                completion(.success(model))
            } catch {
                completion(.failure(NetworkError.decodeError(error.localizedDescription)))
            }
        }
    }
    func fetchData(url: URL?, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = url else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        self.session.getData(url: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.badData))
                return
            }
            completion(.success(data))
        }
    }
}
