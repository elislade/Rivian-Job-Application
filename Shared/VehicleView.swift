import SwiftUI

struct VehicleView: View {
    
    let vehicle: Vehicle
    let textureControl = TextureControl()
    
    @State private var percentComp: CGFloat = 0.0
    @State private var node: AtlasSKNode?
    
    var body: some View {
        VStack(spacing: 0) {
            Text(vehicle.name)
                .font(.system(size: 45, weight: .heavy, design: .monospaced))
                .foregroundColor(Color("riv_blue"))
                .offset(x: 0, y: 20)
            
            AtlasTexture(vehicle.imageName, control: textureControl)
                .aspectRatio(2, contentMode: .fit)
                .overlay(Color.white.opacity(0.01))
                .onAppear{
                    textureControl.set(percent: 1)
                    textureControl.set(percent: 0, animated: true)
                }
        }
    }
}
