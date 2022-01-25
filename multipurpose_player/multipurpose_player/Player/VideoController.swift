//
//  VideoController.swift
//  multipurpose_player
//
//  Created by hida-takuya on 2021/12/28.
//

import SwiftUI

struct VideoController: View {
    enum PlayPauseType: String {
        case play =  "play.fill"
        case pause = "pause.fill"
    }
    enum RewindType: String {
        case rewind5 = "gobackward.5"
        case rewind10 = "gobackward.10"
        case rewind15 = "gobackward.15"
        case rewind30 = "gobackward.30"
        case rewind45 = "gobackward.45"
        case rewind60 = "gobackward.60"
        
        var timeInterval: TimeInterval {
            switch self {
            case .rewind5:
                return 5
            case .rewind10:
                return 10
            case .rewind15:
                return 15
            case .rewind30:
                return 30
            case .rewind45:
                return 45
            case .rewind60:
                return 60
            }
        }
    }
    enum ForwardType: String {
        case forward5 = "goforward.5"
        case forward10 = "goforward.10"
        case forward15 = "goforward.15"
        case forward30 = "goforward.30"
        case forward45 = "goforward.45"
        case forward60 = "goforward.60"
        
        var timeInterval: TimeInterval {
            switch self {
            case .forward5:
                return 5
            case .forward10:
                return 10
            case .forward15:
                return 15
            case .forward30:
                return 30
            case .forward45:
                return 45
            case .forward60:
                return 60
            }
        }
    }
    
    @Binding private var playPauseType: VideoController.PlayPauseType
    private let rewindType: VideoController.RewindType
    private let forwardType: VideoController.ForwardType
    private var onClickedRewindHandler: ((VideoController.RewindType) -> Void)?
    private var onClickedForwardHandler: ((VideoController.ForwardType) -> Void)?
    private var onClickedPlayPauseHandler: ((VideoController.PlayPauseType) -> Void)?
    
    init(playPauseType: Binding<VideoController.PlayPauseType>,
         rewindType: VideoController.RewindType,
         forwardType: VideoController.ForwardType){
        self._playPauseType = playPauseType
        self.rewindType = rewindType
        self.forwardType = forwardType
    }
    
    var body: some View {
        HStack {
            Button(action: { onClickedRewindHandler?(rewindType) }) {
                Image(systemName: rewindType.rawValue)
                    .frame(width: 60, height: 60)
            }
            Button(action: { onClickedPlayPauseHandler?(playPauseType) }) {
                Image(systemName: playPauseType.rawValue)
                    .frame(width: 60, height: 60)
            }
            Button(action: { onClickedForwardHandler?(forwardType) }) {
                Image(systemName: forwardType.rawValue)
                    .frame(width: 60, height: 60)
               
            }
        }
    }

    func onClickedRewind(handler: @escaping (VideoController.RewindType) -> Void) -> Self {
        var copy = self
        copy.onClickedRewindHandler = handler
        return copy
    }
    func onClickedForward(handler: @escaping (VideoController.ForwardType) -> Void) -> Self {
        var copy = self
        copy.onClickedForwardHandler = handler
        return copy
    }
    func onClickedPlayPause(handler: @escaping (VideoController.PlayPauseType) -> Void) -> Self {
        var copy = self
        copy.onClickedPlayPauseHandler = handler
        return copy
    }
}

struct VideoController_Previews: PreviewProvider {
    static var previews: some View {
        VideoController(playPauseType: .constant(.play),
                        rewindType: .rewind30,
                        forwardType: .forward30)
            .previewLayout(.sizeThatFits)
    }
}
