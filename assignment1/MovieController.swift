//
//  MovieViewController.swift
//  assignment1
//
//  Created by Dan Schultz on 9/14/14.
//  Copyright (c) 2014 Dan Schultz. All rights reserved.
//

import UIKit

class MovieController: UIViewController {
    
    var movie: NSDictionary!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewContent: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var synopsisText: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var title = movie["title"] as NSString
        titleLabel.text = title
        navigationItem.title = title
        
        var rating = movie["mpaa_rating"] as NSString
        ratingLabel.text = "Rated \(rating)"
        
        synopsisText.text = movie["synopsis"] as NSString
        
        var posters = movie["posters"] as NSDictionary
        var posterUrlString = (posters["original"] as NSString).stringByReplacingOccurrencesOfString("tmb.jpg", withString: "det.jpg")
        posterImage.setImageWithURL(NSURL(string: posterUrlString))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        synopsisText.sizeToFit()
        
        var totalHeight = CGRectUnion(titleLabel.frame, CGRectUnion(ratingLabel.frame, synopsisText.frame)).height + scrollViewContent.frame.origin.y + 48
        var scrollViewContentFrame = scrollViewContent.frame
        scrollViewContentFrame.size.height = totalHeight
        scrollViewContent.frame = scrollViewContentFrame
        
        scrollView.contentSize = scrollViewContentFrame.size
    }

}
