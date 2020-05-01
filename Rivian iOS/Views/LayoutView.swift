import SwiftUI

struct LayoutView<Content:View>: View {
    
    @Binding var axis:Axis
    
    var content:Content
    
    init(_ axis:Binding<Axis>, @ViewBuilder content:() -> Content) {
        self._axis = axis
        self.content = content()
    }
    
    var body: some View {
        Group {
            if axis == .horizontal {
                HStack(spacing: 0) { content }
            } else {
                VStack(spacing :0) { content }
            }
        }
    }
}
