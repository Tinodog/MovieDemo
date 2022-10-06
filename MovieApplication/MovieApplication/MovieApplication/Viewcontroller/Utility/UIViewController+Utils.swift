//
//  UIViewController+Utils.swift
//  MovieApplication
//
//  Created by Fabian Cooper on 7/14/20.
//  Copyright © 2020 Fabian Cooper. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentErrorAlertController(for error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(dismiss)
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentErrorRetryAlertController(for error: Error, viewModel: ViewModelType) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        let retry = UIAlertAction(title: "Retry", style: .default) { (_) in
            viewModel.fetchMovies(refresh: false)
        }
        alert.addAction(dismiss)
        alert.addAction(retry)
        self.present(alert, animated: true, completion: nil)
    }
    
}
