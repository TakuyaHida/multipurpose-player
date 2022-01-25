//
//  SkipRewindSettingSelectionItem.swift
//  multipurpose_player
//
//  Created by hida-takuya on 2022/01/25.
//

import Foundation

struct SkipRewindSettingSelectionItem: SettingSelectionItemProtocol {
    let id: UUID = .init()
    let value: SkipRewindSettingSelectionItem.SkipRewindType
    enum SkipRewindType: TimeInterval, CaseIterable {
        case rewind10 = 10.0
        case rewind30 = 30.0
        case rewind60 = 60.0
    }
    var title: String {
        "\(Int(value.rawValue))秒"
    }
}
