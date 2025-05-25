//
//  ContentView.swift
//  Haptic
//
//  Created by Seungeun Park on 5/24/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var hapticPlayer = HapticPlayer()

    var body: some View {
        VStack(spacing: 20) {
            Text("녹음 파일 + 햅틱 동기화")
                .font(.title2)

            Button("햅틱과 함께 재생") {
                hapticPlayer.prepare()
                hapticPlayer.playAudioWithHaptics()
            }
        }
        .padding()
    }
}
