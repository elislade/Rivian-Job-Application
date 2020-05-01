import SwiftUI

struct ContentView: View {
    
    @State var proxy:GeometryProxy
    @State var selectedPeripheral:Peripheral?
    @State var selectedVehicle:Vehicle = .r1s
    @State var vehicles:[Vehicle] = [.r1t, .r1s]
    
    @Binding var axis:Axis
    
    func radius(_ proxy:GeometryProxy) -> CGFloat {
        return 8
    }
    
    func padding(_ proxy:GeometryProxy) -> CGFloat {
        proxy.safeAreaInsets.bottom > 0 ? 0 : 4
    }
    
    let grad = LinearGradient(
        gradient: Gradient(colors: [Color("riv_blue"), Color("riv_darkblue")]),
        startPoint: UnitPoint(x: 0, y: 0),
        endPoint: UnitPoint(x: 0, y: 1)
    )
    
    var paddingEdges:Edge.Set {
        let d = UIDevice.current.userInterfaceIdiom
        return axis == .horizontal ?
            [ d == .pad ? .bottom : .vertical, .trailing] :
            [.bottom, .horizontal]
    }
    
    var body: some View {
        Group {
            LayoutView($axis) {
                VStack(spacing:0) {
                    HeaderView().zIndex(10)
                    ScannerView(selectedPeripheral: $selectedPeripheral, selectedVehicle:$selectedVehicle)
                        //.environmentObject(selectedVehicle!)
                }
                
                if self.selectedPeripheral != nil {
                    PeripheralView(peripheral: self.selectedPeripheral!)
                        .environmentObject(selectedVehicle)
                        .colorScheme(.dark)
                        .background(self.grad)
                        .cornerRadius(radius(proxy))
                        .padding(self.paddingEdges, self.padding(proxy))
                        .transition(.move(edge: self.axis == .horizontal ? .trailing : .bottom ))
                        .frame(maxWidth: self.axis == .horizontal ? 400 : .infinity)
                }
            }
        }
        .accentColor(Color("riv_yellow"))
        .background(Image("topo").resizable().scaledToFill().opacity(0.3))
        .edgesIgnoringSafeArea([.bottom, .horizontal])
        .animation(.spring(response: 0.3, dampingFraction: 0.75))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader {
            ContentView(proxy: $0, axis: .constant(.horizontal))
        }
    }
}
