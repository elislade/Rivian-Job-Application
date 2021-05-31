import SwiftUI
import Combine

struct ActionsView: View {
    
    @EnvironmentObject private var bt: PeripheralManager
    @ObservedObject var vehicle: Vehicle
    
    let actions: [Vehicle.Action]
    
    func send(_ action: Vehicle.Action){
        self.bt.send(action.data, to: .main_action(for: self.vehicle))
    }
    
    func cell(for action: Vehicle.Action) -> some View {
        VStack(spacing: 20) {
            action.image.imageScale(.large).frame(width: 40)
            Text(action.description).fontWeight(.bold).lineLimit(1)
            Button("Send Back", action: { self.send(action) })
        }.padding(.vertical, 10)
    }
    
    var body: some View {
        Group {
            if actions.count > 0 {
                ScrollView(.horizontal) {
                    HStack(spacing: 20){
                        ForEach(actions.reversed()) { action in
                            cell(for: action)
                        }
                    }.padding()
                }
            }
        }
    }
}
