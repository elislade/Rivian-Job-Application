import SwiftUI

struct DefaultCharacteristicView: View {
    let c: Characteristic
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                c.characteristic.info.image
                Text(c.characteristic.info.name).fontWeight(.semibold)
                Spacer()
                Text("\(c.value?.description ?? "-")")
            }
            
            if c.descriptors.count > 0 {
                Divider()
                ForEach(c.descriptors) {
                    DescriptorView(desc: $0)
                }
            }
        }
    }
}
