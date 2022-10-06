//
//  MovieService.swift
//  MovieApplication
//
//  Created by Fabian Cooper on 6/30/20.
//  Copyright © 2020 Fabian Cooper. All rights reserved.
//

import Foundation

class MovieService {
    
    var session: Session
    
    init(session: Session = URLSession.shared) {
        self.session = session
    }
    
}

extension MovieService: ServiceType {
    // https://api.themoviedb.org/3/movie/popular?api_key=705f7bed4894d3adc718c699a8ca9a4f&page=1
    // https://api.themoviedb.org/3/movie/?popular?api_key=705f7bed4894d3adc718c699a8ca9a4f&page=1
    
    func fetch<T: Decodable>(url: URL?, completion: @escaping (Result<T, Error>) -> ()) {
        
        guard let url = url else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        self.session.callNetwork(with: url) { (data, response, error) in
            
            var jsonData = Data()
            
            do {
                jsonData = try self.performErrorChecking(data, response, error).get()
            } catch {
                completion(.failure(error))
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: jsonData)
                completion(.success(result))
            } catch {
                print(error)
                completion(.failure(NetworkError.decodeFailure))
            }
        }
    }
    
    func fetch(url: URL?, completion: @escaping ImageHandler) {
        
        guard let url = url else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        self.session.callNetwork(with: url) { (data, response, error) in
            
            do {
                let data = try self.performErrorChecking(data, response, error).get()
                completion(.success(data))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
//    private func retry<T>(_ attempts: Int, task: @escaping (_ completion:@escaping (Result<T, Error>) -> Void) -> Void,  completion:@escaping (Result<T, Error>) -> Void) {
//
//        task({ result in
//            switch result {
//            case .success(_):
//                completion(result)
//            case .failure(let error):
//                print("retries left \(attempts) and error = \(error)")
//                if attempts > 1 {
//                    self.retry(attempts - 1, task: task, completion: completion)
//                } else {
//                    completion(result)
//                }
//            }
//        })
//    }
    
    private func performErrorChecking(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Result<Data, Error> {
        if let error = error {
            return .failure(error)
        }
        
        if let httpResponse = response as? HTTPURLResponse, !(200..<300).contains(httpResponse.statusCode) {
            return .failure(NetworkError.badStatusCode(httpResponse.statusCode))
        }
        
        guard let data = data else {
            return .failure(NetworkError.badData)
        }
        
        return .success(data)
    }
    
}
