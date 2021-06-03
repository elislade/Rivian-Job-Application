import SwiftUI

struct HostContentView: View {
    
    @Namespace var ns
    @State private var selectedIndex = -1
    
    let selectedVehicle = TextureControl()
    let vehicles: [VehicleHost] = [.r1tHost, .r1sHost]
    
    func select(_ index: Int){
        withAnimation(.spring()) {
            selectedIndex = index
        }
    }
    
    var body: some View {
        VStack {
            if selectedIndex < 0 {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 300, maximum: 800), spacing: 20, alignment: .center)]){
                        ForEach(vehicles.indices) { index in
                            Button(action: { select(index) }){
                                 VehicleView(vehicle: self.vehicles[index])
                                    .overlay(Color.white.opacity(0.001))
                                    .matchedGeometryEffect(id: vehicles[index].id, in: ns)
                            }
                        }
                    }
                    .padding()
                    .buttonStyle(PlainButtonStyle())
                }
                .colorScheme(.light)
                .zIndex(1)
            }
            
            if selectedIndex >= 0 {
                VehicleView(vehicle: vehicles[selectedIndex], textureControl: selectedVehicle)
                    .overlay(Button("Teardown", action: {
                        vehicles[selectedIndex].teardown()
                        selectedVehicle.set(percent: 1, animated: true) {
                            withAnimation(.spring()){
                                selectedIndex = -1
                            }
                        }
                    }).padding(), alignment: .bottom)
                    .padding()
                    .matchedGeometryEffect(id: vehicles[selectedIndex].id, in: ns)
                    .onAppear(perform: {
                        selectedVehicle.set(percent: 1)
                        selectedVehicle.set(percent: 0, animated: true)
                    }).zIndex(3)
                
                SelectedVehicle(vehicle: vehicles[selectedIndex])
                    .colorScheme(.dark)
                    .background(ZStack {
                        LinearGradient.riv_blue
                        Image("topo").resizable().scaledToFill()
                    })
                    .cornerRadius(15)
                    .zIndex(2)
                    .padding()
                    .transition(.move(edge: .bottom))
            }
        }
        .frame(width: 600)
        .background(ZStack {
            Color.white
            Image("topo").resizable().scaledToFill().opacity(0.8)
        }.edgesIgnoringSafeArea(.all)
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HostContentView()
    }
}
