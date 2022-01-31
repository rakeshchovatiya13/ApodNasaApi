//
//  ApodViewController.swift
//  NasaAPOD
//
//  Created by Rakesh Macbook on 27/01/22.
//

import UIKit

class ApodViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    
    /// Object of UISearchController
    var searchController = UISearchController()
    
    /// Object of `ApodVCModel` which is ViewModel of ApodViewController  to handle data and business logic
    let viewModel = ApodVCModel()
    
    /// This method is called after the view controller has loaded its view hierarchy into memory.
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        self.title = "Astronomy Picture of the Day"
        // Setup search controller for filter data based on date
        setupSearchController()
        // Fetch apod data from server to display on tableview
        viewModel.fetchApodList {
            self.tableView.reloadData()
        }
        
        // Add observer for enter into foreground
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.appEnteredFromBackground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
    }
}

/// Handle video player for play/pause
extension ApodViewController
{
    func pausePlayeVideos()
    {
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView)
    }
    
    @objc func appEnteredFromBackground()
    {
        ASVideoPlayerController.sharedVideoPlayer.pausePlayeVideosFor(tableView: tableView, appEnteredFromBackground: true)
    }
}

// MARK: Search Controller
extension ApodViewController: UISearchResultsUpdating
{
    /// Set up search controller with required attributes
    func setupSearchController()
    {
        searchController = UISearchController(searchResultsController: nil)
        // 1
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search Apod by date"
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
    }
    
    /// Returns true if searchbar has no text or its empty.
    var isSearchBarEmpty: Bool
    {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    /// Returns true if seachController is active and searchBar has a text.
    var isFiltering: Bool
    {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    /// Listener of searchcontroller on searchbar value change
    func updateSearchResults(for searchController: UISearchController)
    {
        let searchBar = searchController.searchBar
        viewModel.filterApodList(for: searchBar.text!)
        tableView.reloadData()
    }
}

// MARK: TableView Listeners
extension ApodViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel.getApodList(isFiltering: isFiltering).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if let cellData = viewModel.getApodList(isFiltering: isFiltering).item(at: indexPath.row)
        {
            switch cellData.media_type
            {
            case .image:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "ApodTableViewCell") as? ApodTableViewCell
                {
                    cell.indexpath = indexPath
                    cell.delegate = self
                    cell.configureCell(from: cellData)
                    return cell
                }
                
            case .video:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "ApodVideoTableViewCell") as? ApodVideoTableViewCell
                {
                    cell.indexpath = indexPath
                    cell.delegate = self
                    cell.configureCell(from: cellData)
                    return cell
                }
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        // Pause and remove video player layer from cell on didEndDisplaying.
        if let videoCell = cell as? ASAutoPlayVideoLayerContainer, let _ = videoCell.videoURL
        {
            ASVideoPlayerController.sharedVideoPlayer.removeLayerFor(cell: videoCell)
        }
    }
}

// MARK: ScrollView Listner

/// Handle pause/play on tableview scrollview scroll up/down
extension ApodViewController
{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        pausePlayeVideos()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        if !decelerate
        {
            pausePlayeVideos()
        }
    }
}

// MARK: ApodTableViewCellDelegate
extension ApodViewController: ApodTableViewCellDelegate
{
    // reloadRow(at indexpath) to refresh UI and contentsize of cell based on available content
    func reloadRow(at indexpath: IndexPath?)
    {
        if let indexPath = indexpath
        {
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [indexPath], with: .none)
            self.tableView.endUpdates()
        }
    }
}
