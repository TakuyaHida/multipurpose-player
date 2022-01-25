//
//  SettingSelectionItemProtocol.swift
//  multipurpose_player
//
//  Created by hida-takuya on 2022/01/22.
//

import Foundation

protocol SettingSelectionItemProtocol: Identifiable, Hashable {
    var id: UUID { get }
    var title: String { get }
}
