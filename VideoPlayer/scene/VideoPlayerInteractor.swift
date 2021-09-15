//
//  VideoPlayerInteractor.swift
//  VideoPlayer
//
//  Created by Rafael Almeida on 15/09/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit

protocol VideoPlayerBusinessLogic {
    func gyroEvent(request: VideoPlayer.GyroEvent.Request)
    func motionEvent(request: VideoPlayer.MotionEvent.Request)
    func geofenceEvent()
    func viewLoaded()
}

protocol VideoPlayerDataStore {
    
}

class VideoPlayerInteractor: VideoPlayerDataStore {
    var presenter: VideoPlayerPresentationLogic
    
    init(presenter: VideoPlayerPresentationLogic) {
        self.presenter = presenter
    }
}

extension VideoPlayerInteractor: VideoPlayerBusinessLogic {
    func viewLoaded() {
        presenter.playVideo()
    }
    
    func gyroEvent(request: VideoPlayer.GyroEvent.Request) {
        
        if request.attitude.roll > 0.75 {
            presenter.increaseVolume()
        } else if request.attitude.roll < -0.75 {
            presenter.decreaseVolume()
        }
        
        
        if request.attitude.yaw > 0.75 {
            presenter.rewindVideo()
        } else if request.attitude.yaw < -0.75 {
            presenter.fowardVideo()
        }
    }
    
    func motionEvent(request: VideoPlayer.MotionEvent.Request) {
        if request.motion == .motionShake {
            presenter.pauseVideo()
        }
    }
    
    func geofenceEvent() {
        presenter.restartVideo()
    }
}
