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
    @State private var selectedLocationID: String? // 用於存儲當前選中的地點 ID
    @State private var isShowingToyStores = false // 用於控制是否顯示公仔店家的標記
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: isShowingToyStores ? viewModel.toyStoreLocations : viewModel.locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    VStack {
                        Button(action: {
                            if selectedLocationID == location.id {
                                selectedLocationID = nil
                            } else {
                                selectedLocationID = location.id
                            }
                        }) {
                            // 根據標記類型顯示不同的圖標
                            if isShowingToyStores {
                                Image(systemName: "teddybear.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.blue)
                            } else {
                                Image(systemName: "mappin.and.ellipse")
                                    .font(.system(size: 30))
                                    .frame(width: 30)
                                    .foregroundColor(.red)
                            }
                        }
                        // 當選中的地點 ID 與當前標記匹配時顯示名稱
                        if selectedLocationID == location.id {
                            Text(location.id)
                                .font(.caption)
                                .foregroundColor(.black)
                                .padding(5)
                                .background(Color.white.opacity(0.7))
                                .cornerRadius(8)
                                .shadow(radius: 5)
                        }
                    }
                }
            }
            .ignoresSafeArea()
            // 顯示 "當前位置" 和 "公仔店家" 的按鈕
            HStack {
                Button(action: {
                    viewModel.requestAllowOnceLocationPermission()
                }) {
                    Label("當前位置", systemImage: "location.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.pink)
                        .cornerRadius(8)
                }
                // 顯示/隱藏公仔店家按鈕
                Button(action: {
                    isShowingToyStores.toggle()
                }) {
                    Label(isShowingToyStores ? "模型店家" : "公仔店家", systemImage: isShowingToyStores ? "mappin.and.ellipse" : "teddybear.fill")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(10)
                        .background(isShowingToyStores ? Color.theme : Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding(.bottom, 100)

            ZStack {
                VStack {
                    Spacer()
                }
                Color.white.frame(height: 80).padding(.top, 800)
            }
        }
        .onAppear {
            viewModel.fetchLocationsFromFirebase()
            viewModel.fetchToyStoreLocations2()
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
    @Published var toyStoreLocations: [LocationItem] = [] // 公仔店家的地點
    
    let locationManager = CLLocationManager()
    let db = Firestore.firestore()
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    // 拉取公仔店家的地點
    func fetchToyStoreLocations2() {
        db.collection("toyStores").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching toy store locations: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else {
                print("No toy store documents found")
                return
            }
            self.toyStoreLocations = documents.compactMap { doc -> LocationItem? in
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
