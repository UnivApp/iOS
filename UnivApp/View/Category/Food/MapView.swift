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
    @State private var cameraPosition: MapCameraPosition
    @State private var opacity: Bool = false
    @State private var selectedTag: Int?
    @State private var isPresented: Bool = false
    var model: [FoodModel]
    
    init(model: [FoodModel]) {
        self.model = model
        self._region = State(initialValue: model.map { _ in
            MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.5666791, longitude: 126.9782914), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        })
        self._cameraPosition = State(initialValue: MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.5666791, longitude: 126.9782914), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))))
    }
    
    var body: some View {
        Map(position: $cameraPosition, interactionModes: .all, selection: $selectedTag) {
            ForEach(model.indices, id: \.self) { index in
                Marker(model[index].name, coordinate: region[index].center)
                    .tint(.orange)
                    .tag(index)
            }
        }
        .onAppear {
            geocodeAddress()
        }
        .onChange(of: model) {
            geocodeAddress()
            self.selectedTag = nil
        }
        .onChange(of: selectedTag) {
            if selectedTag != nil {
                isPresented = true
            }
        }
        .fullScreenCover(isPresented: $isPresented) {
            if let index = selectedTag {
                FoodSelectedPopupView(model: [model[index]], isPresented: $isPresented)
                    .presentationBackground(.black.opacity(0.7))
                    .fadeInOut($opacity)
            }
        }
        .transaction { $0.disablesAnimations = true }
    }
    
    private func geocodeAddress() {
        for (index, model) in self.model.enumerated() {
            DispatchQueue.main.async {
                withAnimation {
                    region[index] = MKCoordinateRegion(
                        center: CLLocationCoordinate2D(latitude: model.y, longitude: model.x),
                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    )
                    if index == 0 {
                        cameraPosition = MapCameraPosition.region(region[0])
                    }
                }
            }
        }
    }
}

struct FoodSelectedPopupView: View {
    var model: [FoodModel]
    @Binding var isPresented: Bool
    var body: some View {
        loadedView
    }
    
    var loadedView: some View {
        VStack(alignment: .leading, spacing: 15) {
            Group {
                HStack {
                    Text("# \(model[0].categoryName)")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.black.opacity(0.7))
                    Spacer()
                    Button {
                        withAnimation {
                            self.isPresented = false
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 20)
                
                Group {
                    Text(model[0].name)
                        .font(.system(size: 15, weight: .bold))
                    
                    HStack {
                        Text("📍 \(model[0].roadAddressName)")
                            .font(.system(size: 12, weight: .semibold))
                        Spacer()
                        Button {
                            if let url = URL(string: model[0].placeUrl){
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Text("카카오 리뷰")
                                .foregroundColor(.yellow.opacity(5.0))
                                .font(.system(size: 13, weight: .regular))
                                .overlay(alignment: .bottom) {
                                    Color.brown
                                        .frame(height: 1)
                                }
                        }
                    }
                    Text("\(model[0].addressName)")
                        .font(.system(size: 12, weight: .semibold))
                    
                    Text("\(model[0].phone)")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.blue.opacity(0.7))
                   
                }
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                
                MapView(model: model)
                    .allowsHitTesting(false)
                    .cornerRadius(15)
                    .padding(.horizontal, 0)
                    .padding(.bottom, 20)
            }
            .padding(.horizontal, 20)
        }
        .background(.white)
        .cornerRadius(15)
        .padding(.horizontal, 20)
        .frame(width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height / 1.8)
        .toolbar(.hidden, for: .tabBar)
    }
}

//#Preview {
//    MapView(model: FoodModel(name: "", location: "", placeUrl: "", hashtags: [""]), isPopup: true, isCover: true)
//}
