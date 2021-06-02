import SwiftUI
import CoreLocation

struct ConnectedView: View {

    @ObservedObject var vehicle: VehicleClient

    @State private var location: CLLocation?
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: vehicle.disconnect) {
                Text("DISCONNECT")
                    .font(.footnote.weight(.heavy))
                    .foregroundColor(.white)
                    .padding(10)
                    .padding(.horizontal, 12)
                    .background(Capsule())
                    .foregroundColor(Color("riv_blue").opacity(0.4))
            }
            
            VStack(spacing: 16){
                ZStack {
                    Color.clear
                    if location != nil {
                        LocationView(location: location!)
                    } else {
                        VStack(spacing: 20){
                            ActivityIndicator()
                            Text("Loading location...")
                        }
                    }
                }.aspectRatio(1.6, contentMode: .fit)
                
                ActionsView(actions: Vehicle.Action.allCases, perform: vehicle.send)
            }
            .padding()
            .background(LinearGradient.riv_blue.drawingGroup())
            .colorScheme(.dark)
            .cornerRadius(24)
            .padding(20)
        }.onReceive(vehicle.$location, perform: { loc in
            withAnimation(.easeInOut){
                self.location = loc
            }
        })
    }
}
