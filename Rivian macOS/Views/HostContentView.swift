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
                        Button(action: { withAnimation(.spring().speed(0.5)) {
                            selectedIndex = index }
                        }){
                             VehicleView(vehicle: self.vehicles[index])
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(index == self.selectedIndex ? Color("riv_yellow") : Color.white.opacity(0.02))
                                .cornerRadius(15)
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .frame(minWidth: 320)
            .background(ZStack {
                Color.white
                Image("topo").opacity(0.8)
            }.edgesIgnoringSafeArea(.all))
            .colorScheme(.light)
            
            if selectedIndex >= 0 {
                SelectedVehicle( vehicle: vehicles[selectedIndex] )
                    .frame(minWidth: 500)
                    .background(Color("riv_darkblue").edgesIgnoringSafeArea(.all))
                    .colorScheme(.dark)
            }
        }
        .background(Color("riv_darkblue").edgesIgnoringSafeArea(.all))
        //.frame(maxWidth: selectedIndex < 0 ? 320 : 1200)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HostContentView().environmentObject(PeripheralManager())
    }
}
