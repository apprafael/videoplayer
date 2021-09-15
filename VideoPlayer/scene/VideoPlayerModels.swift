//
//  VideoPlayerModels.swift
//  VideoPlayer
//
//  Created by Rafael Almeida on 15/09/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit
import CoreMotion

enum VideoPlayer {
    enum GyroEvent {
        struct Request {
            let attitude: CMAttitude
        }
    }
    
    enum MotionEvent {
        struct Request {
            let motion: UIEvent.EventSubtype
        }
    }
    
    enum Volume {
        struct ViewModel {
            let volumePart: Float
        }
    }
    
    enum Seek {
        struct ViewModel {
            let seconds: Double
        }
    }
}
