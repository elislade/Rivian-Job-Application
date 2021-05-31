import SwiftUI

struct VehicleActionView: View {
    
    let characteristic: Characteristic
    var triggered: (Vehicle.Action) -> Void = {_ in}
    
    func send(_ action:Vehicle.Action){
        if self.characteristic.canSendWriteWithoutResponse {
            self.characteristic.write(
                data: action.data,
                type: .withoutResponse
            )
        }
    }
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(Vehicle.Action.allCases) { action in
                Button(action: { self.send(action) }) {
                    VStack(spacing: 10) {
                        action.image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 30)
                            .opacity(0.7)
                        Text(action.description.uppercased())
                            .fontWeight(.semibold)
                            .font(.caption)
                    }
                    .foregroundColor(.primary)
                    .frame(width: 90, height: 90)
                    .background(Color.secondary.opacity(0.3))
                    .cornerRadius(10)
                }
            }
        }
    }
}
