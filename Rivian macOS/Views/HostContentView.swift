import SwiftUI
import AVFoundation
import CoreBluetooth

struct HostContentView: View {
    
    @State private var selectedIndex = -1
    let vehicles: [VehicleHost] = [.r1tHost, .r1sHost]
    
    func select(_ index: Int){
        withAnimation(.spring().speed(0.5)) {
            selectedIndex = index
        }
    }
    
    var body: some View {
        HSplitView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 300, maximum: 800), spacing: 20, alignment: .center)]){
                    ForEach(vehicles.indices) { index in
                        Button(action: { select(index) }){
                             VehicleView(vehicle: self.vehicles[index])
                                .background(index == self.selectedIndex ? Color("riv_yellow") : Color.white.opacity(0.02))
                                .cornerRadius(15)
                                .overlay(Color.white.opacity(0.001))
                        }
                    }
                }
                .padding(.horizontal)
                .buttonStyle(PlainButtonStyle())
                
            }
            .frame(minWidth: 320)
            .background(ZStack {
                Color.white
                Image("topo").resizable().scaledToFill().opacity(0.8)
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
            Image("topo").resizable().scaledToFill()
        }.edgesIgnoringSafeArea(.all))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HostContentView()
    }
}
