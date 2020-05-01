import SwiftUI

struct CharacteristicView: View {
    @EnvironmentObject var vehicle:Vehicle
    @ObservedObject var c:Characteristic
    
    var body: some View {
        Group {
            if c.id == .main_action_id(for: vehicle) {
                ActionCharacteristicView(c: c, value: nil)
            }  else if c.id == .main_location_id(for: vehicle) {
                LocationCharacteristicView(c: c, value: nil)
            }  else {
                DefaultCharacteristicView(c: c)
            }
        }
        .padding()
        .background(Color(.systemBackground).opacity(0.5))
        .colorScheme(.dark)
        .cornerRadius(12)
    }
}
