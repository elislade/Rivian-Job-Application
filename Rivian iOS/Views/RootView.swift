import SwiftUI
import CoreBluetooth

enum ViewState {
    case searching, loaded
}

struct RootView: View {
    
    @State private var state: ViewState = .searching
    @State private var firstVehicle: VehicleClient?
    
    var circleTrany: AnyTransition {
        .asymmetric(
            insertion: .scale(scale: 0.05),
            removal: .scale(scale: 0)
        )
    }
    
    func toggleSearching() {
        withAnimation(.easeInOut(duration: 0.9)){
            state = state == .searching ? .loaded : .searching
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Button(action: toggleSearching) { HeaderView() }
            Spacer()
            
            if state == .loaded && firstVehicle != nil {
                VehicleLinkView(vehicle: firstVehicle!)
                    .transition(
                        .scale(scale: 0.8)
                            .combined(with: .opacity)
                            .combined(with: .offset(y: 350))
                    )
            }
        }
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
        .edgesIgnoringSafeArea(.all)
        .onReceive(RivianScanner.shared.$peripherals, perform: { p in
            print("ascdc", p)
            if let f = p.first {
                withAnimation(.easeInOut(duration: 1.3)){
                    firstVehicle = f.asVehicleClient
                    state = .loaded
                }
            }
        })
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
