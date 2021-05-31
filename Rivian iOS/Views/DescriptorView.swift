import SwiftUI

struct DescriptorView: View {
    
    let desc: Descriptor
    
    var body: some View {
        VStack {
            Text("\(desc.descriptor.uuid)").font(.footnote).opacity(0.6)
            Text(desc.descriptor.value.debugDescription)
        }
    }
}
