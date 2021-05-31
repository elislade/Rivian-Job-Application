import SwiftUI
import CoreBluetooth

struct ServiceView: View {
    
    @ObservedObject var service: Service
    @State private var isExpanded = true
    
    func discoverCharacteristics() {
        service.discoverCharacteristics(withUUIDS:
            [.r1t_main_location_id, .r1t_main_action_id]
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action:{ self.isExpanded.toggle() }){
                HStack {
                    service.service.info.image
                    Text(service.service.info.name)
                        .font(.footnote).fontWeight(.semibold)
                    Spacer()
                    Image(systemName: "chevron.down.circle.fill")
                        .resizable().scaledToFit().frame(width: 24)
                        .rotationEffect(Angle(degrees: isExpanded ? 180 : 0))
                }
                .frame(height: 50)
                .foregroundColor(.primary)
                .opacity(0.6)
            }
            
            if isExpanded {
                VStack(spacing: 10){
                    ForEach(service.characteristics) {
                        CharacteristicView(c: $0)
                    }
                }
                .padding(.bottom, 10.0)
                .transition(.hinge(.top))
            }
        }.onAppear(perform: discoverCharacteristics)
    }
}
