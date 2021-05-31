import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var central: CentralManager
    @State private var seleted = false
    
    @Binding var state: ViewState
    
    let vehicle: Vehicle?
    
    func connect() {
        if let scn = vehicle?.scannedPeriph {
            central.connect(scn.peripheral.peripheral, options: nil)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            HeaderView().onTapGesture {
                withAnimation(.spring().speed(0.3)){
                    state = state == .searching ? .loaded : .searching
                }
            }
            
            Spacer()
            
            if state == .loaded && vehicle != nil {
                VehicleView(vehicle: vehicle!)
                    .transition(.offset(y: 700))
                    .zIndex(2)
                    .onTapGesture(perform: connect)
                
                Spacer()
                
                if seleted && vehicle!.connectedPeriph != nil {
                    PeripheralView(peripheral: vehicle!.connectedPeriph!)
                        .transition(.hinge(.bottom))
                        .zIndex(5)
                        .environmentObject(vehicle!)
                }
            }
            
        }
        .onReceive(central.$connectedPeripherals, perform: { a in
            if let v = vehicle {
                if let periph = a.first {
                    withAnimation(.easeInOut(duration: 2)){
                        v.connectedPeriph = periph
                        seleted = true
                    }
                } else {
                    withAnimation(.easeOut(duration: 2)){
                        v.connectedPeriph = nil
                        seleted = false
                    }
                }
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(state: .constant(.searching), vehicle: .r1s)
    }
}
