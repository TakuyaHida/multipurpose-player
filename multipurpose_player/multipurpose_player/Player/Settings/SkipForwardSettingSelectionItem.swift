//
//  SkipForwardSettingSelectionItem.swift
//  multipurpose_player
//
//  Created by hida-takuya on 2022/01/25.
//

import Foundation

struct SkipForwardSettingSelectionItem: SettingSelectionItemProtocol {
    let id: UUID = .init()
    let value: SkipForwardSettingSelectionItem.SkipForwardType
    enum SkipForwardType: TimeInterval, CaseIterable {
        case forward10 = 10.0
        case forward30 = 30.0
        case forward60 = 60.0
    }
    var title: String {
        "\(Int(value.rawValue))秒"
    }
}
