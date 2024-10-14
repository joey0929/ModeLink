//
//  TestCrashView.swift
//  ModeLink
//
//  Created by 池昀哲 on 2024/10/14.
//

import SwiftUI

struct TestCrashView: View {
    func buttonTap() {
        fatalError()
    }
    var body: some View {
        Button(action: buttonTap, label: {
            Text("Crash 吧，App")
                .font(.system(size: 50))
        })
    }
}

#Preview {
    TestCrashView()
}
