//
//  CustomAVPlayerFactory.swift
//  VideoPlayer
//
//  Created by Rafael Almeida on 02/09/21.
//

import Foundation
import AVKit

struct CustomAVPlayerFactory {
    static func getAVPlayer() -> CustomAVPlayerViewController? {
        guard let url = URL(string: Constants.videoURL) else { return nil }
        let player = AVPlayer(url: url)
        let controller = CustomAVPlayerViewController()
        controller.player = player
        return controller
    }
}
