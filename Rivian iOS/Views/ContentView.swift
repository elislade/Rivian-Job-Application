import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var central: CentralManager
    @State private var seleted = false
    
    @Binding var state: ViewState
    
    let vehicle: Vehicle?
    
//    let axis: Axis
//
//    var paddingEdges:Edge.Set {
//        let d = UIDevice.current.userInterfaceIdiom
//        return axis == .horizontal ?
//            [ d == .pad ? .bottom : .vertical, .trailing] :
//            [.bottom, .horizontal]
//    }
    
    var body: some View {
        VStack(spacing: 0) {
            //if state == .searching {
                Spacer()
            //}
            
            HeaderView()
            
            //if state == .searching {
                Spacer()
            //}
            
            if state == .loaded &&  vehicle != nil {
                VehicleView(vehicle: vehicle!)
                    .transition(.scale(scale: 0).combined(with: .opacity))
                    .onTapGesture {
                        if let scn = vehicle?.scannedPeriph {
                            central.connect(scn.peripheral.peripheral, options: nil)
                        }
                    }
                
                Spacer()
                
                if seleted && vehicle!.connectedPeriph != nil{
                    PeripheralView(peripheral: vehicle!.connectedPeriph!)
                        .environmentObject(vehicle!)
                        .transition(.hinge(.bottom))
                }
            }
            
        }
        .onReceive(central.$connectedPeripherals, perform: { a in
            if let v = vehicle {
                if let periph = a.first {
                    v.connectedPeriph = periph
                    withAnimation(.spring().speed(0.5)){
                        seleted = true
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
