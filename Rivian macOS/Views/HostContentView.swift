import SwiftUI
import AVFoundation
import CoreBluetooth

struct HostContentView: View {
    @State var selectedIndex = -1
    @State var vehicles:[Vehicle] = [.r1t, .r1s]
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack {
                    Image("rivian").resizable().scaledToFit().frame(height: 28)
                    Spacer()
                }
                .padding(.horizontal)
                .frame(height: 50)
                .background(Color.white)
                
                Divider()
                
                ScrollView {
                    VStack(spacing:0) {
                        ForEach(vehicles.indices) { index in
                            Button(action: { self.selectedIndex = index }){
                                 VehicleView(vehicle: self.$vehicles[index])
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background(index == self.selectedIndex ? Color.black.opacity(0.08) : Color.white.opacity(0.02))
                                    .cornerRadius(6)
                                    .padding([.horizontal, .top])
                            }.buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                Spacer()
            }.frame(width: 280)
            
            
            if selectedIndex >= 0 {
                Divider()
                SelectedVehicle( vehicle: $vehicles[selectedIndex] ).frame(minWidth: 500)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HostContentView().environmentObject(PeripheralManager())
    }
}
