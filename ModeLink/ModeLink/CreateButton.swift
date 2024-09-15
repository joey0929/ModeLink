//
//  CreateButton.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/15.
//

import SwiftUI
import RealityKit

@MainActor
struct CreateButton: View {
    let session: ObjectCaptureSession
    
    var body: some View {
        
        
        HStack {
            
            Button(action: {
                performAction()
            }, label: {
                Text(label)
                    .foregroundStyle(.white)
                    .padding()
                    .background(.tint)
                    .clipShape(Capsule())
            })
            
            // Cancel button
            if session.state == .detecting || session.state == .capturing {
                Button(action: {
                    cancelAction()
                }, label: {
                    Text("Cancel")
                        .foregroundStyle(.white)
                        .padding()
                        .background(Color.red)
                        .clipShape(Capsule())
                })
            }
            
            
            
        }
        
    }
    
    private var label: LocalizedStringKey {
        if session.state == .ready {
            return "Start detecting"
        } else if session.state == .detecting {
            return "Start capturing"
        } else {
            return "Undefined"
        }
    }
    
    private func performAction() {
        if session.state == .ready {
            let isDetecting = session.startDetecting()
            print(isDetecting ? "▶️Start detecting" : "😨Not start detecting")
        } else if session.state == .detecting {
            session.startCapturing()
        } else {
            print("Undefined")
        }
    }
    
    private func cancelAction() {
           if session.state == .detecting || session.state == .capturing {
               session.resetDetection() // 返回到偵測狀態
               print("Cancelled capturing, back to detecting")
           }
       }
    
}
//#Preview {
//    CreateButton()
//}
