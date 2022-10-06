//
//  ImageCollectionCell.swift
//  MovieApplication
//
//  Created by Fabian Cooper on 7/1/20.
//  Copyright © 2020 Fabian Cooper. All rights reserved.
//

import UIKit

class ImageCollectionCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ImageCollectionCell"
    
    var imageView: LoadableImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addImageView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addImageView()
    }
    
    private func addImageView() {
        let imageView = LoadableImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        imageView.boundToSuperView(inset: 0)
        self.imageView = imageView
    }
}
