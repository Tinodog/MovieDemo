//
//  MovieViewModel.swift
//  MovieApplication
//
//  Created by Fabian Cooper on 8/27/20.
//  Copyright © 2020 Fabian Cooper. All rights reserved.
//

import UIKit

class MovieViewModel: ViewModelType {
    
    private var state: ViewModelState
    private var currentPage: PageResult?
    internal var movies: [Movie] = [] {
        didSet {
            guard oldValue.count != self.movies.count else { return }
            self.update?()
        }
    }
        
    internal var service: ServiceType
    internal var imageCache: ImageCache
    private var update: (() -> ())?
    private var errorUpdate: ((Error) -> ())?
    
    init(state: ViewModelState, service: ServiceType = MovieService(), cache: ImageCache = ImageCache.sharedCache) {
        self.state = state
        self.service = service
        self.imageCache = cache
    }
    
    func bind(uiHandler: @escaping () -> (), errorHandler: @escaping (Error) -> ()) {
        self.update = uiHandler
        self.errorUpdate = errorHandler
    }
    
    func fetchMovies(refresh: Bool = false) {
        
        var url: URL?
        if self.state == .popular {
            let pageNum = (refresh) ? 1 : (self.currentPage?.page ?? 0) + 1
            guard pageNum <= self.currentPage?.totalPages ?? 1 else { return }
            url = MovieServiceRequest.popularMovies(pageNum).url
        } else {
            url = MovieServiceRequest.nowPlayingMovies.url
        }
        
        self.service.fetch(url: url) { [weak self] (result: Result<PageResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let page):
//                if refresh {
//                    self.movies = page.results
//                } else {
//                    self.movies.append(contentsOf: page.results)
//                }
                self.fetchImages(for: page, isRefresh: refresh)
            case .failure(let error):
                print(error.localizedDescription)
                self.errorUpdate?(error)
            }
        }
    }
    
    private func fetchImages(for page: PageResult, isRefresh: Bool) {
        let group = DispatchGroup()
        page.results.forEach { (movie) in
            group.enter()
            self.fetchImageToCache(for: movie.posterImage) {
                group.leave()
            }
        }
        group.notify(queue: DispatchQueue.global()) {
            if isRefresh { self.movies = [] }
            self.movies.append(contentsOf: page.results)
            self.currentPage = page
        }
    }

    private func fetchImageToCache(for posterPath: String, completion: @escaping () -> ()) {
        let url = MovieServiceRequest.movieImage(posterPath).url
        self.service.fetch(url: url) { (result) in
            switch result {
            case .success(let data):
                guard let urlString = url?.absoluteString else {
                    completion()
                    return
                }
                self.imageCache.set(data: data, url: urlString)
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                completion()
            }
        }
    }
//    func fetchImage(index: Int, completion: @escaping (Data?) -> ()) {
//        guard index < self.movies.count else { return }
//        let posterPath = self.movies[index].posterImage
//        if let imageData = self.imageCache.get(url: posterPath) {
//            completion(imageData)
//            return
//        }
//
//        let url = MovieServiceRequest.movieImage(posterPath).url
//        self.service.fetch(url: url) { (result) in
//            switch result {
//            case .success(let data):
//                completion(data)
//            case .failure(let error):
//                print(error)
//                completion(nil)
//            }
//        }
//
//    }
    
    func fetchIndividualFilm(index: Int, completion: @escaping () -> ()) {
        if let _ = self.movies[index].duration {
            completion()
            return
        }
        let url = MovieServiceRequest.individualMovie(self.movies[index].id).url
        
        self.service.fetch(url: url) { [weak self] (result: Result<Movie, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let movie):
                self.movies[index] = movie
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                self.errorUpdate?(error)
            }
        }
    }
    
//    func fetchMovieVid(index: Int, completion: @escaping () -> ()) {
//        let videoKey = self.movies[0].videos?.results[index].key ?? ""
//        let url = MovieServiceRequest.youtubeVideo(videoKey).url
//        
//        self.service.fetch(url: url) { (result: ) in
//            switch result {
//            case .success(<#T##Data?#>)
//            }
//        }
//        
//    }
}
