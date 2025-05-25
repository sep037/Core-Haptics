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
            Button("1") {
                hapticPlayer.prepare()
                hapticPlayer.playAudioWithHaptics(named: "1")
            }

            Button("2") {
                hapticPlayer.prepare()
                hapticPlayer.playAudioWithHaptics(named: "2")
            }

            Button("3") {
                hapticPlayer.prepare()
                hapticPlayer.playAudioWithHaptics(named: "3")
            }

            Button("4") {
                hapticPlayer.prepare()
                hapticPlayer.playAudioWithHaptics(named: "4")
            }

            Divider().padding(.vertical)

            Text("진동 종류").bold()

            Button("가볍고 짧은 클릭") {
                hapticPlayer.prepare()
                hapticPlayer.playPresetHaptic(type: 1)
            }

            Button("짧고 부드러운 진동") {
                hapticPlayer.prepare()
                hapticPlayer.playPresetHaptic(type: 2)
            }

            Button("묵직하고 강한 진동") {
                hapticPlayer.prepare()
                hapticPlayer.playPresetHaptic(type: 3)
            }

            Button("날카롭고 세게") {
                hapticPlayer.prepare()
                hapticPlayer.playPresetHaptic(type: 4)
            }
        }
        .padding()
    }
}
