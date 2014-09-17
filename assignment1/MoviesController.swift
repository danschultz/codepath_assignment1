//
//  ViewController.swift
//  assignment1
//
//  Created by Dan Schultz on 9/13/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import UIKit

class MoviesController: UITableViewController {
    
    var movies: [NSDictionary] = []
    
    var alertBanner: ALAlertBanner!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var headerTextColor = UIColor(
            red: CGFloat(240.0/255.0),
            green: CGFloat(209.0/255.0),
            blue: CGFloat(0.0/255.0),
            alpha: CGFloat(100.0))
        
        navigationController.navigationBar.barTintColor = UIColor.blackColor()
        navigationController.navigationBar.tintColor = headerTextColor
        navigationController.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : headerTextColor
        ]
        
        tableView.backgroundColor = UIColor.blackColor()
        tableView.separatorColor = UIColor.darkGrayColor()
        
        alertBanner = ALAlertBanner(
            forView: view,
            style: ALAlertBannerStyleFailure,
            position: ALAlertBannerPositionTop,
            title: "There was a problem loading the movies",
            subtitle: "Try checking your internet connection and try again")
        
        alertBanner.secondsToShow = 0
        alertBanner.bannerOpacity = 1
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.lightGrayColor()
        refreshControl.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        var hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "Loading"
        
        loadMovies() { (response, data, error) in
            hud.hide(true)
        }
    }
    
    func loadMovies(completion: ((NSURLResponse!, NSData!, NSError!) -> Void)!) {
        refreshControl.beginRefreshing()
        
        var moviesRequest = NSURLRequest(URL: NSURL.URLWithString("http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=6yqpnahy2v6dsbvdspzn2dz4&limit=30&country=us"))
        NSURLConnection.sendAsynchronousRequest(moviesRequest, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
            self.parseMoviesResponse(response, data: data, error: error)
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            
            if (error != nil) {
                self.alertBanner.show()
            }
            
            if (completion != nil) {
                completion(response, data, error)
            }
        }
    }
    
    func parseMoviesResponse(response: NSURLResponse, data: NSData, error: NSError?) {
        var errorValue: NSError? = nil
        var jsonData = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as NSDictionary
        movies = jsonData["movies"] as [NSDictionary]
    }
    
    func handleRefresh(sender: AnyObject) {
        loadMovies(nil)
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var movie = movies[indexPath.row] as NSDictionary
        var posters = movie["posters"] as NSDictionary
        
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as MovieTableViewCell
        cell.titleLabel.text = movie["title"] as NSString
        cell.ratingLabel.text = movie["mpaa_rating"] as NSString
        cell.synopsisLabel.text = movie["synopsis"] as NSString
        cell.posterImage.setImageWithURL(NSURL(string: posters["thumbnail"] as NSString))
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "moviesToMovie") {
            var selectedMovie = movies[tableView.indexPathForSelectedRow().row]
            var movieController = segue.destinationViewController as MovieController
            movieController.movie = selectedMovie
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

