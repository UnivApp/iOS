////
////  AdMobView.swift
////  UnivApp
////
////  Created by 정성윤 on 9/13/24.
////
//
//import SwiftUI
//import GoogleMobileAds
//
//struct AdMobView: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> UIViewController {
//        let viewController = UIViewController()
//        let bannerSize = GADLandscapeAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width - 60)
//        let banner = GADBannerView(adSize: bannerSize)
//        banner.rootViewController = viewController
//        viewController.view.addSubview(banner)
//        
//        //TODO: - 실제 광고 아이디로 변경
//        banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
//        banner.load(GADRequest())
//        
//        return viewController
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        
//    }
//    
//}
//
//#Preview {
//    AdMobView()
//}
