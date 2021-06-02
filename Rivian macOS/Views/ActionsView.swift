import SwiftUI
import Combine

struct ActionsView: View {
    
    @ObservedObject var vehicle: VehicleHost
    
    let actions: [Vehicle.Action]
    
    func cell(for action: Vehicle.Action) -> some View {
        VStack(spacing: 12) {
            action.image.font(.title2.weight(.heavy))
            Text(action.description).fontWeight(.bold).lineLimit(1)
            Button("Send Back", action: { vehicle.send(action) })
        }
        .foregroundColor(Color("riv_blue"))
        .padding(10)
        .background(Color("riv_yellow"))
        .cornerRadius(14)
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
