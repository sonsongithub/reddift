//
//  MoviePlayerViewToolbar.swift
//  reddift
//
//  Created by sonson on 2016/05/06.
//  Copyright © 2016年 sonson. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation

protocol MoviePlayerViewToolbarDelegate: class {
    func didTapPlayButtonOnMoviePlayerViewToolbar(toolbar: MoviePlayerViewToolbar)
    func didTapPauseButtonOnMoviePlayerViewToolbar(toolbar: MoviePlayerViewToolbar)
    func didSeekSliderOnMoviePlayerViewToolbar(toolbar: MoviePlayerViewToolbar, t: CMTime)
}

class MoviePlayerViewToolbar: UIToolbar {
    let slider = UISlider(frame: CGRect(x: 0, y: 0, width: 180, height: 44))
    let timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 44))
    var sliderBarItem: UIBarButtonItem?
    var playButtonBarItem: UIBarButtonItem?
    var pausebuttonBarItem: UIBarButtonItem?
    var timeLabelItem: UIBarButtonItem?
    var sliderWidthConstraint: NSLayoutConstraint?
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
    
    weak var toolbarDelegate: MoviePlayerViewToolbarDelegate?
    var movieDuration: CMTime = CMTime(seconds: 0, preferredTimescale: 300)
    
    deinit {
        print("deinit MoviePlayerViewToolbar")
    }
    
    func prapareItems() {
        /// slider setup
        slider.addTarget(self, action: #selector(MoviePlayerViewToolbar.didTouchUpInside(sender:)), for: .touchUpInside)
        slider.addTarget(self, action: #selector(MoviePlayerViewToolbar.didTouchDown(sender:)), for: .touchDown)
        slider.addTarget(self, action: #selector(MoviePlayerViewToolbar.draggingInside(sender:)), for: .touchDragInside)
        
        /// bar button item setup
        sliderBarItem = UIBarButtonItem(customView: slider)
        playButtonBarItem = UIBarButtonItem(barButtonSystemItem: .play, target: self, action: #selector(MoviePlayerViewToolbar.play(sender:)))
        pausebuttonBarItem = UIBarButtonItem(barButtonSystemItem: .pause, target: self, action: #selector(MoviePlayerViewToolbar.pause(sender:)))
        timeLabelItem = UIBarButtonItem(customView: timeLabel)
        
        /// bar button item width
        sliderBarItem?.width = 180
        playButtonBarItem?.width = 40
        pausebuttonBarItem?.width = 40
        fixedSpace.width = 6
        
        /// label attributes
        timeLabel.text = "000:00"
        timeLabel.textAlignment = .center
        
        layoutBarButtonItems()
    }
    
    func layoutBarButtonItems() {
        /// time label
        let backup = timeLabel.text
        timeLabel.text = "444:44"
        let max = CGFloat.greatestFiniteMagnitude
        let timeLabelBound = timeLabel.textRect(forBounds: CGRect(x: 0, y: 0, width: max, height: max), limitedToNumberOfLines: 1)
        timeLabelItem?.width = timeLabelBound.size.width
        var labelFrame = timeLabel.frame
        labelFrame.size.width = timeLabelBound.size.width
        timeLabel.frame = labelFrame
        timeLabel.text = backup
        
        // slider
        let sliderWidth = self.frame.size.width - 12 - timeLabelBound.size.width - 92
        sliderBarItem?.width = sliderWidth
        var sliderFrame = slider.frame
        sliderFrame.size.width = sliderWidth
        slider.frame = sliderFrame
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutBarButtonItems()
    }
    
    var internalDuration: CMTime = CMTime(seconds: 0, preferredTimescale: 0)
    
    var duration: CMTime {
        set {
            internalDuration = newValue
            slider.minimumValue = 0
            slider.maximumValue = Float(internalDuration.seconds)
        }
        get {
            return internalDuration
        }
    }
    
    var enable: Bool {
        set {
            if let items = self.items {
                items.forEach({ $0.isEnabled = newValue })
            }
        }
        get {
            guard let items = self.items else { return false }
            return items.reduce(true, { $0 && $1.isEnabled })
        }
    }
    
    func toggleToPauseButton() {
        if let sb = sliderBarItem, let _ = playButtonBarItem, let ps = pausebuttonBarItem, let ti = timeLabelItem {
            let b = [fixedSpace, ps, flexibleSpace, sb, flexibleSpace, ti, fixedSpace]
            setItems(b, animated: true)
        }
    }
    
    func toggleToPlayButton() {
        if let sb = sliderBarItem, let pb = playButtonBarItem, let _ = pausebuttonBarItem, let ti = timeLabelItem {
            let b = [fixedSpace, pb, flexibleSpace, sb, flexibleSpace, ti, fixedSpace]
            setItems(b, animated: true)
        }
    }
    
    func updateToolbarWithCurrentTime(currentTime: CMTime) {
        let all_seconds = Int(CMTimeGetSeconds(currentTime))
        slider.value = Float(all_seconds)
        let min = all_seconds / 60
        let sec = all_seconds % 60
        timeLabel.text = String(format: "%02d:%02d", min, sec)
    }
    
    // Delegate method push the play button on the toolbar
    @objc func play(sender: AnyObject) {
        if let del = toolbarDelegate {
            del.didTapPlayButtonOnMoviePlayerViewToolbar(toolbar: self)
            toggleToPauseButton()
        }
    }
    
    // Delegate method push the pause button on the toolbar
    @objc func pause(sender: AnyObject) {
        if let del = toolbarDelegate {
            del.didTapPauseButtonOnMoviePlayerViewToolbar(toolbar: self)
            toggleToPlayButton()
        }
    }
    
    // Delegate method push the slider on the toolbar
    @objc func didTouchUpInside(sender: AnyObject) {
        print("didTouchUpInside:")
        
        let t = CMTime(value: Int64(slider.value * Float(duration.timescale)), timescale: duration.timescale)
        
        if let del = toolbarDelegate {
            del.didSeekSliderOnMoviePlayerViewToolbar(toolbar: self, t: t)
            toggleToPauseButton()
        }
    }
    
    @objc func didTouchDown(sender: AnyObject) {
        print("didTouchDown:")
        if let del = toolbarDelegate {
            del.didTapPauseButtonOnMoviePlayerViewToolbar(toolbar: self)
            toggleToPlayButton()
        }
    }
    
    @objc func draggingInside(sender: AnyObject) {
        print("draggingInside:")
        let seconds = Int(slider.value)
        let min = seconds / 60
        let sec = seconds % 60
        timeLabel.text = String(format: "%02d:%02d", min, sec)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prapareItems()
        toggleToPlayButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
