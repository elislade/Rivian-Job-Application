import SwiftUI

struct VehicleView: View {
    
    let vehicle: Vehicle
    var textureControl = TextureControl()
    
    var body: some View {
        VStack(spacing: 0) {
            Text(vehicle.model.rawValue)
                .font(.system(size: 45, weight: .heavy, design: .monospaced))
                .foregroundColor(Color("riv_blue"))
                .offset(x: 0, y: 20)
            
            AtlasTexture(name: vehicle.imageName, control: textureControl)
                .aspectRatio(2, contentMode: .fit)
                .id(vehicle.model)
                .onAppear{
                    textureControl.set(percent: 1)
                }
        }
    }
}
