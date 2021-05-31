import SwiftUI

struct ActionCharacteristicView: View {
    
    @ObservedObject var c: Characteristic
    @State private var value: Vehicle.Action?
    
    func send(_ action: Vehicle.Action){
        if c.canSendWriteWithoutResponse {
            c.write(
                data: action.data,
                type: .withoutResponse
            )
        }
    }
    
    var body: some View {
        ActionsView(perform: send)
            .onReceive(c.$value, perform: {
                if let d = $0 {
                    self.value = Vehicle.Action(d)
                }
            })
    }
}
