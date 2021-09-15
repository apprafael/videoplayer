//
//  VideoPlayerPresenter.swift
//  VideoPlayer
//
//  Created by Rafael Almeida on 15/09/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

protocol VideoPlayerPresentationLogic {
    func playVideo()
    func restartVideo()
    func increaseVolume()
    func decreaseVolume()
    func rewindVideo()
    func fowardVideo()
    func pauseVideo()
}

class VideoPlayerPresenter {
    weak var viewController: VideoPlayerDisplayLogic?
    
    init(viewController: VideoPlayerDisplayLogic) {
        self.viewController = viewController
    }
}

extension VideoPlayerPresenter: VideoPlayerPresentationLogic {    
    func playVideo() {
        viewController?.playVideo()
    }
    
    func restartVideo() {
        viewController?.restartVideo()
    }
    
    func increaseVolume() {
        viewController?.increaseVolume(viewModel: VideoPlayer.Volume.ViewModel(volumePart: 0.5))
    }
    
    func decreaseVolume() {
        viewController?.decreaseVolume(viewModel: VideoPlayer.Volume.ViewModel(volumePart: 0.5))
    }
    
    func rewindVideo() {
        viewController?.rewindVideo(viewModel: VideoPlayer.Seek.ViewModel(seconds: 5.0))
    }
    
    func fowardVideo() {
        viewController?.forwardVideo(viewModel: VideoPlayer.Seek.ViewModel(seconds: 5.0))
    }
    
    func pauseVideo() {
        viewController?.pauseVideo()
    }
}
