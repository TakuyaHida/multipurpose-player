//
//  VideoViewController.swift
//  multipurpose_player
//
//  Created by hida-takuya on 2022/01/22.
//

import Foundation
import Combine
import UIKit
import SwiftUI

class VideoViewController: UIViewController {
    struct Dependency {
        let presenter: VideoPresenterProtocol
    }
    private let dependency: VideoViewController.Dependency!
    private var cancellable = Set<AnyCancellable>()
    
    private var hostingController: UIHostingController<Video>?
    
    init(dependency: VideoViewController.Dependency) {
        self.dependency = dependency
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
//        URL(string: "https://cdn.bitmovin.com/content/demos/4k/38e843e0-1998-11e9-8a92-c734cd79b4dc/manifest.m3u8")!
        dependency.presenter.dispatch(message: .urlPlay(url: URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_fmp4/master.m3u8")!))
        dependency.presenter
            .status
            .sink(receiveValue: { [weak self] state in
                self?.bind(state: state)
            })
            .store(in: &cancellable)
    }
    
    private func bind(state: VideoState) {
        let contentView = Video(videoStatusObservableObject: state.stateValue)
            .onClickedSkipRewind { timeInterval in
                self.dependency.presenter.dispatch(message: .skipRewind(timeInterval: timeInterval))
            }
            .onClickedSkipForward { timeInterval in
                self.dependency.presenter.dispatch(message: .skipForward(timeInterval: timeInterval))
            }
            .onClickedPlayPause { isPlay in
                if isPlay {
                    self.dependency.presenter.dispatch(message: .play)
                } else {
                    self.dependency.presenter.dispatch(message: .pause)
                }
            }
            .onClickeSetting {
                self.dependency.presenter.dispatch(message: .setting)
            }
            .onSelectedSettingSubtitle {
                self.dependency.presenter.dispatch(message: .selectedSettingSubtitle)
            }
            .onSelectedSettingAudio {
                self.dependency.presenter.dispatch(message: .selectedSettingAudio)
            }
            .onSelectedSettingSpeedRate {
                self.dependency.presenter.dispatch(message: .selectedSettingSpeedRate)
            }
        if hostingController == nil {
            let hostingController = UIHostingController(rootView: contentView)
            add(child: hostingController, to: view)
            hostingController.view.fit(to: view)
            self.hostingController = hostingController
        } else {
            hostingController?.rootView = contentView
        }
    }
}
