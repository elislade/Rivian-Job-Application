import Foundation
import AVFoundation

class Vehicle: ObservableObject {
    
    let name: String
    let uuidString: String
    let imageName: String
    
    init(name:String, uuidString:String, imageName:String){
        self.name = name
        self.uuidString = uuidString
        self.imageName = imageName
    }
    
    @Published var isSetup = false
    @Published var isAdvert = false
    @Published var actions: [Vehicle.Action] = []
    
    var honkPlayer:AVAudioPlayer? = AVAudioPlayer()
    var lockPlayer:AVAudioPlayer? = AVAudioPlayer()
    var unlockPlayer:AVAudioPlayer? = AVAudioPlayer()
    
    private let players:[Action: AVAudioPlayer] = [
        .honk : try! AVAudioPlayer(
            contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "horn", ofType: "wav")! )
        ),
        .lock : try! AVAudioPlayer(
            contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "lock", ofType: "mp3")! )
        ),
        .unlock : try! AVAudioPlayer(
            contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "unlock", ofType: "mp3")! )
        )
    ]
    
    func playAudio(for action:Vehicle.Action) {
        players[action]?.pause()
        players[action]?.currentTime = 0
        players[action]?.play()
    }
}


extension Vehicle:Hashable, Identifiable {
    static func == (lhs: Vehicle, rhs: Vehicle) -> Bool {
        lhs.uuidString == rhs.uuidString
    }
    
    func hash(into hasher: inout Hasher) {
        uuidString.hash(into: &hasher)
    }
}

extension Vehicle {
    static let r1t = Vehicle(
        name: "R1T",
        uuidString: "1212AE20-2D4F-4B64-AE40-EFA14B00B82F",
        imageName: "r1t"
    )
    
    static let r1s = Vehicle(
        name: "R1S",
        uuidString: "DCE846F8-2944-44A9-A55B-AE8220068273",
        imageName: "r1s"
    )
    
    static func get(from string:String) -> Vehicle {
        string.lowercased().contains(r1t.name.lowercased()) ? r1t : r1s
    }
}
