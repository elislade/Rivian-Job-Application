import SwiftUI

struct ConnectedView: View {

    @ObservedObject var vehicle: VehicleClient

    var body: some View {
        VStack(spacing: 0) {
  
            Button(action: vehicle.disconnect) {
                Text("DISCONNECT")
                    .font(.footnote.bold())
                    .foregroundColor(Color("riv_yellow"))
                    .padding(10)
                    .padding(.horizontal)
                    .background(Capsule())
                    .foregroundColor(Color("riv_blue").opacity(0.6))
            }
            
            VStack(spacing: 16){
                if let loc = vehicle.location {
                    LocationView(location: loc)
                }
                
                ActionsView(actions: Vehicle.Action.allCases, perform: vehicle.send)
            }
            .padding()
            .background(LinearGradient.riv_blue.drawingGroup())
            .colorScheme(.dark)
            .cornerRadius(24)
            .padding(20)
        }
    }
}
