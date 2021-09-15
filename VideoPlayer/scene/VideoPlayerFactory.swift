//
//  VideoPlayerFactory.swift
//  VideoPlayer
//
//  Created by Rafael Almeida on 15/09/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit
import AVKit

class VideoPlayerFactory {
    
    static func getViewController() -> VideoPlayerViewController? {
        guard let url = URL(string: Constants.videoURL) else { return nil }
        let viewController = VideoPlayerViewController()
        let player = AVPlayer(url: url)
        viewController.player = player
        let presenter = VideoPlayerPresenter(viewController: viewController)
        let interactor = VideoPlayerInteractor(presenter: presenter)
        viewController.interactor = interactor
        
        return viewController
    }

}
