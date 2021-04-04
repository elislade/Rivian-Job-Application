import SwiftUI
import Combine

struct ActionsView: View {
    
    @EnvironmentObject private var bt: PeripheralManager
    @ObservedObject var vehicle: Vehicle
    
    let actions: [Vehicle.Action]
    
    func send(_ action: Vehicle.Action){
        self.bt.send(action.data, to: .main_action(for: self.vehicle))
    }
    
    var body: some View {
        List {
            Section(header:Text("Action").fontWeight(.semibold)){ EmptyView() }
            
            VStack(spacing:0) {
                ForEach(actions) { action in
                    HStack {
                        Text(action.description)
                        Spacer()
                        Button("Send Back", action: { self.send(action) })
                    }
                    .padding(.vertical, 5)
                    .overlay(Divider(), alignment: .bottom)
                }
            }
        }
        .listStyle(PlainListStyle())
        .frame(minHeight: 150)
        .border(Color.black.opacity(0.15))
    }
}
