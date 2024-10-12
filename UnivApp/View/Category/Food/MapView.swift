//
//  MapView.swift
//  UnivApp
//
//  Created by 정성윤 on 10/12/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var region: MKCoordinateRegion
    var model: FoodModel
    
    init(model: FoodModel) {
        self.model = model
        self._region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.5666791, longitude: 126.9782914),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }
    
    var body: some View {
        Map(initialPosition: .region(region), interactionModes: .all) {
            Marker(model.name, coordinate: region.center)
                .tint(.orange)
        }
        .onAppear {
            geocodeAddress(model.location)
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
                region.center = location.coordinate
            }
        }
    }
}

#Preview {
    MapView(model: FoodModel(name: "", location: "", placeUrl: "", hashtags: [""]))
}
