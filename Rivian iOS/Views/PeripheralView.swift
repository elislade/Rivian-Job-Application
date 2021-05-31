import SwiftUI
import CoreBluetooth

struct PeripheralView: View {
    
    @EnvironmentObject var vehicle:Vehicle
    @ObservedObject var peripheral:Peripheral
    
    func discoverServices() {
        self.peripheral.discoverServices(
            [.r1t_main_id, .r1s_main_id]
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Revian " + vehicle.name)
                    .fontWeight(.semibold).font(.system(size: 20))
                Spacer()
                Button(action: peripheral.disconnect) {
                    Text("DISCONNECT")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(5)
                        .padding(.horizontal, 7)
                        .background(Color.accentColor).cornerRadius(13)
                        .foregroundColor(Color("riv_blue"))
                }
            }
            .frame(height: 52).padding(.horizontal)
            .overlay(Divider(), alignment: .bottom)
            .animation(nil)
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(peripheral.services) {
                        ServiceView(service: $0)
                        Divider()
                    }
                }.frame(minWidth: 0, maxWidth: 800).padding(.horizontal)
            }
        }.onAppear(perform: discoverServices)
    }
}
