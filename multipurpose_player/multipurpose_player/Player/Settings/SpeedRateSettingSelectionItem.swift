//
//  SpeedRateSettingSelectionItem.swift
//  multipurpose_player
//
//  Created by hida-takuya on 2022/01/23.
//

import Foundation

struct SpeedRateSettingSelectionItem: SettingSelectionItemProtocol {
    let id: UUID = .init()
    let value: SpeedRateSettingSelectionItem.SpeedRateType
    enum SpeedRateType: Float, CaseIterable {
        case rate0Point25x = 0.25
        case rate0Point5x = 0.5
        case rate0Point75x = 0.75
        case rate1x = 1.0
        case rate1Point25x = 1.25
        case rate1Point5x = 1.5
        case rate1Point75 = 1.75
        case rate2x = 2.0
    }
    var title: String {
        value == .rate1x ? "標準" : "\(value.rawValue)x"
    }
}
