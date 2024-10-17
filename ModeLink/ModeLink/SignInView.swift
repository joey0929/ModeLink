//
//  SignInView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/26.
//

import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @StateObject private var viewModel = SignInViewModel()
    var body: some View {
        VStack {
            Spacer()
            Text("Welcome to ModeLink!")
                .font(.custom("LexendDeca-SemiBold", size: 51))
                .foregroundStyle(Color(.black).opacity(0.8))
                .bold()
                .padding(.top, 60)
            
            Spacer()
            Text("Please sign in with your Apple ID:")
                .font(.custom("LexendDeca-Bold", size: 16))
                .foregroundColor(.theme)
                .padding(.bottom, 0)
            
            if !viewModel.isLoggedIn {
                SignInWithAppleButton(
                    .signIn,
                    onRequest: { request in
                        viewModel.prepareAppleRequest(request: request)
                    },
                    onCompletion: viewModel.handleSignInWithApple
                )
                .signInWithAppleButtonStyle(.black)
                .frame(height: 50)
                .padding(.horizontal, 15)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding()
                .padding(.top, -15)
                
            } else {
                ContentView()
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.theme, Color(.white)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}
#Preview {
    SignInView()
}
