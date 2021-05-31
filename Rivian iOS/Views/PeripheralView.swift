import SwiftUI
import CoreBluetooth

struct PeripheralView: View {
    
    @ObservedObject var peripheral: Peripheral
    
    func discoverServices() {
        withAnimation(.easeIn) {
            self.peripheral.discoverServices(
                [.r1t_main_id, .r1s_main_id]
            )
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
  
            Button(action: peripheral.disconnect) {
                Text("DISCONNECT")
                    .font(.footnote.bold())
                    .foregroundColor(Color("riv_yellow"))
                    .padding(10)
                    .padding(.horizontal)
                    .background(Capsule())
                    .foregroundColor(Color("riv_blue").opacity(0.6))
            }
            
            if peripheral.services.count > 0 {
                ForEach(peripheral.services) { s in
                ServiceView(service: s)
                    .cornerRadius(24)
                    .padding(20)
                }
            }
        }.onAppear(perform: discoverServices).animation(.easeIn)
    }
}
