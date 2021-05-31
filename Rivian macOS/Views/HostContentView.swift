import SwiftUI
import AVFoundation
import CoreBluetooth

struct HostContentView: View {
    
    @State private var selectedIndex = -1
    let vehicles: [Vehicle] = [.r1t, .r1s]
    
    var body: some View {
        NavigationView {
            List {
                VStack(spacing:0) {
                    ForEach(vehicles.indices) { index in
                        Button(action: { self.selectedIndex = index }){
                             VehicleView(vehicle: self.vehicles[index])
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(index == self.selectedIndex ? Color.black.opacity(0.08) : Color.white.opacity(0.02))
                                .cornerRadius(6)
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
            }.frame(maxWidth: 380)
            
            if selectedIndex >= 0 {
                SelectedVehicle( vehicle: vehicles[selectedIndex] )
                    .frame(minWidth: 500)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HostContentView().environmentObject(PeripheralManager())
    }
}
