import SwiftUI

struct CharacteristicView: View {
    
    @EnvironmentObject private var vehicle: Vehicle
    
    let c: Characteristic
    
    var body: some View {
        ZStack {
            if c.id == .main_action_id(for: vehicle) {
                ActionCharacteristicView(c: c)
            } else if c.id == .main_location_id(for: vehicle) {
                LocationCharacteristicView(c: c)
            } else {
                DefaultCharacteristicView(c: c)
            }
        }
    }
}
