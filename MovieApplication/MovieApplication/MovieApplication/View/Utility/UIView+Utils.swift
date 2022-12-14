//
//  UIView+Utils.swift
//  MovieApplication
//
//  Created by Fabian Cooper on 6/30/20.
//  Copyright © 2020 Fabian Cooper. All rights reserved.
//

import UIKit

extension UIView {

    convenience init(bufferAxis: NSLayoutConstraint.Axis) {
        self.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setContentHuggingPriority(.defaultLow, for: bufferAxis)
        self.setContentCompressionResistancePriority(.defaultLow, for: bufferAxis)
    }
    
    func boundToSuperView(inset: CGFloat) {
        guard let superview = self.superview else {
            print("You forgot to add the view to the hierarchy")
            return
        }
        
        self.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor,
                                  constant: inset).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor,
                                     constant: -inset).isActive = true
        self.leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor,
                                      constant: inset).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor,
                                       constant: -inset).isActive = true
    }
}
