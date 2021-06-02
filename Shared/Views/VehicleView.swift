import SwiftUI

struct VehicleView: View {
    
    let vehicle: Vehicle
    let textureControl = TextureControl()
    
    var body: some View {
        VStack(spacing: 0) {
            Text(vehicle.model.rawValue)
                .font(.system(size: 45, weight: .heavy, design: .monospaced))
                .foregroundColor(Color("riv_blue"))
                .offset(x: 0, y: 20)
            
            AtlasTexture(name: vehicle.imageName, control: textureControl)
                .aspectRatio(2, contentMode: .fit)
                .id(vehicle.model.rawValue)
                .onAppear{
                    textureControl.set(percent: 1)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        self.textureControl.set(percent: 0, animated: true)
                    }
                }
        }
    }
}
