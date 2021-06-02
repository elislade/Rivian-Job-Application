import SwiftUI

struct VehicleLinkView: View {
    
    @ObservedObject var vehicle: VehicleClient
    @State private var isConnected = false
    
    var body: some View {
        Group {
            Button(action: vehicle.connect){
                VehicleView(vehicle: vehicle)
            }
            .disabled(isConnected)
            .zIndex(2)
            
            if isConnected {
                ConnectedView(vehicle: vehicle)
                    .transition(.hinge(.bottom))
                    .zIndex(5)
            } else {
                Spacer()
            }
        }
        .onReceive(vehicle.$isConnected, perform: { flag in
            withAnimation(.spring()){
                isConnected = flag
            }
        })
    }
}

struct VehicleLinkView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleLinkView(vehicle: .r1tClient)
    }
}
