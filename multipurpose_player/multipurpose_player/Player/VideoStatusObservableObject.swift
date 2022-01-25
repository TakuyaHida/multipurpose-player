//
//  VideoStatusObservableObject.swift
//  multipurpose_player
//
//  Created by hida-takuya on 2022/01/22.
//

import SwiftUI
import AVFoundation

class VideoStatusObservableObject: ObservableObject {
    @Published var videoPlayerStatusValue: VideoPlayerStatusValue = .init()
    @Published var videoSettingStatusValue: VideoSettingStatusValue = .init()
}

struct VideoPlayerStatusValue {
    var player: AVPlayer = .init()
}

struct VideoSettingStatusValue {
    var subtitleSettingSelectionItems: [SubtitleSettingSelectionItem] = .init()
    var currentSubtitleSettingSelectionItem: SubtitleSettingSelectionItem? = nil
    var audioSettingSelectionItems: [AudioSettingSelectionItem] = .init()
    var currentAudioSettingSelectionItem: AudioSettingSelectionItem? = nil
    var speedRateSettingSelectionItems: [SpeedRateSettingSelectionItem] = .init()
    var currentSpeedRateSettingSelectionItem: SpeedRateSettingSelectionItem? = .init(value: .rate1x)
    var skipRewindSettingSelectionItems: [SkipRewindSettingSelectionItem] = .init()
    var currentskipRewindSettingSelectionItem: SkipRewindSettingSelectionItem? = .init(value: .rewind10)
    var skipForwardSettingSelectionItems: [SkipForwardSettingSelectionItem] = .init()
    var currentskipForwardSettingSelectionItem: SkipForwardSettingSelectionItem? = .init(value: .forward10)
}
