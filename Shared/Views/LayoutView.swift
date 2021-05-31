import SwiftUI

struct LayoutView<Content:View>: View {
    
    let axis: Axis
    let content: Content
    
    init(_ axis: Axis, @ViewBuilder content: () -> Content) {
        self.axis = axis
        self.content = content()
    }
    
    var body: some View {
        Group {
            if axis == .horizontal {
                HStack(spacing: 0) { content }
            } else {
                VStack(spacing: 0) { content }
            }
        }
    }
}
