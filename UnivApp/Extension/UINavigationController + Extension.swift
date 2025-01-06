//
//  UINavigationController + Extension.swift
//  UnivApp
//
//  Created by 정성윤 on 1/3/25.
//

import UIKit

extension UINavigationController: @retroactive ObservableObject, @retroactive UIGestureRecognizerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
