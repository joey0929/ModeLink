//
//  PostView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/15.
//

import SwiftUI

struct PostView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var title = ""
    @State private var content = ""
    
    var body: some View {
        VStack {
            TextField("標題", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextEditor(text: $content)
                .frame(height: 200)
                .border(Color.gray, width: 1)
                .padding()
            
            Button(action: {
                // 這裡可以添加貼文的提交邏輯
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("提交")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("新貼文")
        .padding()
    }
}



#Preview {
    PostView()
}
