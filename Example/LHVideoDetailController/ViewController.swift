//
//  ViewController.swift
//  DraggableViewControllerDemo
//
//  Created by Long Hoàng on 11/17/18.
//  Copyright © 2018 Long Hoàng. All rights reserved.
//

import UIKit
import LHVideoDetailController

enum VideoType {
    case youtube
    case facebook
    case none
}

class ViewController: UIViewController, LHVideoDetailControllerDelegate {
    
    var videoType: VideoType = .none
    let buttonSize: CGSize = CGSize(width: 100, height: 40)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    fileprivate func getAppDelegate() -> AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let youtubeButton = UIButton(type: .system)
        youtubeButton.setTitle("Youtube", for: .normal)
        youtubeButton.addTarget(self, action: #selector(openYoutubePlayer), for: .touchUpInside)
        youtubeButton.center = CGPoint(x: view.center.x - buttonSize.width / 2, y: view.center.y - 40)
        youtubeButton.frame.size = buttonSize
        view.addSubview(youtubeButton)
        
        let facebookButton = UIButton(type: .system)
        facebookButton.setTitle("Facebook", for: .normal)
        facebookButton.addTarget(self, action: #selector(openFacebookPlayer), for: .touchUpInside)
        facebookButton.center = CGPoint(x: view.center.x - buttonSize.width / 2, y: view.center.y + 40)
        facebookButton.frame.size = buttonSize
        view.addSubview(facebookButton)
    }
    
    @objc func openYoutubePlayer() {
        let appDelegate = getAppDelegate()
        disposeYoutubeController()
        disposeFacebookController()
        appDelegate?.youtubePlayerViewController = YoutubeViewController()
        appDelegate?.youtubePlayerViewController?.delegate = self
        self.videoType = .youtube
        appDelegate?.youtubePlayerViewController?.show(isYoutubeType: true)
        
    }
    
    @objc func openFacebookPlayer() {
        let appDelegate = getAppDelegate()
        disposeYoutubeController()
        disposeFacebookController()
        appDelegate?.facebookPlayerViewController = FacebookViewController()
        appDelegate?.facebookPlayerViewController?.delegate = self
        self.videoType = .facebook
        appDelegate?.facebookPlayerViewController?.show(isYoutubeType: false)
    }
    
    func removeController() {
        let appDelegate = getAppDelegate()
        if videoType == .youtube {
            appDelegate?.youtubePlayerViewController = nil
        }else if videoType == .facebook {
            appDelegate?.facebookPlayerViewController = nil
        }
        videoType = .none
    }
    
    func disposeYoutubeController() {
        let appDelegate = getAppDelegate()
        appDelegate?.youtubePlayerViewController?.stopVideo()
        appDelegate?.youtubePlayerViewController = nil
    }
    
    func disposeFacebookController() {
        let appDelegate = getAppDelegate()
        appDelegate?.facebookPlayerViewController?.stopVideo()
        appDelegate?.facebookPlayerViewController = nil
    }
    
}

