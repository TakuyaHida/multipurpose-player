//
//  VideoViewControllerRepresentable.swift
//  multipurpose_player
//
//  Created by hida-takuya on 2022/01/22.
//

import SwiftUI

struct VideoViewControllerRepresentable : UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> VideoViewController {
        return VideoViewController(dependency: .init(presenter: VideoPresenter()))
    }
    
    func updateUIViewController(_ uiViewController: VideoViewController, context: Context) {
        
    }
}
