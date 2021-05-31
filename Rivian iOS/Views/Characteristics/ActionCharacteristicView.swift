import SwiftUI

struct ActionCharacteristicView: View {
    
    @ObservedObject var c: Characteristic
    @State private var value: Vehicle.Action?
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: "bolt.fill")
                Text(c.characteristic.info.name).fontWeight(.semibold)
                Spacer()
                Text(value?.description ?? "nil").animation(nil)
            }
            
            VehicleActionView(characteristic: c)
        }
        .onReceive(c.$value, perform: {
            if let d = $0 {
                self.value = Vehicle.Action(d)
            }
        })
    }
}
