//
//  MoviePlayView.swift
//  reddift
//
//  Created by sonson on 2016/10/23.
//  Copyright © 2016年 sonson. All rights reserved.
//

import Foundation

import AVKit
import AVFoundation
import YouTubeGetVideoInfoAPIParser

let MoviePlayViewUpdateTime = Notification.Name(rawValue: "MoviePlayViewUpdateTime")
let MoviePlayViewDidChangeStatus = Notification.Name(rawValue: "MoviePlayViewDidChangeStatus")

func searchMp4(infos: [FormatStreamMap]) -> FormatStreamMap? {
    for info in infos {
        if let _ = info.type.range(of: "mp4") {
            return info
        }
        if let _ = info.type.range(of: "3gp") {
            return info
        }
    }
    return nil
}

class MoviePlayView: UIView {
    var videoTimeObserver: Any?
    let movieURL: URL
    var duration = CMTime()
    var presentationSize = CGSize.zero
    
    override class var layerClass: AnyClass {
        get {
            return AVPlayerLayer.self
        }
    }
    
    deinit {
        print("deinit MoviePlayerView")
        removeAllObserversFromPlayer()
    }
    
    func removeAllObserversFromPlayer() {
        if let player = playerLayer.player {
            if let ob = videoTimeObserver {
                player.removeTimeObserver(ob)
            }
            player.removeObserver(self, forKeyPath: "status")
        }
    }
    
    var playerLayer: AVPlayerLayer! {
        get {
            if let layer = self.layer as? AVPlayerLayer {
                return layer
            } else {
                return nil
            }
        }
    }
    
    /// Shared session configuration
    var sessionConfiguration: URLSessionConfiguration {
        get {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 30
            configuration.timeoutIntervalForResource = 30
            return configuration
        }
    }
    
    func startToLoadMovie() {
        if let youtubeContentID = movieURL.extractYouTubeContentID(),
            let infoURL = URL(string: "https://www.youtube.com/get_video_info?video_id=\(youtubeContentID)") {
            let request = URLRequest(url: infoURL)
            let session = URLSession(configuration: sessionConfiguration)
            print("Start loading metadata... \(infoURL.absoluteString)")
            let task = session.dataTask(with: request, completionHandler: { (data, _, error) -> Void in
                do {
                    guard let data = data else { throw NSError(domain: "", code: 0, userInfo: nil) }
                    guard let result = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String? else { throw NSError(domain: "", code: 0, userInfo: nil) }
                    let maps = try FormatStreamMapFromString(result)
                    guard let map = searchMp4(infos: maps) else { throw NSError(domain: "", code: 0, userInfo: nil) }
                    DispatchQueue.main.async { self.loadMovie(url: map.url) }
                } catch {
                    print("Failed parsing metadata... \(infoURL.absoluteString) - \(error)")
                    // handling error
                }
            })
            task.resume()
        } else {
            loadMovie(url: movieURL)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let player = playerLayer.player else { return }
        switch player.status {
        case .readyToPlay:
            Timer.scheduledTimer(timeInterval: TimeInterval(0.05), target: self, selector: #selector(MoviePlayView.waitForInitializingMovie(timer:)), userInfo: nil, repeats: true)
        case .failed:
            do {}
        case .unknown:
            do {}
        }
    }
    
    func loadMovie(url: URL) {
        let item = AVPlayerItem(url: url)
        let player = AVPlayer(playerItem: item)
        playerLayer.player = player
        
        print("Start loading movie... \(url.absoluteString)")
        playerLayer.player?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        
        if let currentItem = player.currentItem {
            duration = currentItem.asset.duration
        }
        videoTimeObserver = player.addPeriodicTimeObserver(
            forInterval: CMTimeMake(150, 600),
            queue: DispatchQueue.main) {
                (_) -> Void in
                let currentTime = player.currentTime()
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: MoviePlayViewUpdateTime, object: nil, userInfo: ["Time": currentTime])
                }
        }
    }
    
    @objc func waitForInitializingMovie(timer: Timer) {
        print(playerLayer.isReadyForDisplay)
        if let player = playerLayer.player, let item = player.currentItem {
            let s = item.presentationSize
            if s.width * s.height > 0 {
                self.presentationSize = item.presentationSize
                timer.invalidate()
                NotificationCenter.default.post(name: MoviePlayViewDidChangeStatus, object: nil, userInfo: nil)
                
            }
        }
    }
    
    init(url: URL) {
        movieURL = url
        super.init(frame: CGRect.zero)
        startToLoadMovie()
        self.backgroundColor = UIColor.black
    }
    
    required init?(coder: NSCoder) {
        movieURL = URL(string: "")!
        super.init(coder: coder)
        self.backgroundColor = UIColor.black
    }
}
