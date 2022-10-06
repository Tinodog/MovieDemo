//
//  URLSession+Utils.swift
//  MovieApplication
//
//  Created by Fabian Cooper on 12/17/20.
//  Copyright © 2020 Fabian Cooper. All rights reserved.
//

import Foundation

protocol Session {
    func callNetwork(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ())
}

extension URLSession: Session {
    
    func callNetwork(with url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        self.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            completion(data, response, error)
        }.resume()
    }
    
}
