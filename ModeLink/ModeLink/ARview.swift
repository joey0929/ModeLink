//
//  ARview.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/12.
//

import SwiftUI
import RealityKit

//var a = ObjectCaptureSession()

struct ARview: View {
    
//    @State private var session: ObjectCaptureSession?
    //@State private var session: ObjectCaptureSession?
//    var session = ObjectCaptureSession()
    
    
    var body: some View {
        ARViewContainer()
    }
}


struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}


#Preview {
    ARview()
}
