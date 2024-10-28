//
//  GADBannerViewController.swift
//  UnivApp
//
//  Created by 정성윤 on 10/28/24.
//

import Foundation
import SwiftUI
import Combine
import GoogleMobileAds
import SnapKit

struct GADBannerViewController: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = UIViewController()
        let view = GADBannerView()
        
        view.adUnitID = AdMob_UnitID
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.load(GADRequest())
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> () {
        return
    }
}
