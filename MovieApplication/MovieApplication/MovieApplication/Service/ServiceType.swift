//
//  ServiceType.swift
//  MovieApplication
//
//  Created by Fabian Cooper on 7/1/20.
//  Copyright © 2020 Fabian Cooper. All rights reserved.
//

import Foundation

typealias ImageHandler = (Result<Data, Error>) -> ()

protocol ServiceType {
    func fetch<T: Decodable>(url: URL?, completion: @escaping (Result<T, Error>) -> ())
    func fetch(url: URL?, completion: @escaping ImageHandler)
}
