//
//  VideoPlayer.swift
//  multipurpose_player
//
//  Created by hida-takuya on 2021/12/27.
//

import SwiftUI
import AVFoundation
import UIKit

struct VideoPlayer: UIViewRepresentable {
    private let player: AVPlayer
    private var onChangeCurrentTimeIntervalHandler: ((TimeInterval) -> Void)?
    private var onChangeDurationTimeIntervalHandler: ((TimeInterval) -> Void)?
    private var onChangedStatusHandler: ((AVPlayerItem.Status) -> Void)?
    private var onChangedTimeControlStatusHandler: ((AVPlayer.TimeControlStatus) -> Void)?
    
    init(player: AVPlayer){
        self.player = player
    }
    
    func updateUIView(_ uiView: VideoPlayerUIView,
                      context: UIViewRepresentableContext<VideoPlayer>) {
        
    }
    
    func makeUIView(context: UIViewRepresentableContext<VideoPlayer>) -> VideoPlayerUIView {
        let uiView = VideoPlayerUIView(player: player,
                                       status: { onChangedStatusHandler?($0) },
                                       timeControlStatus: { onChangedTimeControlStatusHandler?($0) },
                                       currentTimeInterval: { onChangeCurrentTimeIntervalHandler?($0) },
                                       durationTimeInterval: { onChangeDurationTimeIntervalHandler?($0) })
        return uiView
    }
    
    static func dismantleUIView(_ uiView: VideoPlayerUIView,
                                coordinator: ()) {
        uiView.cleanUp()
    }
    
    func onChangeCurrentTimeInterval(handler: @escaping (TimeInterval) -> Void) -> Self {
        var copy = self
        copy.onChangeCurrentTimeIntervalHandler = handler
        return copy
    }
    
    func onChangeDurationTimeInterval(handler: @escaping (TimeInterval) -> Void) -> Self {
        var copy = self
        copy.onChangeDurationTimeIntervalHandler = handler
        return copy
    }
    
    func onChangedStatus(handler: @escaping (AVPlayerItem.Status) -> Void) -> Self {
        var copy = self
        copy.onChangedStatusHandler = handler
        return copy
    }
    func onChangedTimeControlStatus(handler: @escaping (AVPlayer.TimeControlStatus) -> Void) -> Self {
        var copy = self
        copy.onChangedTimeControlStatusHandler = handler
        return copy
    }
}

final class VideoPlayerUIView: UIView {
    private let player: AVPlayer
    
    private let status: (AVPlayerItem.Status) -> Void
    private let timeControlStatus: (AVPlayer.TimeControlStatus) -> Void
    private let currentTimeInterval: (TimeInterval) -> Void
    private let durationTimeInterval: (TimeInterval) -> Void
    private let playerLayer: AVPlayerLayer = {
        let result = AVPlayerLayer()
        result.videoGravity = .resizeAspect
        result.needsDisplayOnBoundsChange = true
        return result
    }()
    private var durationObservation: NSKeyValueObservation?
    private var timeObservation: Any?

    
    init(player: AVPlayer,
         status: @escaping (AVPlayerItem.Status) -> Void,
         timeControlStatus: @escaping (AVPlayer.TimeControlStatus) -> Void,
         currentTimeInterval: @escaping (TimeInterval) -> Void,
         durationTimeInterval: @escaping (TimeInterval) -> Void) {
        self.player = player
        self.status = status
        self.timeControlStatus = timeControlStatus
        self.currentTimeInterval = currentTimeInterval
        self.durationTimeInterval = durationTimeInterval
        self.playerLayer.player = player
        
        super.init(frame: .zero)
        layer.addSublayer(playerLayer)
        
        self.player.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        durationObservation = player.currentItem?
            .observe(\.duration,
                      changeHandler: { [weak self] item, change in
                guard let self = self else {
                    return
                }
                self.durationTimeInterval(item.duration.seconds)
                self.timeControlStatus(self.player.timeControlStatus)
                self.status(item.status)
            })
        let interval = CMTime(seconds: 0.5, preferredTimescale: 600)
        timeObservation = player.addPeriodicTimeObserver(forInterval: interval,
                                                         queue: nil) { [weak self] time in
                    guard let self = self else {
                        return
                    }
            self.currentTimeInterval(time.seconds)
                }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as AnyObject? === player {
             if keyPath == "timeControlStatus" {
                 timeControlStatus(player.timeControlStatus)
            }
        }
    }
    
    func cleanUp(){
                durationObservation?.invalidate()
                durationObservation = nil
                player.removeObserver(self, forKeyPath: "timeControlStatus")
                if let observation = timeObservation {
                    player.removeTimeObserver(observation)
                    timeObservation = nil
                }
    }
}
