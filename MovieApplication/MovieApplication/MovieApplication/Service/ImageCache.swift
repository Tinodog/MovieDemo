//
//  ImageCache.swift
//  MovieApplication
//
//  Created by Fabian Cooper on 7/1/20.
//  Copyright © 2020 Fabian Cooper. All rights reserved.
//

import Foundation

class ImageCache {
    
    static let sharedCache = ImageCache()
    
    private let cache: NSCache<NSString, NSData>
    
    init(cache: NSCache<NSString, NSData> = NSCache<NSString, NSData>()) {
        self.cache = cache
    }
        
}

extension ImageCache {
    
    func set(data: Data, url: String) {
        let key = NSString(string: url)
        let object = NSData(data: data)
        self.cache.setObject(object, forKey: key)
    }
    
    func get(url: String) -> Data? {
        let key = NSString(string: url)
        guard let object = self.cache.object(forKey: key) else { return nil }
        return Data(referencing: object)
    }
    
}
