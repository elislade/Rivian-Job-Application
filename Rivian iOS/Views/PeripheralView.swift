import SwiftUI
import CoreBluetooth

struct PeripheralView: View {
    
    @EnvironmentObject private var vehicle: Vehicle
    @ObservedObject var peripheral: Peripheral
    
    func discoverServices() {
        self.peripheral.discoverServices(
            [.r1t_main_id, .r1s_main_id]
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                Button(action: peripheral.disconnect) {
                    Text("DISCONNECT")
                        .font(.footnote.bold())
                        .foregroundColor(Color("riv_yellow"))
                        .padding(10)
                        .padding(.horizontal)
                        .background(Capsule())
                        .foregroundColor(Color("riv_blue").opacity(0.6))
                }
                Spacer()
            }
            
            if peripheral.services.first != nil {
                ServiceView(service: peripheral.services.first!)
                    .cornerRadius(24)
                    .padding(20)
            }
        }.onAppear(perform: discoverServices)
    }
}
