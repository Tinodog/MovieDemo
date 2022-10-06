//
//  LoadableImageView.swift
//  MovieApplication
//
//  Created by Fabian Cooper on 4/10/21.
//  Copyright © 2021 Fabian Cooper. All rights reserved.
//

import UIKit

class LoadableImageView: UIImageView {

    var activityIndicator: UIActivityIndicatorView {
        let activity = UIActivityIndicatorView()
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.color = .white
        activity.hidesWhenStopped = true
        self.addSubview(activity)
        activity.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activity.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        return activity
    }
    
    // Needs to callNetwork from here or via a VM
    func loadImage(with url: URL) {
        
    }

}
