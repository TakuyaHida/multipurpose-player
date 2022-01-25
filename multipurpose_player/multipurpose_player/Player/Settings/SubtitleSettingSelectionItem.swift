//
//  SubtitleSettingSelectionItem.swift
//  multipurpose_player
//
//  Created by hida-takuya on 2022/01/23.
//

import Foundation
import AVFoundation

struct SubtitleSettingSelectionItem: SettingSelectionItemProtocol {
    let id: UUID = .init()
    let value: AVMediaSelectionOption?
    let locale: Locale
    var title: String {
        value?.displayName(with: locale) ?? "オフ"
    }
}
