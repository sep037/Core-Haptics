import Foundation
import AVFoundation
import CoreHaptics

class HapticPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    private var engine: CHHapticEngine?
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?

    func prepare() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("햅틱 엔진 시작 실패: \(error)")
        }
    }

    func playAudioWithHaptics() {
        guard let url = Bundle.main.url(forResource: "sample", withExtension: "m4a") else {
            print("오디오 파일을 찾을 수 없습니다.")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.isMeteringEnabled = true
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()

            startMonitoring()
        } catch {
            print("오디오 재생 실패: \(error)")
        }
    }

    private func startMonitoring() {
        stopMonitoring()  // 중복 타이머 방지

        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.audioPlayer?.updateMeters()
            if let power = self.audioPlayer?.averagePower(forChannel: 0) {
                let intensity = self.normalizeDB(power)

                // 강한 소리일 때만 햅틱 실행
                if intensity > 0.3 {
                    self.playHaptic(intensity: intensity)
                }
            }
        }
    }

    private func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopMonitoring()
        print("오디오 재생 종료")
    }

    /// 데시벨 정규화: -20dB 이상만 유효하게 취급
    private func normalizeDB(_ db: Float) -> Float {
        let clamped = max(-20, min(0, db))  // -20dB보다 크고, 0dB보다 작게
        return (clamped + 20) / 20          // 결과: 0.0 ~ 1.0
    }

    private func playHaptic(intensity: Float) {
        guard let engine = engine else { return }

        let intensityParam = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)
        let sharpnessParam = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)

        let event = CHHapticEvent(eventType: .hapticContinuous,
                                  parameters: [intensityParam, sharpnessParam],
                                  relativeTime: 0,
                                  duration: 0.1)

        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            let player = try engine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("햅틱 재생 실패: \(error)")
        }
    }
}
