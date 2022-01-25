//
//  UIView+Extension.swift
//  multipurpose_player
//
//  Created by hida-takuya on 2022/01/22.
//

import Foundation
import UIKit

extension UIView {
    func fit(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
