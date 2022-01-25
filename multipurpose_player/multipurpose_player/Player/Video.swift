//
//  Video.swift
//  multipurpose_player
//
//  Created by hida-takuya on 2021/12/28.
//

import SwiftUI
import AVFoundation

struct Video: View {
    @ObservedObject var videoStatusObservableObject: VideoStatusObservableObject
    private let timer = Timer.publish(every: 0.5, on: .current, in: .common).autoconnect()
    @State private var playerState: AVPlayerItem.Status = .unknown
    @State private var timeControlStatus: AVPlayer.TimeControlStatus = .paused
    @State private var currentTimeInterval: TimeInterval = 0.0
    @State private var durationTimeInterval: TimeInterval? = nil
    @State private var isShowSetting: Bool = false
    @State private var isOnDebugInfo: Bool = false
    @State private var playPauseType: VideoController.PlayPauseType = .pause
    @State var showControllType: ShowStateType = .alwayshidden
    
    private var onClickedSkipRewindHandler: ((TimeInterval) -> Void)?
    private var onClickedSkipForwardHandler: ((TimeInterval) -> Void)?
    private var onClickedPlayPauseHandler: ((Bool) -> Void)?
    private var onClickeSettingHandler: (() -> Void)?
    private var onSelectedSettingSubtitleHandler: (() -> Void)?
    private var onSelectedSettingAudioHandler: (() -> Void)?
    private var onSelectedSettingSpeedRateHandler: (() -> Void)?
    
    enum ShowStateType: Equatable {
        case alwayshidden
        case showTimeInterval(timeInterval: TimeInterval)
        case alwaysShow
    }
    
    init(videoStatusObservableObject: VideoStatusObservableObject) {
        self.videoStatusObservableObject = videoStatusObservableObject
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ZStack {
                playerView
                if showControllType != .alwayshidden {
                    videoController
                    VStack {
                        topView
                        Spacer()
                    }
                }
            }
            .onTapGesture {
                if showControllType != .alwaysShow {
                    showControllType = .showTimeInterval(timeInterval: 5)
                }
            }
        }
        .overlay{
            if isShowSetting {
                settingView
            }
        }
        .onReceive(timer) { _ in
            switch showControllType {
            case .showTimeInterval(let timeInterval):
                let resultTimeInterval = timeInterval - 0.5
                if resultTimeInterval <= 0 {
                    showControllType = .alwayshidden
                } else {
                    showControllType = .showTimeInterval(timeInterval: resultTimeInterval)
                }
            case .alwayshidden, .alwaysShow:
                break
            }
        }
        
    }
    
    private var videoController: some View {
        VideoController(playPauseType: $playPauseType,
                        rewindType: toVideoControllerRewindType(),
                        forwardType: toVideoControllerForwardType())
            .onClickedRewind { rewindType in
                onClickedSkipRewindHandler?(rewindType.timeInterval)
            }
            .onClickedForward { forwardType in
                onClickedSkipForwardHandler?(forwardType.timeInterval)
            }
            .onClickedPlayPause { playPauseType in
                switch playPauseType {
                case .play:
                    self.playPauseType = .pause
                    onClickedPlayPauseHandler?(false)
                case .pause:
                    self.playPauseType = .play
                    onClickedPlayPauseHandler?(true)
                }
            }
    }
    
    private var settingView: some View {
        VideoSetting(isActive: $isShowSetting,
                     subtitleSelectionItems: videoStatusObservableObject.videoSettingStatusValue.subtitleSettingSelectionItems,
                     currentSubtitleSelectionItem: $videoStatusObservableObject.videoSettingStatusValue.currentSubtitleSettingSelectionItem,
                      audioSelectionItems: videoStatusObservableObject.videoSettingStatusValue.audioSettingSelectionItems,
                      currentAudioSelectionItem: $videoStatusObservableObject.videoSettingStatusValue.currentAudioSettingSelectionItem,
                     speedRateSelectionItems: videoStatusObservableObject.videoSettingStatusValue.speedRateSettingSelectionItems,
                     currentSpeedRateSelectionItem: $videoStatusObservableObject.videoSettingStatusValue.currentSpeedRateSettingSelectionItem,
                     skipRewindSelectionItems: videoStatusObservableObject.videoSettingStatusValue.skipRewindSettingSelectionItems,
                     currentSkipRewindSelectionItem: $videoStatusObservableObject.videoSettingStatusValue.currentskipRewindSettingSelectionItem,
                     skipForwardSelectionItems: videoStatusObservableObject.videoSettingStatusValue.skipForwardSettingSelectionItems,
                     currentSkipForwardSelectionItem: $videoStatusObservableObject.videoSettingStatusValue.currentskipForwardSettingSelectionItem)
            .onSelectedSubtitle {
                onSelectedSettingSubtitleHandler?()
            }
            .onSelectedAudio {
                onSelectedSettingAudioHandler?()
            }
            .onSelectedSpeedRate {
                onSelectedSettingSpeedRateHandler?()
            }
        //            .contentShape(Rectangle())
        //            .padding(.horizontal, 30)
        //        Color
        //            .black
        //            .opacity(0.5)
        //            .edgesIgnoringSafeArea(.all)
        //            .overlay {
        //                VideoSetting1(player: videoStatusObservableObject.videoPlayerStatusValue.player,
        //                              isOnDebugInfo: $isOnDebugInfo)
        //                    .padding(.horizontal, 30)
        //                VideoSetting3(isActive: $isShowSetting)
        //                    .contentShape(Rectangle())
        //                    .padding(.horizontal, 30)
        //            }
        //            .onTapGesture {
        //                if isShowSetting {
        //                    isShowSetting.toggle()
        //                }
        //            }
    }
    
    private var playerView: some View {
        ZStack {
            VideoPlayer(player: videoStatusObservableObject.videoPlayerStatusValue.player)
                .onChangedStatus { status in
                    self.playerState = status
                }
                .onChangedTimeControlStatus { timeControlStatus in
                    self.timeControlStatus = timeControlStatus
                }
                .onChangeCurrentTimeInterval { currentTimeInterval in
                    self.currentTimeInterval = currentTimeInterval
                }
                .onChangeDurationTimeInterval { durationTimeInterval in
                    self.durationTimeInterval = durationTimeInterval
                }
            if timeControlStatus == .waitingToPlayAtSpecifiedRate {
                ActivityIndicator()
            }
        }
    }
    
    private var topView: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "chevron.left")
                    .frame(width: 60, height: 60)
            }
            Spacer()
            Button(action: {
                if !isShowSetting {
                    onClickeSettingHandler?()
                    isShowSetting.toggle()
                }
            }) {
                Image(systemName: "gearshape.fill")
                    .frame(width: 60, height: 60)
            }
        }
    }
    private func toVideoControllerRewindType() -> VideoController.RewindType {
        let value = videoStatusObservableObject.videoSettingStatusValue.currentskipRewindSettingSelectionItem?.value
        switch value {
        case .none, .rewind10:
            return .rewind10
        case .rewind30:
            return .rewind30
        case .rewind60:
            return .rewind60
        }
    }
    
    private func toVideoControllerForwardType() -> VideoController.ForwardType {
        let value = videoStatusObservableObject.videoSettingStatusValue.currentskipForwardSettingSelectionItem?.value
        switch value {
        case .none, .forward10:
            return .forward10
        case .forward30:
            return .forward30
        case .forward60:
            return .forward60
        }
    }
    
    func onClickedSkipRewind(handler: @escaping (TimeInterval) -> Void) -> Self {
        var copy = self
        copy.onClickedSkipRewindHandler = handler
        return copy
    }
    
    func onClickedSkipForward(handler: @escaping (TimeInterval) -> Void) -> Self {
        var copy = self
        copy.onClickedSkipForwardHandler = handler
        return copy
    }
    
    func onClickedPlayPause(handler: @escaping (Bool) -> Void) -> Self {
        var copy = self
        copy.onClickedPlayPauseHandler = handler
        return copy
    }
    
    func onClickeSetting(handler: @escaping () -> Void) -> Self {
        var copy = self
        copy.onClickeSettingHandler = handler
        return copy
    }
    
    func onSelectedSettingSubtitle(handler:  @escaping () -> Void) -> Self {
        var copy = self
        copy.onSelectedSettingSubtitleHandler = handler
        return copy
    }
    
    func onSelectedSettingAudio(handler:  @escaping () -> Void) -> Self {
        var copy = self
        copy.onSelectedSettingAudioHandler = handler
        return copy
    }
    
    func onSelectedSettingSpeedRate(handler:  @escaping () -> Void) -> Self {
        var copy = self
        copy.onSelectedSettingSpeedRateHandler = handler
        return copy
    }
    
//    func onSelectedSkipRewind(handler:  @escaping () -> Void) -> Self {
//        var copy = self
//        copy.onSelectedSkipRewindHandler = handler
//        return copy
//    }
//
//    func onSelectedSkipForward(handler:  @escaping () -> Void) -> Self {
//        var copy = self
//        copy.onSelectedSkipForwardHandler = handler
//        return copy
//    }
}

struct Video_Previews: PreviewProvider {
    static var previews: some View {
        Video(videoStatusObservableObject: .init())
        //.previewInterfaceOrientation(.portrait)
    }
}
