import SwiftUI
import CoreBluetooth

enum ViewState {
    case searching, loaded
}

struct RootView: View {
    
    @EnvironmentObject private var central: CentralManager
    @State private var state: ViewState = .searching
    @State private var firstVehicle: Vehicle?
    
    func central(_ state: CBManagerState) {
        if state == .poweredOn {
            central.scanForPeripherals(
                withServices: [.r1s_main_id, .r1t_main_id],
                options: [CBPeripheralManagerOptionShowPowerAlertKey: true]
            )
        }
    }
    
    func scanned(_ peripherals: [ScannedPeripheral]) {
        if let periph = peripherals.first {
            let v = periph.asVehicle()
            v?.scannedPeriph = periph
            withAnimation(.spring().speed(0.2)) {
                firstVehicle = v
                state = .loaded
            }
        }
    }
    
    var circleTrany: AnyTransition {
        .asymmetric(
            insertion: .scale(scale: 0.05),
            removal: .scale(scale: 0)
        )
    }
    
    var body: some View {
        ContentView(state: $state, vehicle: firstVehicle)
            .background(
                ZStack {
                    LinearGradient.riv_blue
                    
                    if state == .searching {
                        RadiatingCicles()
                            .foregroundColor(.white)
                            .transition(.scale(scale: 0).combined(with: .opacity))
                            .zIndex(2)
                    } else {
                        Circle()
                            .scaleEffect(2.5)
                            .foregroundColor(.white)
                            .transition(circleTrany)
                            .zIndex(3)
                    }
                    
                    Image("topo").opacity(state == .searching ? 1 : 0.7).zIndex(4)
                }.drawingGroup()
            )
            .colorScheme(state == .searching ? .dark : .light)
            .onReceive(central.$state, perform: central)
            .onReceive(central.$scannedPeripherals, perform: scanned)
            .edgesIgnoringSafeArea(.all)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView().environmentObject(CentralManager())
    }
}
