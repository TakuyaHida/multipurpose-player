//
//  AVPlayer+Extension.swift
//  multipurpose_player
//
//  Created by hida-takuya on 2021/12/28.
//

import AVKit

extension AVPlayer {
    
    func bandwindList() -> [Int] {
        
        guard let url = (self.currentItem?.asset as? AVURLAsset)?.url,
        url.pathExtension == "m3u8",
        let planStr = try? String(contentsOf: url) else {
            return []
        }
        
        let linePattern = "#EXT-X-STREAM-INF:"
        let lines = planStr.split(whereSeparator: \.isNewline)
            .filter { $0.hasPrefix(linePattern) }
            .map { String($0.dropFirst(linePattern.count)) }
        
        let bandwidthPattern = "BANDWIDTH="
        let bandwidthList = lines.compactMap {
            $0.split(separator: ",")
                .first(where: { $0.hasPrefix(bandwidthPattern)  })
                .flatMap {String($0.dropFirst(bandwidthPattern.count)) }
                .flatMap { Int($0) }
            }
            .sorted()
        return bandwidthList
    }
    
    func resolutionList() -> [String] {
        
        guard let url = (self.currentItem?.asset as? AVURLAsset)?.url,
        url.pathExtension == "m3u8",
        let planStr = try? String(contentsOf: url) else {
            return []
        }
        
        let linePattern = "#EXT-X-STREAM-INF:"
        let lines = planStr.split(whereSeparator: \.isNewline)
            .filter { $0.hasPrefix(linePattern) }
            .map { String($0.dropFirst(linePattern.count)) }
        
        let resolutionPattern = "RESOLUTION="
        let resolutionList = lines.compactMap {
            $0.split(separator: ",")
                .first(where: { $0.hasPrefix(resolutionPattern)  })
                .flatMap {String($0.dropFirst(resolutionPattern.count)) }
            }
        .reduce([], { $0.contains($1) ? $0 : $0 + [$1] })
        return resolutionList
    }
}
