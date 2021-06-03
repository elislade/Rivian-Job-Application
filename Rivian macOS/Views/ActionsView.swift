import SwiftUI
import Combine

struct ActionsView: View {
    
    let actions: [Vehicle.Action]
    var sendBack: (Vehicle.Action) -> Void = { _ in }
    
    func cell(for action: Vehicle.Action) -> some View {
        VStack(spacing: 12) {
            action.image.font(.title2.weight(.heavy))
            Text(action.description).fontWeight(.bold).lineLimit(1)
            Button("Send Back", action: { sendBack(action) })
        }
        .foregroundColor(Color("riv_blue"))
        .padding(10)
        .background(Color("riv_yellow"))
        .cornerRadius(10)
    }
    
    var body: some View {
        VStack {
            if actions.count > 0 {
                ScrollView(.horizontal) {
                    HStack(spacing: 20){
                        ForEach(actions.reversed()) { action in
                            cell(for: action)
                        }
                    }
                }
                .cornerRadius(10)
                .animation(nil)
                .transition(.scale)
            } else {
                VStack(spacing: 5) {
                    Image(systemName: "iphone.radiowaves.left.and.right").font(.title)
                    Text("Listening for actions")
                }.padding()
            }
        }.animation(.spring())
    }
}
