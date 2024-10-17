//
//  ArticleCardView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/10/17.
//

import SwiftUI
import Kingfisher

struct ArticleCardView: View {
    let post: Post2
    let onImageTap: (String) -> Void
    let onLikeTap: () -> Void
    let onMenuTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
                VStack(alignment: .leading, spacing: 4) {
                    Text(post.userName)
                        .font(.headline)
                    Text(basicFormattedDate(from: post.timestamp))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text(post.county).font(.headline)
                Button(action: onMenuTap) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.black)
                        .frame(width: 30, height: 30)
                }
            }
            Text(post.title)
                .font(.title2)
                .bold()
                .allowsHitTesting(false)
            Text(post.content)
                .font(.headline)
                .foregroundColor(.black.opacity(0.8))
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .allowsHitTesting(false)
            if let imageURL = post.imageURL {
                KFImage(URL(string: imageURL))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: 280)
                    .clipped()
                    .cornerRadius(10)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        onImageTap(imageURL)
                    }
            }
            HStack {
                Button(action: onLikeTap) {
                    HStack {
                        Image(systemName: post.isLiked ? "hand.thumbsup.fill" : "hand.thumbsup").padding(.leading,5)
                        Text("\(post.likes)")
                    }
                }
                .buttonStyle(BorderlessButtonStyle())
                .padding(.trailing, 16)
                Spacer()
            }
            .padding(.top, 10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }

    // 日期格式化方法
    func basicFormattedDate(from date: Date) -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        return "\(year)-\(month)-\(day) \(hour):\(minute)"
    }
}
//
//#Preview {
//    ArticleCardView()
//}
