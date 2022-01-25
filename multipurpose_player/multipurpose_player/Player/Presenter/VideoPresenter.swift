//
//  VideoPresenter.swift
//  multipurpose_player
//
//  Created by hida-takuya on 2022/01/22.
//

import Foundation
import AVFoundation
import Combine

struct VideoPresenter: VideoPresenterProtocol {
    var status = CurrentValueSubject<VideoState, Never>(.initial)
    
    func dispatch(message: VideoMessage) {
        switch message {
        case .urlPlay(let url):
            status.value.stateValue.videoPlayerStatusValue.player = .init(url: url)
        case .play:
            status.value.stateValue.videoPlayerStatusValue.player.play()
            if let currentSpeedRate = status.value.stateValue.videoSettingStatusValue.currentSpeedRateSettingSelectionItem?.value {
                status.value.stateValue.videoPlayerStatusValue.player.rate = currentSpeedRate.rawValue
            }
        case .pause:
            status.value.stateValue.videoPlayerStatusValue.player.pause()
        case .skipRewind(let timeInterval):
            let currentTimeInterval = status.value.stateValue.videoPlayerStatusValue.player.currentTime().seconds
            seek(timeInterval: currentTimeInterval - timeInterval)
        case .skipForward(let timeInterval):
            let currentTimeInterval = status.value.stateValue.videoPlayerStatusValue.player.currentTime().seconds
            seek(timeInterval: currentTimeInterval + timeInterval)
        case .setting:
            setting()
        case .selectedSettingAudio:
            let currentAudio = status.value.stateValue.videoSettingStatusValue.currentAudioSettingSelectionItem?.value
            status.value.stateValue.videoPlayerStatusValue.player.currentItem?.selectAudios(audio: currentAudio)
        case .selectedSettingSubtitle:
            let currentSubtitle = status.value.stateValue.videoSettingStatusValue.currentSubtitleSettingSelectionItem?.value
            status.value.stateValue.videoPlayerStatusValue.player.currentItem?.selectSubtitle(subtitle: currentSubtitle)
        case .selectedSettingSpeedRate:
            guard !status.value.stateValue.videoPlayerStatusValue.player.rate.isZero,
                  let currentSpeedRate = status.value.stateValue.videoSettingStatusValue.currentSpeedRateSettingSelectionItem?.value else {
                return
            }
            status.value.stateValue.videoPlayerStatusValue.player.rate = currentSpeedRate.rawValue
        }
    }
    
    private func seek(timeInterval: TimeInterval) {
        if timeInterval <= 0 {
            let cmt = CMTimeMakeWithSeconds(.zero, preferredTimescale: Int32(NSEC_PER_SEC))
            status.value.stateValue.videoPlayerStatusValue.player.seek(to: cmt, toleranceBefore: .zero, toleranceAfter: .zero)
            return
        }
        if let durationTimeInterval = status.value.stateValue.videoPlayerStatusValue.player.currentItem?.duration.seconds {
            if durationTimeInterval <= timeInterval {
                let cmt = CMTimeMakeWithSeconds(durationTimeInterval, preferredTimescale: Int32(NSEC_PER_SEC))
                status.value.stateValue.videoPlayerStatusValue.player.seek(to: cmt, toleranceBefore: .zero, toleranceAfter: .zero)
            } else {
                let cmt = CMTimeMakeWithSeconds(timeInterval, preferredTimescale: Int32(NSEC_PER_SEC))
                status.value.stateValue.videoPlayerStatusValue.player.seek(to: cmt, toleranceBefore: .zero, toleranceAfter: .zero)
            }
        }
    }
    
    private func setting() {
        let offSubtitle = SubtitleSettingSelectionItem(value: nil, locale: .current)
        let subtitles = status.value.stateValue.videoPlayerStatusValue.player.currentItem?.subtitles.compactMap {SubtitleSettingSelectionItem(value: $0 ,locale: .current)} ?? []
        status.value.stateValue.videoSettingStatusValue.subtitleSettingSelectionItems = [offSubtitle] + subtitles
        let subtitle = status.value.stateValue.videoPlayerStatusValue.player.currentItem?.selectedSubtitle()
        let currentsubtitle = subtitles.first(where: { $0.value?.isEqual(subtitle) ?? false }) ?? offSubtitle
        status.value.stateValue.videoSettingStatusValue.currentSubtitleSettingSelectionItem = currentsubtitle
        
        let audios = status.value.stateValue.videoPlayerStatusValue.player.currentItem?.audios.compactMap {AudioSettingSelectionItem(value: $0 ,locale: .current)} ?? []
        status.value.stateValue.videoSettingStatusValue.audioSettingSelectionItems = audios
        let audio = status.value.stateValue.videoPlayerStatusValue.player.currentItem?.selectedAudio()
        let currentAudio = audios.first(where: { $0.value?.isEqual(audio) ?? false })
        status.value.stateValue.videoSettingStatusValue.currentAudioSettingSelectionItem = currentAudio
        
        let speedRates: [SpeedRateSettingSelectionItem] = SpeedRateSettingSelectionItem.SpeedRateType.allCases.map { .init(value: $0) }
        status.value.stateValue.videoSettingStatusValue.speedRateSettingSelectionItems = speedRates
        
        let skipRewinds: [SkipRewindSettingSelectionItem] = SkipRewindSettingSelectionItem.SkipRewindType.allCases.map { .init(value: $0) }
        status.value.stateValue.videoSettingStatusValue.skipRewindSettingSelectionItems = skipRewinds
        let skipRewind = status.value.stateValue.videoSettingStatusValue.currentskipRewindSettingSelectionItem?.value
        let currentSkipRewind = skipRewinds.first(where: { $0.value == skipRewind })
        status.value.stateValue.videoSettingStatusValue.currentskipRewindSettingSelectionItem = currentSkipRewind
        
        let skipForwards: [SkipForwardSettingSelectionItem] = SkipForwardSettingSelectionItem.SkipForwardType.allCases.map { .init(value: $0) }
        status.value.stateValue.videoSettingStatusValue.skipForwardSettingSelectionItems = skipForwards
        let skipForward = status.value.stateValue.videoSettingStatusValue.currentskipForwardSettingSelectionItem?.value
        let currentSkipForward = skipForwards.first(where: { $0.value == skipForward })
        status.value.stateValue.videoSettingStatusValue.currentskipForwardSettingSelectionItem = currentSkipForward
    }
}
