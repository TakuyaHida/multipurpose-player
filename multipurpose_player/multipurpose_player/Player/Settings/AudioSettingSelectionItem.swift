//
//  AudioSettingSelectionItem.swift
//  multipurpose_player
//
//  Created by hida-takuya on 2022/01/22.
//

import Foundation
import AVFoundation

struct AudioSettingSelectionItem: SettingSelectionItemProtocol {
    let id: UUID = .init()
    let value: AVMediaSelectionOption?
    let locale: Locale
    var title: String {
        value?.displayName(with: locale) ?? "オフ"
    }
}
