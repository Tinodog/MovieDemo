//
//  MovieListViewController.swift
//  MovieApplication
//
//  Created by Fabian Cooper on 6/30/20.
//  Copyright © 2020 Fabian Cooper. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController {
    
    var movieViewModel: ViewModelType
    var tableView: UITableView?
    
    init(popViewModel: ViewModelType = MovieViewModel(state: .popular)) {
        self.movieViewModel = popViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("This shouldn't happen")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
        
        self.movieViewModel.bind(uiHandler: {
            DispatchQueue.main.async {
                self.tableView?.reloadData()
                // End refreshing if manual refresh
                self.tableView?.refreshControl?.endRefreshing()
            }
        }) { (error) in
            DispatchQueue.main.async {
//                self.presentErrorAlertController(for: error)
                self.presentErrorRetryAlertController(for: error, viewModel: self.movieViewModel)
            }
        }
            
        self.navigationItem.title = "MOVIES"
        self.navigationController?.navigationBar.backgroundColor = .black
        
        let button = UIBarButtonItem(title: "Test", style: .done, target: self, action: #selector(self.navigateToTest))
        self.navigationItem.setRightBarButton(button, animated: false)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshContent(sender: self.tableView?.refreshControl)
    }
    
    @objc
    func refreshContent(sender: UIRefreshControl?) {
        self.tableView?.refreshControl?.tintColor = .white
        self.tableView?.refreshControl?.attributedTitle = NSAttributedString(string: "Loading...", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        self.tableView?.setContentOffset(CGPoint(x: 0, y: -(self.tableView?.refreshControl?.frame.height)!), animated: true)
        self.tableView?.refreshControl?.layoutIfNeeded()
        self.tableView?.refreshControl?.beginRefreshing()
        self.movieViewModel.fetchMovies(refresh: true)
    }
    
    @objc
    func navigateToTest() {
        let vc = AVTestViewController()
        vc.viewModel = self.movieViewModel
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setUpTableView() {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
        tableView.register(NowPlayingCell.self, forCellReuseIdentifier: NowPlayingCell.reuseIdentifier)
        tableView.register(PopularMovieCell.self, forCellReuseIdentifier: PopularMovieCell.reuseIdentifier)
        
        self.view.addSubview(tableView)
        tableView.boundToSuperView(inset: 0)
        self.tableView = tableView
        
        let refreshControl = UIRefreshControl()
        self.tableView?.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.refreshContent(sender:)), for: .valueChanged)
    }
    
}
