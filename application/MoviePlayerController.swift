//
//  MoviePlayerController.swift
//  reddift
//
//  Created by sonson on 2016/10/22.
//  Copyright © 2016年 sonson. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation

class MoviePlayerController: ImageViewController {
    let movieView: MoviePlayView
    let movieURL: URL
    
    @objc func didChangeStatus(notification: Notification) {
        var f = movieView.frame
        f.size = movieView.presentationSize
        movieView.frame = f
        updateImageCenter()
        
        let boundsSize = self.view.bounds
        var frameToCenter = movieView.frame
        
        let ratio = movieView.presentationSize.width / movieView.presentationSize.height
        
        var contentSize = CGSize.zero
        
        if ratio > 1 {
            contentSize = CGSize(width: boundsSize.width, height: boundsSize.height / ratio)
        } else {
            contentSize = CGSize(width: boundsSize.height * ratio, height: boundsSize.height)
        }
        
        frameToCenter.size = contentSize
        var f2 = mainImageView.bounds
        f2.origin = CGPoint.zero
        movieView.frame = f2
        
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        movieView.playerLayer.player?.play()
    }
    
    override func viewDidLoad() {
        print("MovieViewController - viewDidLoad")
        super.viewDidLoad()
        mainImageView.addSubview(movieView)
        NotificationCenter.default.addObserver(self, selector: #selector(MoviePlayerController.didChangeStatus(notification:)), name: MoviePlayViewDidChangeStatus, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        movieURL = URL(string: "")!
        movieView = MoviePlayView(url: movieURL)
        super.init(coder: aDecoder)
    }
    
    override init(index: Int, thumbnails: [Thumbnail], isOpenedBy3DTouch: Bool = false) {
        let thumbnail = thumbnails[index]
        switch thumbnail {
        case .Image:
            movieURL = URL(string: "")!
        case .Movie(let movieURL, _, _):
            self.movieURL = movieURL
        }
        movieView = MoviePlayView(url: movieURL)
        super.init(index: index, thumbnails: thumbnails, isOpenedBy3DTouch: isOpenedBy3DTouch)
    }
}
