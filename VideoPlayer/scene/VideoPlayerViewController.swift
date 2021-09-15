//
//  VideoPlayerViewController.swift
//  VideoPlayer
//
//  Created by Rafael Almeida on 15/09/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.

import UIKit
import AVKit
import CoreMotion
import CoreLocation

protocol VideoPlayerDisplayLogic: UIViewController {
    func playVideo()
    func restartVideo()
    func increaseVolume(viewModel: VideoPlayer.Volume.ViewModel)
    func decreaseVolume(viewModel: VideoPlayer.Volume.ViewModel)
    func rewindVideo(viewModel: VideoPlayer.Seek.ViewModel)
    func forwardVideo(viewModel: VideoPlayer.Seek.ViewModel)
    func pauseVideo()
}

class VideoPlayerViewController: AVPlayerViewController {
    let motionManager = CMMotionManager()
    var locationManager: CLLocationManager?
    var userLocation: CLLocationCoordinate2D?
    var interactor: VideoPlayerBusinessLogic?
    
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        startGyroUpdates()
        startLocationUpdates()
        interactor?.viewLoaded()
    }
    
    private func startGyroUpdates() {
        motionManager.deviceMotionUpdateInterval = 1.0
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) {[weak self] data, error in
            if let attitude = data?.attitude {
                self?.interactor?.gyroEvent(request: VideoPlayer.GyroEvent.Request(attitude: attitude))
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
    
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        interactor?.motionEvent(request: VideoPlayer.MotionEvent.Request(motion: motion))
    }
}

extension VideoPlayerViewController: VideoPlayerDisplayLogic {
    func playVideo() {
        player?.play()
    }
    
    func restartVideo() {
        player?.seek(to: .zero)
        player?.play()
    }
    
    func increaseVolume(viewModel: VideoPlayer.Volume.ViewModel) {
        player?.volume = (player?.volume ?? 0.0) + viewModel.volumePart
    }
    
    func decreaseVolume(viewModel: VideoPlayer.Volume.ViewModel) {
        player?.volume = player?.volume == 0.0 ? 0.0 : (player?.volume ?? 0.0) - viewModel.volumePart
    }
    
    func rewindVideo(viewModel: VideoPlayer.Seek.ViewModel) {
        player?.seek(to: CMTime(seconds: (player?.currentTime().seconds ?? 0.0) - viewModel.seconds, preferredTimescale: .max))
    }
    
    func forwardVideo(viewModel: VideoPlayer.Seek.ViewModel) {
        player?.seek(to: CMTime(seconds: (player?.currentTime().seconds ?? 0.0) + viewModel.seconds, preferredTimescale: .max))
    }
    
    func pauseVideo() {
        player?.pause()
    }
}

extension VideoPlayerViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location?.coordinate {
            startMonitoring(location: location)
        }
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        interactor?.geofenceEvent()
    }
}
