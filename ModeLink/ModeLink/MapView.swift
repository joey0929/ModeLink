//
//  MapView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/13.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $viewModel.region,showsUserLocation: true,annotationItems: viewModel.locations) { location in
                MapMarker(coordinate: location.coordinate, tint: .blue)
            }
//            .ignoresSafeArea()
            .tint(.pink)
            LocationButton(.currentLocation) {
                viewModel.requestAllowOnceLocationPermission()
            }
            .foregroundColor(.white)
            .cornerRadius(8)
            .labelStyle(.titleAndIcon)
            .symbolVariant(.fill)
            .tint(.pink)
            .padding(.bottom,50)

        }
    }
}
#Preview {
    MapView()
}

// 定義 LocationItem 來表示每個地點的資料
struct LocationItem: Identifiable {
    let id: String
    let coordinate: CLLocationCoordinate2D
}

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // swiftlint:disable line_length
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 25.038611105581104, longitude: 121.53276716354785), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    // swiftlint:enable line_length
    
    @Published var locations: [LocationItem] = [
        LocationItem(id: "School", coordinate: CLLocationCoordinate2D(latitude: 25.03852848071074, longitude: 121.53235946779394)), // School (AppWorks 地址)
        LocationItem(id: "model1", coordinate: CLLocationCoordinate2D(latitude: 25.044233102290015, longitude: 121.53256036692702)), // 模型店 1
        LocationItem(id: "model2", coordinate: CLLocationCoordinate2D(latitude: 25.045633580459757, longitude: 121.53204103015189)), // 模型店 2
        LocationItem(id: "model3", coordinate: CLLocationCoordinate2D(latitude: 25.045683760233967, longitude: 121.53167265158353))  // 模型店 3
    ]
    let locationManager = CLLocationManager()
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        //kCLLocationAccuracyHundredMeters:100米範圍內的精度，通常定位速度較快
        //kCLLocationAccuracyNearestTenMeters : 10米範圍內的精度，適合較快速定位,太慢改用100米的
    }
    
    func requestAllowOnceLocationPermission() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()  // 檢查授權狀態後再進行定位請求
        } else {
            print("請開啟定位服務")
        }
    }
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization() // 請求使用授權
        case .restricted, .denied:
            print("定位服務被限制或拒絕")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation() // 授權後再請求位置
        @unknown default:
            break
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()  // 每當授權狀態改變時，檢查是否可以請求位置
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else {
            return
        }
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: latestLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
