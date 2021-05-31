import Foundation
import AVFoundation

class AudioManager {
    
    static var shared = AudioManager()
    
    var players: [Vehicle.Action: AVAudioPlayer?] = [:]
    
    init?() {
        guard
            let hornURL = Bundle.main.url(forResource: "horn", withExtension: "wav"),
            let lockURL = Bundle.main.url(forResource: "lock", withExtension: "mp3"),
            let unlockURL = Bundle.main.url(forResource: "unlock", withExtension: "mp3")
        else { return nil }
        
        self.players[.honk] = try? AVAudioPlayer(contentsOf: hornURL)
        self.players[.lock] = try? AVAudioPlayer(contentsOf: lockURL)
        self.players[.unlock] = try? AVAudioPlayer(contentsOf: unlockURL)
    }
    
    func playAudio(for action: Vehicle.Action) {
        self.players[action]??.play()
    }
}
