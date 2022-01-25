//
//  UIViewController+Extension.swift
//  multipurpose_player
//
//  Created by hida-takuya on 2022/01/22.
//

import Foundation
import UIKit

extension UIViewController {
    func add(child: UIViewController, to view: UIView? = nil) {
        addChild(child)
        let targetView: UIView = view ?? self.view
        targetView.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove(child: UIViewController) {
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
}
