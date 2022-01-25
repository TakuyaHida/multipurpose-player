//
//  VideoPresenterProtocol.swift
//  multipurpose_player
//
//  Created by hida-takuya on 2022/01/22.
//

import Foundation
import Combine

protocol VideoPresenterProtocol {
    var status: CurrentValueSubject<VideoState, Never> { get }
    func dispatch(message: VideoMessage)
}

enum VideoMessage {
    case urlPlay(url: URL)
    case play
    case pause
    case skipRewind(timeInterval: TimeInterval)
    case skipForward(timeInterval: TimeInterval)
    case setting
    case selectedSettingAudio
    case selectedSettingSubtitle
    case selectedSettingSpeedRate
}

struct VideoState{
    var stateValue: VideoStatusObservableObject
    static var initial: VideoState {
        .init(stateValue: .init())
    }
}
