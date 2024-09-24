//
//  MapView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/13.
//

import SwiftUI
import MapKit
import FirebaseFirestore
import CoreLocationUI

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $viewModel.region,showsUserLocation: true,annotationItems: viewModel.locations) { location in
               // MapMarker(coordinate: location.coordinate, tint: .blue)
                MapAnnotation(coordinate: location.coordinate) {
                    VStack {
                        // 使用自定義圖示，這裡可以是任何 SwiftUI 視圖
                        Image(systemName: "cart")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                        // 也可以顯示文字或其他視覺元素
                        Text(location.id)
                            .font(.caption)
                            .foregroundColor(.black)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(8)
                    }
                }
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
            .padding(.bottom, 50)
        }
        .onAppear {
            viewModel.fetchLocationsFromFirebase()
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
    @Published var locations: [LocationItem] = []
    let locationManager = CLLocationManager()
    let db = Firestore.firestore()  // 初始化 Firestore
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        //kCLLocationAccuracyHundredMeters:100米範圍內的精度，通常定位速度較快
        //kCLLocationAccuracyNearestTenMeters : 10米範圍內的精度，適合較快速定位,太慢改用100米的
    }
    // 從 Firestore 拉取 locations
    func fetchLocationsFromFirebase() {
        db.collection("locations").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching locations: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else {
                print("No documents found")
                return
            }
            self.locations = documents.compactMap { doc -> LocationItem? in
                let data = doc.data()
                guard let id = data["id"] as? String,
                      let latitude = data["latitude"] as? CLLocationDegrees,
                      let longitude = data["longitude"] as? CLLocationDegrees else {
                    return nil
                }
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                return LocationItem(id: id, coordinate: coordinate)
            }
        }
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
