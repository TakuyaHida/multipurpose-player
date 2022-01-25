//
//  AVPlayerItem+Extension.swift
//  multipurpose_player
//
//  Created by hida-takuya on 2022/01/15.
//

import Foundation
import AVFoundation

extension AVPlayerItem {
    var audios: [AVMediaSelectionOption] {
        self.asset.mediaSelectionGroup(forMediaCharacteristic: .audible)?.options ?? []
    }
    
    var subtitles: [AVMediaSelectionOption] {
        self.asset.mediaSelectionGroup(forMediaCharacteristic: .legible)?.options ?? []
    }
    
    func selectSubtitle(subtitle: AVMediaSelectionOption?) {
        guard let mediaSelectionGroup = self.asset.mediaSelectionGroup(forMediaCharacteristic: .legible) else {
            return
        }
        self.select(subtitle, in: mediaSelectionGroup)
    }
    
    func selectedSubtitle() -> AVMediaSelectionOption? {
        guard let mediaSelectionGroup = self.asset.mediaSelectionGroup(forMediaCharacteristic: .legible) else {
            return nil
        }
        return self.currentMediaSelection.selectedMediaOption(in: mediaSelectionGroup)
    }
    
    func selectAudios(audio: AVMediaSelectionOption?) {
        guard let mediaSelectionGroup = self.asset.mediaSelectionGroup(forMediaCharacteristic: .audible) else {
            return
        }
        self.select(audio, in: mediaSelectionGroup)
    }
    
    func selectedAudio() -> AVMediaSelectionOption? {
        guard let mediaSelectionGroup = self.asset.mediaSelectionGroup(forMediaCharacteristic: .audible) else {
            return nil
        }
        return self.currentMediaSelection.selectedMediaOption(in: mediaSelectionGroup)
    }
}
