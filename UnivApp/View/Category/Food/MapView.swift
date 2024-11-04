//
//  MapView.swift
//  UnivApp
//
//  Created by 정성윤 on 10/12/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Environment(\.dismiss) var dismiss
    @State private var region: [MKCoordinateRegion]
    @State private var opacity: Bool = false
    var model: [FoodModel]
    var isCover: Bool
    
    init(model: [FoodModel], isCover: Bool) {
        self.model = model
        self.isCover = isCover
        self._region = State(initialValue: model.map { _ in
            MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.5666791, longitude: 126.9782914), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        })
    }
    
    var body: some View {
        ZStack {
            Map(interactionModes: .all) {
                ForEach(model.indices, id: \.self) { index in
                    Marker(model[index].name, coordinate: region[index].center)
                        .tint(.orange)
                }
            }
            .onAppear {
                geocodeAddress()
            }
            if isCover {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.gray)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
        }
    }
    
    private func geocodeAddress() {
        for (index, model) in self.model.enumerated() {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(model.roadAddressName) { placemarks, error in
                if let error = error {
                    print("Geocoding error: \(error.localizedDescription)")
                    return
                }
                guard let placemark = placemarks?.first, let location = placemark.location else {
                    print("No location found")
                    return
                }
                DispatchQueue.main.async {
                    withAnimation {
                        region[index] = MKCoordinateRegion(
                            center: location.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                        )
                    }
                }
            }
        }
    }
}

//fileprivate struct FoodSelectedPopupView: View {
//    var model: [FoodModel]
//    @Binding var isPresented: Bool
//    @Binding var isFullCover: Bool
//    var body: some View {
//        loadedView
//    }
//    
//    var loadedView: some View {
//        VStack(alignment: .leading, spacing: 15) {
//            Group {
//                HStack {
//                    Spacer()
//                    Button {
//                        withAnimation {
//                            self.isPresented = false
//                        }
//                    } label: {
//                        Image(systemName: "xmark.circle.fill")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 20, height: 20)
//                            .foregroundColor(.gray)
//                    }
//                }
//                .padding(.top, 20)
//                
//                Group {
//                    Text(model[0].name)
//                        .font(.system(size: 15, weight: .bold))
//                    
//                    HStack {
//                        Text("📍 \(model[0].roadAddressName)")
//                            .font(.system(size: 12, weight: .semibold))
//                        Spacer()
//                        Button {
//                            if let url = URL(string: model[0].placeUrl){
//                                UIApplication.shared.open(url)
//                            }
//                        } label: {
//                            Text("카카오 리뷰")
//                                .foregroundColor(.yellow.opacity(5.0))
//                                .font(.system(size: 13, weight: .regular))
//                                .overlay(alignment: .bottom) {
//                                    Color.green.opacity(5.0)
//                                        .frame(height: 1)
//                                }
//                        }
//                    }
//                    
//                   
//                }
//                .foregroundColor(.black)
//                .multilineTextAlignment(.leading)
//                
//                Button {
//                    withAnimation {
//                        self.isFullCover = true
//                        self.isPresented = false
//                    }
//                } label: {
//                    MapView(model: model, isCover: false)
//                        .cornerRadius(15)
//                        .padding(.horizontal, 0)
//                        .padding(.bottom, 20)
//                }
//            }
//            .padding(.horizontal, 20)
//        }
//        .background(.white)
//        .cornerRadius(15)
//        .padding(.horizontal, 20)
//        .frame(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height / 1.8)
//        .toolbar(.hidden, for: .tabBar)
//    }
//}

//#Preview {
//    MapView(model: FoodModel(name: "", location: "", placeUrl: "", hashtags: [""]), isPopup: true, isCover: true)
//}
