//
//  VideoSetting.swift
//  multipurpose_player
//
//  Created by hida-takuya on 2022/01/23.
//

import SwiftUI

struct VideoSetting<SubtitleSelectionItem: SettingSelectionItemProtocol,
                    AudioSelectionItem: SettingSelectionItemProtocol,
                    SpeedRateSelectionItem: SettingSelectionItemProtocol,
                    SkipRewindSelectionItem: SettingSelectionItemProtocol,
                    SkipForwardSelectionItem: SettingSelectionItemProtocol>: View {
    @Binding private var isActive: Bool
    private var subtitleSelectionItems: [SubtitleSelectionItem]
    @Binding private var currentSubtitleSelectionItem: SubtitleSelectionItem?
    private var audioSelectionItems: [AudioSelectionItem]
    @Binding private var currentAudioSelectionItem: AudioSelectionItem?
    private var speedRateSelectionItems: [SpeedRateSelectionItem]
    @Binding private var currentSpeedRateSelectionItem: SpeedRateSelectionItem?
    private var skipRewindSelectionItems: [SkipRewindSelectionItem]
    @Binding private var currentSkipRewindSelectionItem: SkipRewindSelectionItem?
    private var skipForwardSelectionItems: [SkipForwardSelectionItem]
    @Binding private var currentSkipForwardSelectionItem: SkipForwardSelectionItem?
    @State private var settingType: VideoSetting.SettingType?
    private var onSelectedAudioHandler: (() -> Void)?
    private var onSelectedSubtitleHandler: (() -> Void)?
    private var onSelectedSpeedRateHandler: (() -> Void)?
    private var onSelectedSkipRewindHandler: (() -> Void)?
    private var onSelectedSkipForwardHandler: (() -> Void)?
    
    private enum SettingType: Hashable {
        case subtitle
        case audio
        case speedRate
        case skip
        
        var title: String {
            switch self {
            case .subtitle:
                return "字幕"
            case .audio:
                return "音声"
            case .speedRate:
                return "再生速度"
            case .skip:
                return "スキップ"
            }
        }
    }
    
    init(isActive: Binding<Bool>,
         subtitleSelectionItems: [SubtitleSelectionItem],
         currentSubtitleSelectionItem: Binding<SubtitleSelectionItem?>,
         audioSelectionItems: [AudioSelectionItem],
         currentAudioSelectionItem: Binding<AudioSelectionItem?>,
         speedRateSelectionItems: [SpeedRateSelectionItem],
         currentSpeedRateSelectionItem: Binding<SpeedRateSelectionItem?>,
         skipRewindSelectionItems: [SkipRewindSelectionItem],
         currentSkipRewindSelectionItem: Binding<SkipRewindSelectionItem?>,
         skipForwardSelectionItems: [SkipForwardSelectionItem],
         currentSkipForwardSelectionItem: Binding<SkipForwardSelectionItem?>) {
        self._isActive = isActive
        self.subtitleSelectionItems = subtitleSelectionItems
        self._currentSubtitleSelectionItem = currentSubtitleSelectionItem
        self.audioSelectionItems = audioSelectionItems
        self._currentAudioSelectionItem = currentAudioSelectionItem
        self.speedRateSelectionItems = speedRateSelectionItems
        self._currentSpeedRateSelectionItem = currentSpeedRateSelectionItem
        self.skipRewindSelectionItems = skipRewindSelectionItems
        self._currentSkipRewindSelectionItem = currentSkipRewindSelectionItem
        self.skipForwardSelectionItems = skipForwardSelectionItems
        self._currentSkipForwardSelectionItem = currentSkipForwardSelectionItem
    }
    var body: some View {
        VStack {
            topView
            listView
        }
        .frame(width: 300, height: 300)
    }
    
    private var topView: some View {
        HStack {
            if settingType != nil {
                Button(action: { settingType = nil }) {
                    Image(systemName: "arrow.backward")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                }
            }
            Text(settingType?.title ?? "設定")
            Spacer()
            Button(action: { isActive.toggle() }) {
                Image(systemName: "xmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
            }
        }
    }
    
    private var listView: some View {
        NavigationView {
            List {
                subtitleNavigationItem
                audioNavigationItem
                speedRateNavigationItem
                skipNavigationItem
            }
            .listStyle(.plain)
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }
    
    private var subtitleNavigationItem: some View {
        let destination = SettingSelection(items: subtitleSelectionItems,
                                           item: $currentSubtitleSelectionItem)
            .onSelectedItem { _ in
                onSelectedSubtitleHandler?()
            }
        return navigationItem(title: SettingType.subtitle.title,
                              subTitle: currentSubtitleSelectionItem?.title ?? "",
                              destination: destination,
                              tag: .subtitle,
                              selection: $settingType)
    }
    private var audioNavigationItem: some View {
        let destination = SettingSelection(items: audioSelectionItems,
                                           item: $currentAudioSelectionItem)
            .onSelectedItem { _ in
                onSelectedAudioHandler?()
            }
        return navigationItem(title: SettingType.audio.title,
                              subTitle: currentAudioSelectionItem?.title ?? "",
                              destination: destination,
                              tag: .audio,
                              selection: $settingType)
    }
    private var speedRateNavigationItem: some View {
        let destination = SettingSelection(items: speedRateSelectionItems,
                                           item: $currentSpeedRateSelectionItem)
            .onSelectedItem { _ in
                onSelectedSpeedRateHandler?()
            }
        return navigationItem(title: SettingType.speedRate.title,
                              subTitle: currentSpeedRateSelectionItem?.title ?? "",
                              destination: destination,
                              tag: .speedRate,
                              selection: $settingType)
    }
    private var skipNavigationItem: some View {
        let destination = SkipSettingSelection(rewindItems: skipRewindSelectionItems,
                                               rewindItem: $currentSkipRewindSelectionItem,
                                               forwardItems: skipForwardSelectionItems,
                                               forwardItem: $currentSkipForwardSelectionItem)
            .onSelectedRewindItem { _ in onSelectedSkipRewindHandler?()}
            .onSelectedForwardItem { _ in onSelectedSkipForwardHandler?()}
        let subtitle = "\(currentSkipRewindSelectionItem?.title ?? "")巻戻し/\(currentSkipForwardSelectionItem?.title ?? "")早送り"
        return navigationItem(title: SettingType.skip.title,
                              subTitle: subtitle,
                              destination: destination,
                              tag: .skip,
                              selection: $settingType)
    }
    private func navigationItem<Destination: View, V: Hashable>(title: String, subTitle: String, destination: Destination, tag: V, selection: Binding<V?>) -> some View {
        ZStack {
            NavigationLink(destination: destination.navigationBarBackButtonHidden(true),
                           tag: tag,
                           selection: selection) {
                EmptyView()
            }
                           .opacity(0.0)
            HStack {
                Text(title)
                Spacer()
                Text(subTitle)
            }
        }
    }
    
    func onSelectedSubtitle(handler: @escaping () -> Void) -> Self {
        var copy = self
        copy.onSelectedSubtitleHandler = handler
        return copy
    }
    func onSelectedAudio(handler: @escaping () -> Void) -> Self {
        var copy = self
        copy.onSelectedAudioHandler = handler
        return copy
    }
    func onSelectedSpeedRate(handler: @escaping () -> Void) -> Self {
        var copy = self
        copy.onSelectedSpeedRateHandler = handler
        return copy
    }
    func onSelectedSkipRewind(handler: @escaping () -> Void) -> Self {
        var copy = self
        copy.onSelectedSkipRewindHandler = handler
        return copy
    }
    func onSelectedSkipForward(handler: @escaping () -> Void) -> Self {
        var copy = self
        copy.onSelectedSkipForwardHandler = handler
        return copy
    }
}

//struct VideoSetting3_Previews: PreviewProvider {
//    static var previews: some View {
//        VideoSetting3<<#AudioSelectionItem: SettingSelectionItemProtocol#>>(isActive: .constant(true))
//    }
//}
