//
//  PrivacyViewController.swift
//  MovieApplication
//
//  Created by Fabian Cooper on 4/10/21.
//  Copyright © 2021 Fabian Cooper. All rights reserved.
//

import UIKit

class PrivacyViewController: UIViewController {

    lazy var privacyLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = .white
        label.text = "No Movies\nFor You"
        
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black

        self.view.addSubview(self.privacyLabel)
        
        self.privacyLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.privacyLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    

}
