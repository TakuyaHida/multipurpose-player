//
//  ActivityIndicator.swift
//  multipurpose_player
//
//  Created by hida-takuya on 2022/01/10.
//
import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        UIActivityIndicatorView(style: .large)
    }
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        uiView.startAnimating()
    }
}
