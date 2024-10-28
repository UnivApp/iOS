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

enum AdTypes: CaseIterable {
    case banner
    case native
    case front
}

struct GADBannerViewController: UIViewControllerRepresentable {
    var type: AdTypes?
    func makeUIViewController(context: Context) -> some UIViewController {
        let viewController = UIViewController()
        let view = GADBannerView(adSize: GADAdSize())
        
        switch type {
        case .banner:
            view.adUnitID = AdMob_BannerID
        case .front:
            view.adUnitID = AdMob_FrontID
        case .native:
            view.adUnitID = AdMob_NativeID
        case nil:
            view.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        }
        
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        view.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width - 40)
            make.height.equalTo((UIScreen.main.bounds.width - 40) / 3.2)
        }
        view.layer.cornerRadius = 15
        view.load(GADRequest())
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> () {
        return
    }
}
