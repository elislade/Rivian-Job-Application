import SwiftUI
import AVFoundation
import CoreBluetooth

struct HostContentView: View {
    
    @State private var selectedIndex = -1
    let vehicles: [VehicleHost] = [.r1tHost, .r1sHost]
    
    func select(_ index: Int){
        withAnimation(.spring()) {
            selectedIndex = index
        }
    }
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 300, maximum: 800), spacing: 20, alignment: .center)]){
                    ForEach(vehicles.indices) { index in
                        if selectedIndex == index || selectedIndex < 0 {
                            Button(action: { select(index) }){
                                 VehicleView(vehicle: self.vehicles[index])
                                    .background(index == self.selectedIndex ? Color("riv_yellow").opacity(0.3) : Color.clear)
                                    .cornerRadius(15)
                                    .overlay(Color.white.opacity(0.001))
                            }//.disabled(selectedIndex >= 0)
                        }
                    }
                }
                .padding()
                .buttonStyle(PlainButtonStyle())
                
            }
            .background(ZStack {
                Color.white
                Image("topo").resizable().scaledToFill().opacity(0.8)
            }.edgesIgnoringSafeArea(.all)
            )
            .colorScheme(.light)
            .zIndex(1)
            
            if selectedIndex >= 0 {
                SelectedVehicle(vehicle: vehicles[selectedIndex] )
                    .colorScheme(.dark)
                    .background(ZStack {
                        LinearGradient.riv_blue
                        Image("topo").resizable().scaledToFill()
                    })
                    .clipped()
                    .zIndex(2)
                    .transition(.move(edge: .bottom))
            }
        }.frame(width: 600)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HostContentView()
    }
}
