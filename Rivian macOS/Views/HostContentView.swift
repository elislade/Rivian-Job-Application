import SwiftUI
import AVFoundation
import CoreBluetooth

struct HostContentView: View {
    
    @State private var selectedIndex = -1
    let vehicles: [Vehicle] = [.r1t, .r1s]
    
    var body: some View {
        HSplitView {
            ScrollView {
                VStack(spacing: 0) {
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
                }.padding(.horizontal)
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
                    .colorScheme(.dark)
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .background(ZStack {
            LinearGradient.riv_blue
            Image("topo")
        }.edgesIgnoringSafeArea(.all))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HostContentView().environmentObject(PeripheralManager())
    }
}
