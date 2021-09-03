//
//  VideoStarterViewController.swift
//  VideoPlayer
//
//  Created by Rafael Almeida on 01/09/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit
import AVKit
import CoreMotion
import CoreLocation

class CustomAVPlayerViewController: AVPlayerViewController {
    let motionManager = CMMotionManager()
    var locationManager: CLLocationManager?
    var userLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startGyroUpdates()
        startLocationUpdates()
        player?.play()
    }
    
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            self.player?.pause()
        }
    }
    
    private func startGyroUpdates() {
        motionManager.deviceMotionUpdateInterval = 1.0
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) {[weak self] data, error in
            if let attitude = data?.attitude {
                self?.changeVolume(attitude: attitude)
                self?.changeProgress(attitude: attitude)
            }
        }
    }
    
    private func startLocationUpdates() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.startUpdatingLocation()
    }
    
    private func startMonitoring(location: CLLocationCoordinate2D) {
        if userLocation != nil { return }
        userLocation = location
        let geofenceRegion = CLCircularRegion(center: location,
                                              radius: 10,
                                              identifier: "UniqueIdentifier")
        geofenceRegion.notifyOnExit = true
        locationManager?.startMonitoring(for: geofenceRegion)
    }
    
    private func changeVolume(attitude: CMAttitude) {
        if attitude.roll > 0.75 {
            player?.volume = (player?.volume ?? 0.0) + 0.5
        } else if attitude.roll < -0.75 {
            player?.volume = player?.volume == 0.0 ? 0.0 : (player?.volume ?? 0.0) - 0.5
        }
    }
    
    private func changeProgress(attitude: CMAttitude) {
        if attitude.yaw > 0.75 {
            player?.seek(to: CMTime(seconds: (player?.currentTime().seconds ?? 0.0) - 5.0, preferredTimescale: .max))
        } else if attitude.yaw < -0.75 {
            player?.seek(to: CMTime(seconds: (player?.currentTime().seconds ?? 0.0) + 5.0, preferredTimescale: .max))
        }
    }
}

extension CustomAVPlayerViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location?.coordinate {
            startMonitoring(location: location)
        }
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        player?.seek(to: .zero)
        player?.play()
    }
}
