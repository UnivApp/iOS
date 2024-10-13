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
    @State private var region: MKCoordinateRegion = .init(center: CLLocationCoordinate2D(latitude: 37.5666791, longitude: 126.9782914), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    var model: FoodModel
    var isPopup: Bool
    var isCover: Bool
    
    var body: some View {
        ZStack {
            if isPopup {
                Map(interactionModes: .all) {
                    Marker(model.name, coordinate: region.center)
                        .tint(.orange)
                }
                .onAppear {
                    geocodeAddress(model.location)
                }
            } else {
                Map(initialPosition: .region(region), interactionModes: .all) {
                    Marker(model.name, coordinate: region.center)
                        .tint(.orange)
                }
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
    
    private func geocodeAddress(_ address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
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
                    region = MKCoordinateRegion(
                        center: location.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                    )
                }
            }
        }
    }
}

#Preview {
    MapView(model: FoodModel(name: "", location: "", placeUrl: "", hashtags: [""]), isPopup: true, isCover: true)
}
