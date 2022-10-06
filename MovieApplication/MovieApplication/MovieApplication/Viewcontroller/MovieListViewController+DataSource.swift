//
//  MovieListViewController+DataSource.swift
//  MovieApplication
//
//  Created by Fabian Cooper on 7/1/20.
//  Copyright © 2020 Fabian Cooper. All rights reserved.
//

import UIKit

extension MovieListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section == 0) ? "Playing now" : "Most popular"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.section == 0) ? 150 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? 1 : self.movieViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NowPlayingCell.reuseIdentifier, for: indexPath) as? NowPlayingCell else {
                return UITableViewCell()
            }
            cell.setDelegate(delegate: self)
            cell.setViewModel(viewModel: MovieViewModel(state: .nowPlaying))
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PopularMovieCell.reuseIdentifier, for: indexPath) as? PopularMovieCell else {
                return UITableViewCell()
            }
            
            cell.titleLabel?.setAttrString(text: self.movieViewModel.title(index: indexPath.row), isBold: true)
            cell.releaseDateLabel?.setAttrString(text: self.movieViewModel.releaseDate(index: indexPath.row), isBold: false)
            cell.ratingView?.percentage = self.movieViewModel.rating(index: indexPath.row)
//            cell.moviePosterView?.image = nil
//            cell.moviePosterView?.activityIndicator.startAnimating()
//            self.movieViewModel.fetchImage(index: indexPath.row) { (data) in
//                if let data = data {
//                    DispatchQueue.main.async {
//                        cell.moviePosterView?.image = UIImage(data: data)
//                        cell.moviePosterView?.activityIndicator.isHidden = true
//                        cell.moviePosterView?.activityIndicator.stopAnimating()
//                    }
//                }
//            }
            cell.moviePosterView?.image = self.movieViewModel.image(index: indexPath.row)
            self.getDetails(cell: cell, index: indexPath.row)
            
            return cell
        }
    }
    
    private func getDetails(cell: PopularMovieCell, index: Int) {
        self.movieViewModel.fetchIndividualFilm(index: index) {
            DispatchQueue.main.async {
                cell.durationLabel?.setAttrString(text: self.movieViewModel.duration(index: index), isBold: false)
            }
        }
    }
}

extension MovieListViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let lastCellIndexPath = IndexPath(row: self.movieViewModel.count - 1, section: 1)
        guard indexPaths.contains(lastCellIndexPath) else { return }
        self.movieViewModel.fetchMovies(refresh: false)
    }
    
}
