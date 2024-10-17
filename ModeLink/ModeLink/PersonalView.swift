//
//  PersonalView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/9/24.
//

import SwiftUI

struct BlockedUser: Identifiable {
    let id: String
    let name: String
}

struct PersonalView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = PersonalViewModel()
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                // 用戶頭像與名稱
                VStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)
                    
                    Text("Hello, \(viewModel.userName)")
                        .font(.title2)
                        .bold()
                        .padding(.bottom, 10)
                }
                .padding(.top, 170)
                .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    Button(action: {
                        viewModel.fetchBlockedUsers()
                        viewModel.showBlockedList.toggle()
                    }) {
                        Text(viewModel.showBlockedList ? "關閉封鎖列表" : "顯示封鎖列表")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.clear)
                            .foregroundColor(.black)
                            .cornerRadius(12)
                    }
                    .padding(.leading, 15)

                    Divider()
                        .frame(width: 100)
                        .frame(alignment: .leading)
                        .background(Color.gray)
                        .padding(.leading, 30)
                        .padding(.top, -18)
                }
                
                // 這裡的封鎖列表
                VStack {
                    if viewModel.showBlockedList {
                        VStack {
                            List(viewModel.blockedUsers) { blockedUser in
                                HStack {
                                    Text(blockedUser.name)
                                    Spacer()
                                    Button {
                                        viewModel.unblockUser(userId: blockedUser.id)
                                    } label: {
                                        Text("解除封鎖")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                            .listStyle(PlainListStyle())
                            .cornerRadius(10)
                        }
                        .cornerRadius(10)
                        .padding(.horizontal,5)
                        .padding(.top,-30)
                    } else {
                        Rectangle()
                            .fill(Color.clear)
                    }
                }
                .frame(height: 200)
                .padding(.horizontal)
                
                VStack(spacing: 15) {
                    Button(action: {
                        viewModel.logout()
                    }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("登出")
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.28, green: 0.28, blue: 0.28))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    
                    Button(action: {
                        viewModel.deleteAccount()
                    }) {
                        Text("刪除帳號")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                            .foregroundColor(.black)
                            .cornerRadius(12)
                    }
                    .padding(.top, -5)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                Spacer()
            }
            
            ZStack {
                VStack {
                    Spacer()
                }
                Color.white.frame(height: 130).padding(.top, 800)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.backward").foregroundColor(.black)
            }
        })
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("個人設定")
                    .font(.custom("LexendDeca-Medium", size: 20))
                    .bold()
                    .foregroundStyle(Color(.black))
            }
        }
        .onAppear {
            viewModel.fetchUserName()
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.gray, Color.white]),
                startPoint: .bottom,
                endPoint: .top
            )
        )
    }
}

#Preview {
    PersonalView()
}
