import SwiftUI

struct VehicleView: View {
    @Binding var vehicle:Vehicle
    @State var percentComp:CGFloat = 0.0
    
    var body: some View {
        VStack(spacing: 0) {
            Text(vehicle.name)
                .font(.system(size: 45, weight: .heavy, design: .monospaced))
                .foregroundColor(Color("riv_blue"))
                .offset(x: 0, y: 20)
            
            AtlasTexture(vehicle.imageName)
                .aspectRatio(2, contentMode: .fit)
                .overlay(Color.white.opacity(0.01))
        }
    }
}
