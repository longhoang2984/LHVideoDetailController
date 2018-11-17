//
//  YoutubeViewController.swift
//  DraggableViewControllerDemo
//
//  Created by Long Hoàng on 11/17/18.
//  Copyright © 2018 Long Hoàng. All rights reserved.
//

import UIKit
import Foundation
import MediaPlayer
import LHVideoDetailController

class YoutubeViewController: LHVideoDetailController {
    private var moviePlayer: MPMoviePlayerController!
    private let loadingSpinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        moviePlayer = MPMoviePlayerController()
        
        self.setupViews(withVideoView: moviePlayer.view, videoViewHeight: 320)//, minimizeButton: minimizeButton)
        setupMoviePlayer()
        addObserver(selector: #selector(onOrientationChanged), name: NSNotification.Name.UIDeviceOrientationDidChange.rawValue)
        
        // design controller view
        let minimizeButton = UIButton()
        minimizeButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        minimizeButton.setImage(UIImage(named: "DownArrow"), for: .normal)
        minimizeButton.addTarget(self, action: #selector(onTapMinimizeButton), for: .touchUpInside)
        self.controllerView.addSubview(minimizeButton)
        let testControl = UILabel()
        testControl.frame = CGRect(x: 100, y: 5, width: 150, height: 40)
        testControl.text = "controller view"
        testControl.textColor = .white
        self.controllerView.addSubview(testControl)
        
        // design body view
        self.bodyView.backgroundColor = .white
        self.bodyView.layer.borderColor = UIColor.red.cgColor
        self.bodyView.layer.borderWidth = 10.0
        let testView = UILabel()
        testView.frame = CGRect(x: 20, y: 10, width: 100, height: 40)
        testView.text = "body view"
        testView.textColor = .red
        self.bodyView.addSubview(testView)
        
        // design message view
        self.messageView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        loadingSpinner.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        loadingSpinner.center = self.messageView.center
        loadingSpinner.hidesWhenStopped = false
        loadingSpinner.activityIndicatorViewStyle = .white
        self.messageView.addSubview(loadingSpinner)
    }
    
    override func didDisappear() {
        moviePlayer.pause()
        delegate?.removeController()
    }
    
    override func didReAppear() {
        setupMoviePlayer()
    }
    
    func stopVideo() {
        self.moviePlayer.stop()
    }
    
    func onTapButton() {
        print("onTapButton")
    }
    
    override func showMessageView() {
        loadingSpinner.startAnimating()
        super.showMessageView()
    }
    override func hideMessageView() {
        super.hideMessageView()
        loadingSpinner.stopAnimating()
    }
    
    override func didFullExpandByGesture() {
        UIApplication.shared.setStatusBarHidden(true, with: .none)
        showVideoControl()
    }
    override func didExpand() {
        print("didExpand")
        //        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        UIApplication.shared.setStatusBarHidden(true, with: .none)
        showVideoControl()
    }
    override func didMinimize() {
        print("didMinimized")
        hideVideoControl()
    }
    
    override func didStartMinimizeGesture() {
        print("didStartMinimizeGesture")
        UIApplication.shared.setStatusBarHidden(false, with: .none)
    }
    
    
    @objc func onTapMinimizeButton() {
        UIApplication.shared.setStatusBarHidden(false, with: .none)
        self.minimizeView()
    }
    
    // --------------------------------------------------------------------------------------------------
    
    func setupMoviePlayer() {
        // setupMovie
        let url = NSURL.fileURL(withPath: Bundle.main.path(forResource: "U23VN", ofType: "mp4")!)
        moviePlayer.contentURL = url
        moviePlayer.isFullscreen = false
        moviePlayer.controlStyle = .none
        moviePlayer.repeatMode = .none
        moviePlayer.prepareToPlay()
        
        // play
        let seconds = 1.0
        let delay = seconds * Double(NSEC_PER_SEC)// nanoseconds per seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.moviePlayer.play()
        }
        
        // for movie loop
        
        NotificationCenter.default.addObserver(self, selector: #selector(moviePlayBackDidFinish),
                                               name: NSNotification.Name.MPMoviePlayerPlaybackDidFinish,
                                               object: moviePlayer)
    }
    
    // movie loop
    @objc func moviePlayBackDidFinish(notification: NSNotification) {
        print("moviePlayBackDidFinish:")
        moviePlayer.play()
        removeObserver(aName: NSNotification.Name.MPMoviePlayerPlaybackDidFinish.rawValue)
    }
    
    
    
    
    // ----------------------------- events -----------------------------------------------
    
    // MARK: Orientation
    @objc func onOrientationChanged() {
        let orientation: UIInterfaceOrientation = getOrientation()
        
        switch orientation {
            
        case .portrait, .portraitUpsideDown:
            print("portrait")
            exitFullScreen()
            
        case .landscapeLeft, .landscapeRight:
            print("landscape")
            goFullScreen()
            
        default:
            print("no action for this orientation:" + orientation.rawValue.description)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    
    // --------------------------------- util ------------------------------------------
    
    // MARK: FullScreen Method
    func isFullScreen() -> Bool {
        //        println("isFullScreen: " + String(stringInterpolationSegment: moviePlayer.fullscreen))
        return moviePlayer.isFullscreen
    }
    func goFullScreen() {
        if !isFullScreen() {
            //            println("goFullScreen")
            moviePlayer.controlStyle = MPMovieControlStyle.fullscreen
            moviePlayer.isFullscreen = true
            addObserver(selector: #selector(willExitFullScreen), name: NSNotification.Name.MPMoviePlayerWillExitFullscreen.rawValue)
        }
    }
    func exitFullScreen() {
        if isFullScreen() {
            //            println("exit fullscreen");
            moviePlayer.isFullscreen = false
        }
    }
    @objc func willExitFullScreen() {
        //        println("willExitFullScreen")
        if isLandscape()
        {
            setOrientation(orientation: .portrait)
        }
        
        
        removeObserver(aName: NSNotification.Name.MPMoviePlayerWillExitFullscreen.rawValue)
    }
    
    
    // FIXIT: Don't work
    func showVideoControl() {
        //        println("showVideoControl");
        moviePlayer.controlStyle = .none
    }
    
    // FIXIT: Don't work
    func hideVideoControl() {
        //        println("hideVideoControl")
        moviePlayer.controlStyle = .none
    }
    
    
    
    
    //-----------------------------------------------------------------------------------
    
    func getOrientation() -> UIInterfaceOrientation {
        return UIApplication.shared.statusBarOrientation
    }
    
    func setOrientation(orientation: UIInterfaceOrientation) {
        let orientationNum: NSNumber = NSNumber(value: orientation.rawValue)
        UIDevice.current.setValue(orientationNum, forKey: "orientation")
    }
    
    func addObserver(selector aSelector: Selector, name aName: String) {
        NotificationCenter.default.addObserver(self, selector: aSelector, name:NSNotification.Name(aName), object: nil)
    }
    
    func removeObserver(aName: String) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(aName), object: nil)
    }
    
    func isLandscape() -> Bool {
        if UIApplication.shared.statusBarOrientation.isLandscape {
            return true
        }
        else {
            return false
        }
    }

}
